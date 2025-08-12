use crate::plotter::AXIS_MARGINS;
use lib::{errors::Error, langs::BenchmarkLanguage, paths::RAW_PATH};
use std::{cmp::Ordering, fs::read_dir, path::PathBuf};

#[derive(Debug)]
pub struct BenchResult {
    pub benchmark: String,
    pub data: Vec<BenchData>,
}

#[derive(Debug)]
pub struct BenchData {
    pub lang: BenchmarkLanguage,
    pub mean: f64,
    pub adjusted_mean: f64,
}

impl BenchResult {
    pub fn load_dir() -> Result<Vec<BenchResult>, Error> {
        let dir_path = PathBuf::from(RAW_PATH);
        let dir_contents = read_dir(&dir_path).map_err(|err| Error::read_dir(&dir_path, err))?;
        let mut results = vec![];
        for bench_dir in dir_contents {
            let bench_name = bench_dir
                .map_err(|_| Error::path_access(&dir_path, "Read Dir Name"))?
                .file_name()
                .into_string()
                .map_err(|_| Error::path_access(&dir_path, "Read Dir Name (as String)"))?;
            results.push(BenchResult::new(&bench_name)?)
        }

        let avg = Self::get_geometric_mean(&results, false);
        let avg_nogoto = Self::get_geometric_mean(&results, true);

        let avg_langs = avg_nogoto
            .data
            .iter()
            .map(|dat| dat.lang)
            .collect::<Vec<BenchmarkLanguage>>();
        let lang_ind = |lang: &BenchmarkLanguage| {
            avg_langs
                .iter()
                .enumerate()
                .find(|(_, lang2)| lang == *lang2)
                .unwrap()
                .0
        };

        for res in results.iter_mut() {
            res.data
                .sort_by(|dat1, dat2| lang_ind(&dat1.lang).cmp(&lang_ind(&dat2.lang)));
        }

        results.push(avg);
        results.push(avg_nogoto);
        Ok(results)
    }

    fn get_geometric_mean(data: &[Self], skip_goto: bool) -> Self {
        let mut avg_data = vec![];
        for lang in BenchmarkLanguage::all() {
            if lang == BenchmarkLanguage::Scc {
                continue;
            }
            let lang_results = data
                .iter()
                .filter_map(|res| {
                    if skip_goto && res.benchmark.contains("Goto") {
                        None
                    } else {
                        res.data.iter().find(|dat| dat.lang == lang)
                    }
                })
                .filter(|dat| !dat.mean.is_nan() && !dat.adjusted_mean.is_nan())
                .collect::<Vec<&BenchData>>();
            let lang_mean = lang_results.iter().fold(0.0, |mean, dat| mean + dat.mean)
                / lang_results.len() as f64;
            let lang_adjusted_mean = lang_results
                .iter()
                .fold(1.0, |mean, dat| mean + dat.adjusted_mean)
                / lang_results.len() as f64;
            avg_data.push(BenchData {
                lang,
                mean: lang_mean,
                adjusted_mean: lang_adjusted_mean,
            });
        }
        avg_data.sort_by(|dat1, dat2| dat1.adjusted_mean.partial_cmp(&dat2.adjusted_mean).unwrap());
        let suffix = if skip_goto { "" } else { " with Goto" };
        BenchResult {
            benchmark: format!("Geometric Mean{suffix}"),
            data: avg_data,
        }
    }

    pub fn new(name: &str) -> Result<BenchResult, Error> {
        let bench_path = PathBuf::from(RAW_PATH).join(name);
        let dir_contents =
            read_dir(&bench_path).map_err(|err| Error::read_dir(&bench_path, err))?;

        let mut paths = vec![];
        for csv_path in dir_contents {
            let csv_path = csv_path
                .map_err(|_| Error::path_access(&bench_path, "Read CSV file Path"))?
                .path();
            paths.push(csv_path);
        }

        let scc_ind = paths
            .iter()
            .enumerate()
            .find(|(_, path)| path.ends_with(format!("{name}_scc.csv",)))
            .ok_or(Error::missing_lang(BenchmarkLanguage::Scc))?
            .0;
        let scc_path = paths.remove(scc_ind);
        let baseline = BenchData::new_baseline(&scc_path)?;

        let mut data = vec![];
        for path in paths {
            data.push(BenchData::new(&path, &baseline)?);
        }

        for lang in BenchmarkLanguage::all() {
            if lang == BenchmarkLanguage::Scc || data.iter().find(|dat| dat.lang == lang).is_some()
            {
                continue;
            }

            data.push(BenchData::empty(&lang));
        }

        Ok(BenchResult {
            benchmark: name.to_owned(),
            data,
        })
    }

    pub fn get_min_max(benches: &[Self]) -> (f64, f64) {
        let y_max = benches
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
            .max_by(|max1, max2| max1.partial_cmp(&max2).unwrap_or(Ordering::Less))
            .unwrap()
            + AXIS_MARGINS;
        let y_min = benches
            .iter()
            .map(|res| {
                res.data
                    .iter()
                    .min_by(|dat1, dat2| {
                        dat1.adjusted_mean
                            .partial_cmp(&dat2.adjusted_mean)
                            .unwrap_or(Ordering::Greater)
                    })
                    .unwrap()
                    .adjusted_mean
            })
            .min_by(|max1, max2| max1.partial_cmp(&max2).unwrap_or(Ordering::Greater))
            .unwrap()
            + AXIS_MARGINS;

        (y_max, y_min)
    }
}

impl BenchData {
    pub fn new(path: &PathBuf, baseline: &BenchData) -> Result<BenchData, Error> {
        let mut data = BenchData::new_baseline(path)?;
        let diff_mean = baseline.mean / data.mean;
        data.adjusted_mean = diff_mean.log10();

        Ok(data)
    }

    pub fn new_baseline(path: &PathBuf) -> Result<BenchData, Error> {
        let stem = path
            .file_stem()
            .ok_or(Error::path_access(path, "Read CSV file name"))?
            .to_str()
            .ok_or(Error::path_access(path, "Read CSV file name (as string)"))?;
        let lang_ext = stem
            .split_once("_")
            .ok_or(Error::unknown_lang("read lang extension", &stem))?
            .1;
        let lang = BenchmarkLanguage::from_suffix(lang_ext)?;

        let data_contents = std::fs::read_to_string(path)
            .map_err(|err| Error::file_access(&path, "Read CSV data", err))?;
        let mut data_lines = data_contents.split_terminator("\n");
        data_lines.next();
        let mut data = data_lines
            .next()
            .ok_or(Error::csv(&path, "Missing contents"))?
            .split_terminator(",");
        data.next(); //command
        let mean_str = data.next().ok_or(Error::csv(&path, "Missing mean"))?;
        let mean = mean_str
            .parse::<f64>()
            .map_err(|_| Error::ParseFloat(mean_str.to_owned()))?;
        Ok(BenchData {
            lang,
            mean,
            adjusted_mean: 0.0,
        })
    }

    pub fn empty(lang: &BenchmarkLanguage) -> BenchData {
        BenchData {
            lang: *lang,
            mean: f64::NAN,
            adjusted_mean: f64::NAN,
        }
    }
}
