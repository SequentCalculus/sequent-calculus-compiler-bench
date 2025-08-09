use crate::bench_result::BenchResult;
use lib::{errors::Error, langs::BenchmarkLanguage, paths::REPORTS_PATH};
use plotters::{
    backend::SVGBackend,
    chart::ChartBuilder,
    drawing::IntoDrawingArea,
    prelude::{IntoFont, IntoTextStyle, PathElement, Rectangle},
    style::{BLACK, Color, RED, RGBColor, WHITE},
};
use std::{fs::create_dir_all, path::PathBuf};

const PLOT_RES: (u32, u32) = (600, 400);
const MARGIN: u32 = 25;
const MARGIN_TOP: u32 = 5;
const CAPTION_SIZE: u32 = 40;
const LABEL_SIZE: u32 = 20;
const LABEL_FONT_SIZE: u32 = 20;
const BAR_THICKNESS: f64 = 0.8;
pub const AXIS_MARGINS: f64 = 0.1;
const CROSS_HEIGHT: f64 = 0.2;
const CROSS_THICKNESS: u32 = 5;

fn lang_color(lang: &BenchmarkLanguage) -> RGBColor {
    match lang {
        BenchmarkLanguage::Scc => BLACK,
        BenchmarkLanguage::OCaml => RGBColor(242, 145, 00),
        BenchmarkLanguage::Effekt => RGBColor(66, 36, 70),
        BenchmarkLanguage::Koka => RGBColor(27, 66, 83),
        BenchmarkLanguage::Rust => RGBColor(143, 30, 28),
        BenchmarkLanguage::SmlNj => RGBColor(143, 143, 143),
        BenchmarkLanguage::SmlMlton => RGBColor(37, 177, 228),
    }
}

pub fn generate_plot(res: BenchResult, y_min: f64, y_max: f64) -> Result<(), Error> {
    let mut out_path = PathBuf::from(REPORTS_PATH);
    create_dir_all(&out_path).map_err(|_| Error::path_access(&out_path, "create reports path"))?;
    out_path = out_path.join(&res.benchmark);
    out_path.set_extension("svg");

    let root = SVGBackend::new(&out_path, PLOT_RES).into_drawing_area();
    root.fill(&WHITE)
        .map_err(|err| Error::plotters(&res.benchmark, "fill drawing area", err))?;

    let x_min = 1.0 - BAR_THICKNESS + AXIS_MARGINS;
    let x_max = res.data.len() as f64 + BAR_THICKNESS;

    let mut chart = ChartBuilder::on(&root)
        .margin(MARGIN)
        .margin_top(MARGIN_TOP)
        .caption(&res.benchmark, ("sans-serif", CAPTION_SIZE).into_font())
        .x_label_area_size(LABEL_SIZE)
        .y_label_area_size(LABEL_SIZE)
        .margin_right(0)
        .build_cartesian_2d(x_min..x_max, y_min..y_max)
        .map_err(|err| Error::plotters(&res.benchmark, "build coordinates", err))?;

    chart
        .configure_mesh()
        .disable_x_mesh()
        .y_max_light_lines(0)
        .y_label_formatter(&|ind| {
            if ind.round() == *ind {
                10_f64.powf(*ind).to_string()
            } else {
                "".to_owned()
            }
        })
        .x_label_formatter(&|ind| {
            if ind.round() == *ind && *ind >= 1.0 {
                res.data[(*ind) as usize - 1].lang.to_string()
            } else {
                "".to_owned()
            }
        })
        .y_label_style(("sans-serif", LABEL_FONT_SIZE).into_text_style(&root))
        .x_label_style(("sans-serif", LABEL_FONT_SIZE).into_text_style(&root))
        .draw()
        .map_err(|err| Error::plotters(&res.benchmark, "configure mesh", err))?;

    let x_left = |ind: usize| (ind + 1) as f64 - (BAR_THICKNESS / 2.0);
    let x_right = |ind: usize| (ind + 1) as f64 + (BAR_THICKNESS / 2.0);

    chart
        .draw_series(res.data.iter().enumerate().filter_map(|(ind, dat)| {
            (!dat.adjusted_mean.is_nan()).then_some({
                Rectangle::new(
                    [(x_left(ind), 0.0), (x_right(ind), dat.adjusted_mean)],
                    lang_color(&dat.lang).filled(),
                )
            })
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw means", err))?;

    chart
        .draw_series(res.data.iter().enumerate().filter_map(|(ind, dat)| {
            dat.adjusted_mean.is_nan().then_some(PathElement::new(
                vec![(x_left(ind), -CROSS_HEIGHT), (x_right(ind), CROSS_HEIGHT)],
                RED.stroke_width(CROSS_THICKNESS),
            ))
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw crosses", err))?;

    chart
        .draw_series(res.data.iter().enumerate().filter_map(|(ind, dat)| {
            dat.adjusted_mean.is_nan().then_some(PathElement::new(
                vec![(x_left(ind), CROSS_HEIGHT), (x_right(ind), -CROSS_HEIGHT)],
                RED.stroke_width(CROSS_THICKNESS),
            ))
        }))
        .map_err(|err| Error::plotters(&res.benchmark, "Draw crosses", err))?;

    root.present()
        .map_err(|err| Error::file_access(&out_path, "write plot to file", err))?;
    Ok(())
}
