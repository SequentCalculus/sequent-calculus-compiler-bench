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
        for bench in dir_contents {
            let bench_name = bench
                .map_err(|_| Error::path_access(&dir_path, "Read Dir Name"))?
                .path();
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

    pub fn new(path: &PathBuf) -> Result<BenchResult, Error> {
        let name = path
            .file_stem()
            .ok_or(Error::path_access(path, "Read CSV file name"))?
            .to_str()
            .ok_or(Error::path_access(path, "Read CSV file name (as string)"))?;

        let data_contents = std::fs::read_to_string(path)
            .map_err(|err| Error::file_access(&path, "Read CSV data", err))?;
        let mut data_lines = data_contents.split_terminator("\n");
        // skip header
        data_lines.next();

        let mut data_all = Vec::new();
        for line in data_lines {
            let mut data = line.split_terminator(",");
            let command = match data.next() {
                None => continue,
                Some(command) => command,
            };

            let bin_name = command
                .split_terminator("/")
                .nth(3)
                .ok_or(Error::wrong_format_command(command))?;
            let lang = match bin_name
                .split(" ")
                .next()
                .ok_or(Error::wrong_format_command(command))?
                .split_once("_")
            {
                None => BenchmarkLanguage::Scc,
                Some((_, suffix)) => BenchmarkLanguage::from_suffix(suffix)?,
            };

            data_all.push(BenchData::new(data, lang, path)?);
        }

        let index_scc = data_all
            .iter()
            .enumerate()
            .find(|(_, datum)| datum.lang == BenchmarkLanguage::Scc)
            .ok_or(Error::missing_lang(BenchmarkLanguage::Scc))?
            .0;
        let baseline = data_all.remove(index_scc);
        let mut data: Vec<BenchData> = data_all
            .into_iter()
            .map(|datum| datum.to_relative(&baseline))
            .collect();

        for lang in BenchmarkLanguage::all() {
            if lang == BenchmarkLanguage::Scc
                || data.iter().find(|datum| datum.lang == lang).is_some()
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
    pub fn new<'a>(
        mut data: impl Iterator<Item = &'a str>,
        lang: BenchmarkLanguage,
        path: &PathBuf,
    ) -> Result<BenchData, Error> {
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

    pub fn to_relative(mut self, baseline: &BenchData) -> BenchData {
        let diff_mean = baseline.mean / self.mean;
        self.adjusted_mean = diff_mean.log10();

        self
    }

    pub fn empty(lang: &BenchmarkLanguage) -> BenchData {
        BenchData {
            lang: *lang,
            mean: f64::NAN,
            adjusted_mean: f64::NAN,
        }
    }
}
