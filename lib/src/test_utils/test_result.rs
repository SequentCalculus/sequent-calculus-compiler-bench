use std::fmt;

pub enum TestResult {
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
