use lib::errors::Error;

mod bench_result;
mod plotter;
use bench_result::BenchResult;
use plotter::generate_plot;

fn main() -> Result<(), Error> {
    let results = BenchResult::load_dir()?;
    for res in results {
        generate_plot(res)?;
    }
    Ok(())
}
