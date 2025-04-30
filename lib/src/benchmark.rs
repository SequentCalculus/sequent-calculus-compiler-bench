use super::{
    config::Config,
    paths::{BIN_PATH, HYPERFINE_PATH, SUITE_PATH},
};
use std::{
    fs::{create_dir_all, read_dir},
    path::PathBuf,
    process::Command,
};

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum BenchmarkLanguage {
    Sc,
    Rust,
}

impl BenchmarkLanguage {
    fn from_ext(ext: &str) -> Option<BenchmarkLanguage> {
        match ext {
            "sc" => Some(BenchmarkLanguage::Sc),
            "rs" => Some(BenchmarkLanguage::Rust),
            _ => None,
        }
    }

    fn ext(&self) -> &str {
        match self {
            BenchmarkLanguage::Sc => "sc",
            BenchmarkLanguage::Rust => "rs",
        }
    }

    fn compile_cmd(&self, source_file: &PathBuf, out_file: &PathBuf) -> Command {
        match self {
            BenchmarkLanguage::Sc => {
                let mut cmd = Command::new("grokking");
                cmd.arg("codegen");
                cmd.arg(source_file);
                cmd.arg("-o");
                cmd.arg(out_file);
                cmd
            }
            BenchmarkLanguage::Rust => {
                let mut cmd = Command::new("rustc");
                cmd.arg(source_file);
                cmd.arg("-o");
                cmd.arg(out_file);
                cmd
            }
        }
    }
}

pub struct Benchmark {
    pub name: String,
    pub base_path: PathBuf,
    pub languages: Vec<BenchmarkLanguage>,
    pub config: Config,
}

impl Benchmark {
    pub fn new(name: &str) -> Option<Benchmark> {
        let base_path = PathBuf::from(SUITE_PATH).join(name);

        let mut config_path = base_path.clone().join(name);
        config_path.set_extension("args");
        let config = Config::from_file(config_path);

        let dir_contents = read_dir(&base_path).ok()?;
        let mut languages = vec![];
        for file in dir_contents {
            let file_path = file.ok()?.path();
            let ext = file_path.extension()?.to_str()?;
            if ext == "args" {
                continue;
            }

            if let Some(lang) = BenchmarkLanguage::from_ext(ext) {
                languages.push(lang);
            }
        }
        Some(Benchmark {
            name: name.to_owned(),
            base_path,
            languages,
            config,
        })
    }

    pub fn bin_path(&self, lang: &BenchmarkLanguage) -> Option<PathBuf> {
        create_dir_all(BIN_PATH).ok()?;
        Some(PathBuf::from(BIN_PATH).join(self.name.clone() + "_" + lang.ext()))
    }

    pub fn result_path(&self, lang: &BenchmarkLanguage) -> Option<PathBuf> {
        create_dir_all(HYPERFINE_PATH).ok()?;
        let mut path = PathBuf::from(HYPERFINE_PATH).join(self.name.clone() + "_" + lang.ext());
        path.set_extension("csv");
        Some(path)
    }

    pub fn compile(&self, lang: &BenchmarkLanguage) -> Option<PathBuf> {
        if !self.languages.contains(lang) {
            return None;
        }
        let mut source_path = self.base_path.clone();
        source_path.set_extension(lang.ext());
        let out_path = self.bin_path(lang)?;
        if lang.compile_cmd(&source_path, &out_path).output().is_ok() {
            Some(out_path)
        } else {
            None
        }
    }

    pub fn run_hyperfine(&self, lang: &BenchmarkLanguage) {
        if !self.languages.contains(lang) {
            return;
        }
        create_dir_all(HYPERFINE_PATH).unwrap();

        let bin_path = self.bin_path(lang).unwrap();

        let mut command = Command::new("hyperfine");
        let mut call_str = bin_path.to_str().unwrap().to_owned();
        for arg in &self.config.args {
            call_str.push(' ');
            call_str.push_str(arg);
        }
        command.arg(call_str);
        command.arg("--runs");
        command.arg(self.config.runs.to_string());
        command.arg("--export-csv");
        command.arg(self.result_path(lang).unwrap());
        command.status().expect("Failed to execute hyperfine");
    }

    pub fn load_all() -> Vec<Benchmark> {
        let mut paths = vec![];
        for path in read_dir(SUITE_PATH).unwrap() {
            let path = path.unwrap().path();
            let name = path.file_name().unwrap().to_str().unwrap();
            if !path.is_dir() {
                continue;
            }

            let benchmark = Benchmark::new(name);
            if let Some(benchmark) = benchmark {
                paths.push(benchmark);
            }
        }
        paths
    }
}
