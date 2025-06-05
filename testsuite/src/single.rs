use lib::{
    benchmark::Benchmark,
    errors::Error,
    test_utils::{setup, TestResult},
};
use std::str;

fn main() -> Result<(), Error> {
    let mut args = std::env::args();
    args.next();
    let bench_name = match args.next() {
        Some(n) => n,
        None => return Ok(()),
    };

    setup()?;

    println!("Testing {bench_name}");
    let bench = Benchmark::new(&bench_name)?;
    for lang in bench.languages.iter() {
        bench.compile(lang)?;
        let res = bench.run(lang, true)?;
        let res_str = str::from_utf8(&res.stdout)
            .expect("Could not read output")
            .trim();
        print!("\t");
        TestResult::from_eq(&res_str, &bench.config.expected).report(&lang.to_string());
    }
    Ok(())
}
