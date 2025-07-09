use lib::{
    config::Config,
    errors::Error,
    langs::BenchmarkLanguage,
    paths::{HYPERFINE_PATH, SUITE_PATH},
};
use std::{fs::read_dir, path::PathBuf};

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
    pub stddev: f64,
    pub adjusted_stddev: f64,
}

impl BenchResult {
    pub fn load_dir() -> Result<Vec<BenchResult>, Error> {
        let dir_path = PathBuf::from(HYPERFINE_PATH);
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
        Ok(results)
    }

    pub fn new(name: &str) -> Result<BenchResult, Error> {
        let bench_path = PathBuf::from(HYPERFINE_PATH).join(name);
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

        data.sort_by(|dat1, dat2| dat1.lang.to_string().cmp(&dat2.lang.to_string()));

        Ok(BenchResult {
            benchmark: name.to_owned(),
            data,
        })
    }
}

impl BenchData {
    pub fn new(path: &PathBuf, baseline: &BenchData) -> Result<BenchData, Error> {
        let mut data = BenchData::new_baseline(path)?;
        data.adjusted_mean = data.mean - baseline.mean;

        let self_variance = data.stddev * data.stddev;
        let base_variance = baseline.stddev * baseline.stddev;
        let diff_variance = self_variance + base_variance;
        data.adjusted_stddev = diff_variance.sqrt();
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
        let stddev_str = data.next().ok_or(Error::csv(&path, "Missing stddev"))?;
        let stddev = stddev_str
            .parse::<f64>()
            .map_err(|_| Error::ParseFloat(stddev_str.to_owned()))?;
        Ok(BenchData {
            lang,
            mean,
            stddev,
            adjusted_mean: 0.0,
            adjusted_stddev: 0.0,
        })
    }
}
