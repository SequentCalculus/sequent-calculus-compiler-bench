mod errors;

use errors::Error;
use lib::benchmark::Benchmark;

fn setup() -> Result<(), Error> {
    let working_dir = std::env::current_dir()
        .map_err(|err| Error::working_dir("get", err))
        .map(|dir| dir.join("../"))?;
    std::env::set_current_dir(working_dir).map_err(|err| Error::working_dir("set", err))?;
    Ok(())
}

fn main() -> Result<(), Error> {
    setup()?;

    let tests = Benchmark::load_all();
    for test in tests {
        test.compile_all();
        let results = test.run_all().expect("Could not run benchmark");
        for result in results {
            assert_eq!(result.stdout, test.config.expected.as_bytes())
        }
    }
    Ok(())
}
