use clap::Parser;
use lib::{benchmark::Benchmark, errors::Error, langs::BenchmarkLanguage, paths::REPORTS_PATH};
use plotters::{
    chart::ChartBuilder,
    prelude::{
        BLACK, BLUE, BitMapBackend, CandleStick, IntoDrawingArea, IntoFont, LineSeries, RED,
        RGBColor, Rectangle, WHITE,
    },
    style::Color,
};
use std::{
    convert::Infallible,
    fs::{create_dir_all, read_to_string},
    path::PathBuf,
    str::FromStr,
};

mod bench_result;
use bench_result::BenchResult;

const PLOT_RES: (u32, u32) = (640, 480);
const FONT_SIZE: u32 = 40;
const LABEL_SIZE: u32 = 20;
const NUM_X_LABELS: usize = 10;
const NUM_Y_LABELS: usize = 10;
const MARGIN: u32 = 10;

const COLOR_MEANS: RGBColor = RED;
const COLOR_STDDEV: RGBColor = BLUE;

//pub fn exec(cmd: Args) -> Result<(), Error> {
//    let examples;
//    if let Some(name) = cmd.name {
//        examples = vec![Benchmark::new(&name, &[])?];
//    } else {
//        examples = Benchmark::load_all(&[], &[])?;
//    }
//    for example in examples {
//        if !example.results_exist()? {
//            println!("Skipping {}, no results found", example.name);
//            continue;
//        }
//        let lang = BenchmarkLanguage::Scc;
//        let results =
//            BenchResult::from_file(example.result_path(&lang)?, example.report_path(&lang)?);
//        results.generate_plot();
//        println!("generated plot for {}", example.name);
//    }
//    Ok(())
//}

fn main() -> Result<(), Error> {
    let results = BenchResult::load_dir()?;
    println!("{results:?}");
    Ok(())
}
