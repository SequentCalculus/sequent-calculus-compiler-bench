use lib::errors::Error;

mod bench_result;
mod plotter;
use bench_result::BenchResult;
use plotter::generate_plot;

fn main() -> Result<(), Error> {
    let results = BenchResult::load_dir()?;
    let (y_max, y_min) = BenchResult::get_min_max(&results);

    for res in results {
        generate_plot(res, y_min, y_max)?;
    }
    Ok(())
}
