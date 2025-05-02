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

    pub fn report(&self, test_name: &str) {
        print!("Test {test_name}.........");
        match self {
            TestResult::Success => println!("\x1b[32mOk\x1b[0m"),
            TestResult::Fail(msg) => println!("\x1b[31mfail\x1b[0m\n{msg}"),
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
        test.compile_all()?;
        let results = test.run_all(true)?;
        for result in results {
            let res_str = str::from_utf8(&result.stdout).expect("Could not read output");
            let res = TestResult::from_eq(&res_str, &test.config.expected);
            if matches!(res, TestResult::Fail(_)) {
                num_fail += 1;
            };
            res.report(&test.name);
        }
    }
    println!("");
    println!(
        "Ran {} tests, {} success, {} fail",
        num_tests,
        num_tests - num_fail,
        num_fail
    );
    if num_fail != 0 {
        panic!("Not all tests ran successfully")
    }
    Ok(())
}
