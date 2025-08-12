use lib::errors::Error;

mod bench_result;
mod plotter;
use bench_result::BenchResult;
use plotter::generate_plot;

fn main() -> Result<(), Error> {
    let results = BenchResult::load_dir()?;
    let (mut y_max, mut y_min) = BenchResult::get_min_max(&results);

    for res in results {
        if res.benchmark.contains("Mean") {
            y_max = res
                .data
                .iter()
                .map(|dat| dat.adjusted_mean)
                .max_by(|m1, m2| m1.partial_cmp(&m2).unwrap())
                .unwrap_or(f64::INFINITY - 0.1)
                + 0.1;
            y_min = res
                .data
                .iter()
                .map(|dat| dat.adjusted_mean)
                .min_by(|m1, m2| m1.partial_cmp(&m2).unwrap())
                .unwrap_or(f64::NEG_INFINITY + 0.02)
                - 0.02;
        }
        generate_plot(res, y_min, y_max)?;
    }
    Ok(())
}
