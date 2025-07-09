use crate::bench_result::BenchResult;
use lib::{errors::Error, langs::BenchmarkLanguage, paths::REPORTS_PATH};
use plotters::{
    backend::BitMapBackend,
    chart::ChartBuilder,
    drawing::IntoDrawingArea,
    element::BackendCoordOnly,
    prelude::{ErrorBar, Histogram, IntoFont, IntoSegmentedCoord, Rectangle},
    style::{BLUE, Color, GREEN, RED, RGBColor, WHITE},
};
use std::{collections::HashSet, fs::create_dir_all, path::PathBuf};

const PLOT_RES: (u32, u32) = (640, 480);
const MARGIN: u32 = 10;
const FONT_SIZE: u32 = 40;
const LABEL_SIZE: u32 = 20;
const COLOR_SLOWER: RGBColor = GREEN;
const COLOR_FASTER: RGBColor = RED;
const BAR_THICKNESS: f64 = 0.6;

pub fn generate_plot(res: BenchResult) -> Result<(), Error> {
    let mut out_path = PathBuf::from(REPORTS_PATH);
    create_dir_all(&out_path).map_err(|_| Error::path_access(&out_path, "create reports path"))?;
    out_path = out_path.join(&res.benchmark);
    out_path.set_extension("png");

    let root = BitMapBackend::new(&out_path, PLOT_RES).into_drawing_area();
    root.fill(&WHITE)
        .map_err(|err| Error::plotters(&res.benchmark, "fill drawing area", err))?;

    let sc_res = res
        .data
        .iter()
        .find(|dat| dat.lang == BenchmarkLanguage::Scc)
        .ok_or(Error::missing_lang(BenchmarkLanguage::Scc))?;

    let data_formatted = res
        .data
        .iter()
        .filter(|dat| dat.lang != BenchmarkLanguage::Scc)
        .map(|dat| (dat.lang.to_string(), dat.mean - sc_res.mean, dat.stddev))
        .collect::<Vec<(String, f64, f64)>>();

    let y_max = data_formatted
        .iter()
        .max_by(|dat1, dat2| dat1.1.partial_cmp(&dat2.1).unwrap())
        .unwrap()
        .1
        .ceil();
    let y_min = data_formatted
        .iter()
        .min_by(|dat1, dat2| dat1.1.partial_cmp(&dat2.1).unwrap())
        .unwrap()
        .1
        .floor();
    let x_max = res.data.len() as f64;

    let mut chart = ChartBuilder::on(&root)
        .margin(MARGIN)
        .caption(&res.benchmark, ("sans-serif", FONT_SIZE).into_font())
        .x_label_area_size(LABEL_SIZE)
        .y_label_area_size(LABEL_SIZE)
        .build_cartesian_2d(0.0..x_max, y_min..y_max)
        .map_err(|err| Error::plotters(&res.benchmark, "build coordinates", err))?;

    chart
        .configure_mesh()
        .y_desc("Time Difference")
        .x_label_formatter(&|ind| {
            if ind < &1.0 {
                return "".to_owned();
            }
            data_formatted
                .get((*ind - 1.0).round() as usize)
                .map(|res| res.0.clone())
                .unwrap_or("".to_owned())
        })
        .draw()
        .map_err(|err| Error::plotters(&res.benchmark, "configure mesh", err))?;

    chart
        .draw_series(data_formatted.iter().enumerate().map(|(ind, dat)| {
            Rectangle::new(
                [
                    ((ind + 1) as f64 - (BAR_THICKNESS / 2.0), 0.0),
                    ((ind + 1) as f64 + (BAR_THICKNESS / 2.0), dat.1),
                ],
                if dat.1 > 0.0 {
                    COLOR_SLOWER.filled()
                } else {
                    COLOR_FASTER.filled()
                },
            )
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw plot", err))?;

    root.present()
        .map_err(|err| Error::file_access(&out_path, "write plot to file", err))?;
    Ok(())
}
