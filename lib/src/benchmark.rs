use super::{
    config::Config,
    errors::Error,
    paths::{bin_path_aarch, bin_path_x86, HYPERFINE_PATH, REPORTS_PATH, SUITE_PATH},
};
use std::{
    fmt,
    fs::{create_dir_all, read_dir},
    path::PathBuf,
    process::Command,
};

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum BenchmarkLanguage {
    Sc,
    Rust,
    Sml,
}

impl BenchmarkLanguage {
    fn from_ext(ext: &str) -> Option<BenchmarkLanguage> {
        match ext {
            "sc" => Some(BenchmarkLanguage::Sc),
            "rs" => Some(BenchmarkLanguage::Rust),
            "sml" => Some(BenchmarkLanguage::Sml),
            _ => None,
        }
    }

    fn ext(&self) -> &str {
        match self {
            BenchmarkLanguage::Sc => "sc",
            BenchmarkLanguage::Rust => "rs",
            BenchmarkLanguage::Sml => "sml",
        }
    }

    fn compile_cmd(&self, source_file: &PathBuf, heap_size: Option<usize>) -> Command {
        let mut source_base = source_file
            .as_path()
            .file_stem()
            .expect("Could not get file name")
            .to_owned();
        source_base.push("_");
        source_base.push(self.ext());

        match self {
            BenchmarkLanguage::Sc => {
                let mut cmd = Command::new("grokking");
                cmd.arg("codegen");
                cmd.arg(source_file);
                #[cfg(target_arch = "x86_64")]
                cmd.arg("x86-64");
                #[cfg(target_arch = "aarch64")]
                cmd.arg("aarch64");
                if let Some(hs) = heap_size {
                    cmd.arg("--heap-size");
                    cmd.arg(format!("{}", hs));
                }
                cmd
            }
            BenchmarkLanguage::Rust => {
                let mut cmd = Command::new("rustc");
                cmd.arg(source_file);
                cmd.arg("-o");
                #[cfg(target_arch = "x86_64")]
                cmd.arg(bin_path_x86().join(source_base));
                #[cfg(target_arch = "aarch64")]
                cmd.arg(bin_path_aarch().join(source_base));
                cmd.arg("-C");
                cmd.arg("opt-level=3");
                cmd
            }
            BenchmarkLanguage::Sml => {
                let mut cmd = Command::new("mlton");
                cmd.arg("-output");
                #[cfg(target_arch = "x86_64")]
                cmd.arg(bin_path_x86().join(source_base));
                #[cfg(target_arch = "aarch64")]
                cmd.arg(bin_path_aarch().join(source_base));
                cmd.arg(source_file);
                cmd
            }
        }
    }
}

impl fmt::Display for BenchmarkLanguage {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            BenchmarkLanguage::Sc => f.write_str("Compiling-Sc"),
            BenchmarkLanguage::Rust => f.write_str("Rust"),
            BenchmarkLanguage::Sml => f.write_str("Sml"),
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
    pub fn new(name: &str) -> Result<Benchmark, Error> {
        let base_path = PathBuf::from(SUITE_PATH).join(name);

        let mut config_path = base_path.clone().join(name);
        config_path.set_extension("args");
        let config = Config::from_file(config_path);

        let dir_contents = read_dir(&base_path).map_err(|err| Error::read_dir(&base_path, err))?;
        let mut languages = vec![];
        for file in dir_contents {
            let file_path = file
                .map_err(|_| Error::path_access(&base_path, "Read file path"))?
                .path();
            let ext = match file_path.extension() {
                None => continue,
                Some(ext) => ext.to_str().ok_or(Error::path_access(
                    &file_path,
                    "Get File Extension (as string)",
                )),
            }?;
            if ext == "args" {
                continue;
            }

            if let Some(lang) = BenchmarkLanguage::from_ext(ext) {
                languages.push(lang);
            }
        }
        Ok(Benchmark {
            name: name.to_owned(),
            base_path,
            languages,
            config,
        })
    }

    pub fn bin_path(&self, lang: &BenchmarkLanguage) -> Result<PathBuf, Error> {
        #[cfg(target_arch = "x86_64")]
        let bin_path = bin_path_x86();
        #[cfg(target_arch = "aarch64")]
        let bin_path = bin_path_aarch();

        create_dir_all(&bin_path)
            .map_err(|_| Error::path_access(&PathBuf::from(&bin_path), "create bin path"))?;
        let mut bin_name = self.name.clone();
        if *lang != BenchmarkLanguage::Sc {
            bin_name += "_";
            bin_name += lang.ext();
        }

        Ok(PathBuf::from(bin_path).join(bin_name))
    }

    pub fn result_path(&self, lang: &BenchmarkLanguage) -> Result<PathBuf, Error> {
        create_dir_all(HYPERFINE_PATH).map_err(|_| {
            Error::path_access(&PathBuf::from(HYPERFINE_PATH), "create hyperfine path")
        })?;
        let mut path = PathBuf::from(HYPERFINE_PATH).join(self.name.clone() + "_" + lang.ext());
        path.set_extension("csv");
        Ok(path)
    }

    pub fn report_path(&self, lang: &BenchmarkLanguage) -> Result<PathBuf, Error> {
        create_dir_all(REPORTS_PATH)
            .map_err(|_| Error::path_access(&PathBuf::from(REPORTS_PATH), "create report path"))?;
        let mut path = PathBuf::from(REPORTS_PATH).join(self.name.clone() + "_" + lang.ext());
        path.set_extension("png");
        Ok(path)
    }

    pub fn results_exist(&self) -> Result<bool, Error> {
        for lang in self.languages.iter() {
            let out_path = self.result_path(lang)?;
            if !out_path.exists() {
                return Ok(false);
            }
        }
        Ok(true)
    }

    pub fn compile_all(&self) -> Result<(), Error> {
        for lang in self.languages.iter() {
            self.compile(lang)?;
        }
        Ok(())
    }

    pub fn compile(&self, lang: &BenchmarkLanguage) -> Result<(), Error> {
        if !self.languages.contains(lang) {
            return Err(Error::unknown_lang(&self.name, "Compiling", lang));
        }
        let mut source_path = self.base_path.clone().join(&self.name);
        source_path.set_extension(lang.ext());

        let mut compile_cmd = lang.compile_cmd(&source_path, self.config.heap_size);
        compile_cmd
            .status()
            .map_err(|err| Error::compile(&self.name, lang, err))?
            .success()
            .then_some(())
            .ok_or(Error::compile(
                &self.name,
                lang,
                "Compiler exited with nonzero exit status",
            ))
    }

    pub fn run_all(&self, test: bool) -> Result<Vec<std::process::Output>, Error> {
        let mut results = vec![];
        for lang in self.languages.iter() {
            let res = self.run(lang, test)?;
            results.push(res);
        }
        Ok(results)
    }

    pub fn run(&self, lang: &BenchmarkLanguage, test: bool) -> Result<std::process::Output, Error> {
        let bin_path = self.bin_path(lang)?;
        let mut cmd = Command::new(bin_path);
        let args = if test {
            &self.config.test_args
        } else {
            &self.config.args
        };
        for arg in args {
            cmd.arg(arg);
        }
        let out = cmd
            .output()
            .map_err(|err| Error::run(&self.name, lang, err))?;
        if !out.status.success() {
            return Err(Error::run(
                &self.name,
                lang,
                "Command exited with nonzero exit status",
            ));
        }
        Ok(out)
    }

    pub fn run_hyperfine_all(&self) -> Result<(), Error> {
        for lang in self.languages.iter() {
            self.run_hyperfine(lang)?;
        }
        Ok(())
    }

    pub fn run_hyperfine(&self, lang: &BenchmarkLanguage) -> Result<(), Error> {
        if !self.languages.contains(lang) {
            return Err(Error::unknown_lang(&self.name, "Run Hyperfine", lang));
        }

        let bin_path = self.bin_path(lang)?;
        let out_path = self.result_path(lang)?;

        let mut command = Command::new("hyperfine");
        let mut call_str = bin_path
            .to_str()
            .ok_or(Error::path_access(&bin_path, "Path as String"))?
            .to_owned();
        for arg in &self.config.args {
            call_str.push(' ');
            call_str.push_str(arg);
        }
        command.arg(call_str);
        command.arg("--runs");
        command.arg(self.config.runs.to_string());
        command.arg("--export-csv");
        command.arg(&out_path);
        command
            .status()
            .map_err(|err| Error::hyperfine(&self.name, lang, err))?;
        Ok(())
    }

    pub fn load_all() -> Result<Vec<Benchmark>, Error> {
        let mut benchmarks = vec![];
        let suite_path = PathBuf::from(SUITE_PATH);
        for path in read_dir(&suite_path).map_err(|err| Error::read_dir(&suite_path, err))? {
            let path = path
                .map_err(|_| Error::path_access(&suite_path, "Read File"))?
                .path();
            let name = path.file_name().unwrap().to_str().unwrap();
            if !path.is_dir() {
                continue;
            }

            let benchmark = Benchmark::new(name)?;
            benchmarks.push(benchmark);
        }
        Ok(benchmarks)
    }
}
