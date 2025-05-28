use lib::{benchmark::Benchmark, errors::Error};
use std::{fmt, str};

enum TestResult {
    Success,
    Fail(String),
}

impl TestResult {
    pub fn from_eq<T, U>(result: &T, expected: &U) -> TestResult
    where
        T: fmt::Display,
        U: fmt::Display,
        T: PartialEq<U>,
    {
        if result == expected {
            TestResult::Success
        } else {
            TestResult::Fail(format!(
                "result != expected:\n\tresult:{result}\n\texpected:{expected}"
            ))
        }
    }

    pub fn from_err<T: std::error::Error>(err: T) -> TestResult {
        TestResult::Fail(err.to_string())
    }

    pub fn report(&self, test_name: &str) {
        print!("Test {test_name}.........");
        match self {
            TestResult::Success => println!("\x1b[32mOk\x1b[0m"),
            TestResult::Fail(msg) => {
                println!("\x1b[31mfail\x1b[0m\n\t{}", msg.replace('\n', "\n\t"))
            }
        };
    }
}

fn setup() -> Result<(), Error> {
    let working_dir = std::env::current_dir()
        .map_err(|err| Error::working_dir("get", err))
        .map(|dir| dir.join("../"))?;
    std::env::set_current_dir(working_dir).map_err(|err| Error::working_dir("set", err))?;
    Ok(())
}

fn main() -> Result<(), Error> {
    setup()?;

    let tests = Benchmark::load_all()?;
    let num_tests = tests.len();
    let mut num_fail = 0;
    for test in tests {
        println!("testing {}", test.name);
        for lang in test.languages.iter() {
            let report_format = |res: TestResult| {
                print!("\t");
                res.report(&lang.to_string().replace('\n', "\n\t"));
            };
            match test.compile(lang) {
                Ok(_) => (),
                Err(err) => {
                    num_fail += 1;
                    report_format(TestResult::from_err(err));
                    continue;
                }
            };
            let result = match test.run(lang, true) {
                Ok(res) => res,
                Err(err) => {
                    report_format(TestResult::from_err(err));
                    num_fail += 1;
                    continue;
                }
            };
            let res_str = str::from_utf8(&result.stdout)
                .expect("Could not read output")
                .trim();
            let res = TestResult::from_eq(&res_str, &test.config.expected);
            if matches!(res, TestResult::Fail(_)) {
                num_fail += 1;
            };
            report_format(res);
        }
    }
    println!("");
    println!(
        "Ran {} tests, {} success, {}{} fail{}",
        num_tests,
        num_tests - num_fail,
        if num_fail > 0 { "\x1b[31m" } else { "" },
        num_fail,
        if num_fail > 0 { "\x1b[0m" } else { "" },
    );
    if num_fail != 0 {
        panic!("Not all tests ran successfully")
    }
    Ok(())
}
