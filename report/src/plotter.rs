use crate::bench_result::BenchResult;
use lib::{errors::Error, langs::BenchmarkLanguage, paths::REPORTS_PATH};
use plotters::{
    backend::BitMapBackend,
    chart::ChartBuilder,
    drawing::IntoDrawingArea,
    prelude::{IntoFont, PathElement, Rectangle},
    style::{BLACK, Color, GREEN, RED, RGBColor, ShapeStyle, WHITE},
};
use std::{fs::create_dir_all, path::PathBuf};

const PLOT_RES: (u32, u32) = (600, 600);
const MARGIN: u32 = 50;
const FONT_SIZE: u32 = 40;
const LABEL_SIZE: u32 = 20;
const BAR_THICKNESS: f64 = 0.8;
const AXIS_MARGINS: f64 = 0.1;
const COLOR_STDDEV: RGBColor = BLACK;

fn lang_color(lang: &BenchmarkLanguage) -> ShapeStyle {
    match lang {
        BenchmarkLanguage::Scc => BLACK.filled(),
        BenchmarkLanguage::OCaml => RGBColor(242, 145, 00).filled(),
        BenchmarkLanguage::Effekt => RGBColor(66, 36, 70).filled(),
        BenchmarkLanguage::Koka => RGBColor(27, 66, 83).filled(),
        BenchmarkLanguage::Rust => RGBColor(143, 30, 28).filled(),
        BenchmarkLanguage::SmlNj => RGBColor(143, 143, 143).filled(),
        BenchmarkLanguage::SmlMlton => RGBColor(37, 177, 228).filled(),
    }
}

pub fn generate_plot(res: BenchResult) -> Result<(), Error> {
    let mut out_path = PathBuf::from(REPORTS_PATH);
    create_dir_all(&out_path).map_err(|_| Error::path_access(&out_path, "create reports path"))?;
    out_path = out_path.join(&res.benchmark);
    out_path.set_extension("png");

    let root = BitMapBackend::new(&out_path, PLOT_RES).into_drawing_area();
    root.fill(&WHITE)
        .map_err(|err| Error::plotters(&res.benchmark, "fill drawing area", err))?;

    let y_max = res
        .data
        .iter()
        .max_by(|dat1, dat2| dat1.adjusted_mean.partial_cmp(&dat2.adjusted_mean).unwrap())
        .unwrap()
        .adjusted_mean
        + AXIS_MARGINS;
    let y_min = res
        .data
        .iter()
        .min_by(|dat1, dat2| dat1.adjusted_mean.partial_cmp(&dat2.adjusted_mean).unwrap())
        .unwrap()
        .adjusted_mean
        - AXIS_MARGINS;
    let x_min = 1.0 - BAR_THICKNESS + AXIS_MARGINS;
    let x_max = res.data.len() as f64 + BAR_THICKNESS;

    let mut chart = ChartBuilder::on(&root)
        .margin(MARGIN)
        .caption(&res.benchmark, ("sans-serif", FONT_SIZE).into_font())
        .x_label_area_size(LABEL_SIZE)
        .y_label_area_size(LABEL_SIZE)
        .margin_right(0)
        .build_cartesian_2d(x_min..x_max, y_min..y_max)
        .map_err(|err| Error::plotters(&res.benchmark, "build coordinates", err))?;

    chart
        .configure_mesh()
        .disable_x_mesh()
        .y_max_light_lines(0)
        .x_label_formatter(&|ind| {
            if ind < &1.0 {
                return "".to_owned();
            }
            res.data
                .get((*ind - 1.0).round() as usize)
                .map(|res| res.lang.to_string())
                .unwrap_or("".to_owned())
        })
        .draw()
        .map_err(|err| Error::plotters(&res.benchmark, "configure mesh", err))?;

    chart
        .draw_series(res.data.iter().enumerate().map(|(ind, dat)| {
            Rectangle::new(
                [
                    ((ind + 1) as f64 - (BAR_THICKNESS / 2.0), 0.0),
                    ((ind + 1) as f64 + (BAR_THICKNESS / 2.0), dat.adjusted_mean),
                ],
                lang_color(&dat.lang),
            )
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw means", err))?;

    chart
        .draw_series(res.data.iter().enumerate().map(|(ind, dat)| {
            let x = (ind + 1) as f64;
            let y_end = if dat.adjusted_mean < 0.0 {
                dat.adjusted_mean - dat.adjusted_stddev
            } else {
                dat.adjusted_mean + dat.adjusted_stddev
            };
            PathElement::new([(x, dat.adjusted_mean), (x, y_end)], COLOR_STDDEV)
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw Stddev", err))?;

    root.present()
        .map_err(|err| Error::file_access(&out_path, "write plot to file", err))?;
    Ok(())
}
