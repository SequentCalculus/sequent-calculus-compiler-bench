use lib::errors::Error;
use std::cmp::Ordering;

mod bench_result;
mod plotter;
use bench_result::BenchResult;
use plotter::AXIS_MARGINS;
use plotter::generate_plot;

fn main() -> Result<(), Error> {
    let results = BenchResult::load_dir()?;
    let y_max = results
        .iter()
        .map(|res| {
            res.data
                .iter()
                .max_by(|dat1, dat2| {
                    dat1.adjusted_mean
                        .partial_cmp(&dat2.adjusted_mean)
                        .unwrap_or(Ordering::Less)
                })
                .unwrap()
                .adjusted_mean
        })
        .max_by(|max1, max2| max1.partial_cmp(&max2).unwrap())
        .unwrap()
        + AXIS_MARGINS;
    let y_min = results
        .iter()
        .map(|res| {
            res.data
                .iter()
                .min_by(|dat1, dat2| {
                    dat1.adjusted_mean
                        .partial_cmp(&dat2.adjusted_mean)
                        .unwrap_or(Ordering::Less)
                })
                .unwrap()
                .adjusted_mean
        })
        .min_by(|max1, max2| max1.partial_cmp(&max2).unwrap())
        .unwrap()
        + AXIS_MARGINS;

    /*let y_min = res
    .data
    .iter()
    .min_by(|dat1, dat2| {
        dat1.adjusted_mean
            .partial_cmp(&dat2.adjusted_mean)
            .unwrap_or(Ordering::Greater)
    })
    .unwrap()
    .adjusted_mean
    - AXIS_MARGINS;*/

    for res in results {
        generate_plot(res, y_min, y_max)?;
    }
    Ok(())
}
