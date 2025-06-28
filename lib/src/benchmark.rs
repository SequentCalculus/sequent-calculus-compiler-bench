#![allow(unused_imports)]
use super::{
    config::Config,
    errors::Error,
    langs::BenchmarkLanguage,
    paths::{HYPERFINE_PATH, REPORTS_PATH, SUITE_PATH, bin_path_aarch, bin_path_x86},
};
use std::{
    fs::{create_dir_all, read_dir},
    path::PathBuf,
    process::Command,
    str,
};

pub struct Benchmark {
    pub name: String,
    pub base_path: PathBuf,
    pub languages: Vec<BenchmarkLanguage>,
    pub config: Config,
}

impl Benchmark {
    pub fn new(name: &str, exclude_lang: &[BenchmarkLanguage]) -> Result<Benchmark, Error> {
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
                if !exclude_lang.contains(&lang) {
                    languages.push(lang);
                }
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
        if *lang != BenchmarkLanguage::Scc {
            bin_name += "_";
            bin_name += lang.suffix();
        }

        Ok(bin_path.join(bin_name))
    }

    pub fn result_path(&self, lang: &BenchmarkLanguage) -> Result<PathBuf, Error> {
        create_dir_all(HYPERFINE_PATH).map_err(|_| {
            Error::path_access(&PathBuf::from(HYPERFINE_PATH), "create hyperfine path")
        })?;
        let mut path = PathBuf::from(HYPERFINE_PATH).join(self.name.clone() + "_" + lang.suffix());
        path.set_extension("csv");
        Ok(path)
    }

    pub fn report_path(&self, lang: &BenchmarkLanguage) -> Result<PathBuf, Error> {
        create_dir_all(REPORTS_PATH)
            .map_err(|_| Error::path_access(&PathBuf::from(REPORTS_PATH), "create report path"))?;
        let mut path = PathBuf::from(REPORTS_PATH).join(self.name.clone() + "_" + lang.suffix());
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
            return Err(Error::unknown_lang("Compiling", lang));
        }

        let mut source_path = self.base_path.clone().join(&self.name);
        source_path.set_extension(lang.ext());

        let mut compile_cmd = lang.compile_cmd(&source_path, self.config.heap_size);

        let out = compile_cmd
            .output()
            .map_err(|err| Error::compile(&self.name, lang, "", &err.to_string()))?;
        out.status.success().then_some(()).ok_or(Error::compile(
            &self.name,
            lang,
            str::from_utf8(&out.stdout).unwrap_or(""),
            str::from_utf8(&out.stderr).unwrap_or(""),
        ))?;
        // for Koka, we have to make the generated binary executable
        if let BenchmarkLanguage::Koka = lang {
            let mut source_base = source_path
                .as_path()
                .file_stem()
                .expect("Could not get file name")
                .to_owned();
            source_base.push("_");
            source_base.push(lang.suffix());
            #[cfg(target_arch = "x86_64")]
            let out_path = bin_path_x86().join(source_base);
            #[cfg(target_arch = "aarch64")]
            let out_path = bin_path_aarch().join(source_base);

            let mut cmd = Command::new("chmod");
            cmd.arg("+x");
            cmd.arg(out_path.clone());

            let out = cmd
                .output()
                .map_err(|err| Error::file_access(&out_path, "Change file permissions", err))?;

            out.status
                .success()
                .then_some(())
                .ok_or(Error::path_access(&out_path, "Change file permissions"))?
        };
        Ok(())
    }

    pub fn run_all(&self, test: bool) -> Result<Vec<std::process::Output>, Error> {
        let mut results = vec![];
        for lang in self.languages.iter() {
            let res = self.run(lang, test)?;
            results.push(res);
        }
        Ok(results)
    }

    pub fn run_cmd(&self, lang: &BenchmarkLanguage) -> Result<Command, Error> {
        let bin_path = self.bin_path(lang)?;
        if *lang == BenchmarkLanguage::SmlNj {
            let mut cmd = Command::new("sml");
            cmd.arg("@SMLload");
            cmd.arg(bin_path);
            Ok(cmd)
        } else if *lang == BenchmarkLanguage::Effekt {
            Ok(Command::new(bin_path.join(&self.name)))
        } else if *lang == BenchmarkLanguage::Koka {
            Command::new("chmod")
                .arg("+x")
                .arg(&bin_path)
                .status()
                .map_err(|err| Error::run(&self.name, lang, err))?;
            Ok(Command::new(bin_path))
        } else {
            Ok(Command::new(bin_path))
        }
    }

    pub fn run(&self, lang: &BenchmarkLanguage, test: bool) -> Result<std::process::Output, Error> {
        let mut cmd = self.run_cmd(lang)?;
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
            return Err(Error::unknown_lang("Run Hyperfine", lang));
        }

        let bin_path = self.bin_path(lang)?;
        let out_path = self.result_path(lang)?;

        let mut command = Command::new("hyperfine");
        let path_err = Error::path_access(&bin_path, "Path as String");
        let bin_str = if *lang == BenchmarkLanguage::Effekt {
            bin_path.join(&self.name)
        } else {
            bin_path
        }
        .to_str()
        .ok_or(path_err)?
        .to_owned();

        let mut call_str = if *lang == BenchmarkLanguage::SmlNj {
            format!("sml @SMLload {bin_str}")
        } else {
            bin_str
        };

        for arg in &self.config.args {
            call_str.push(' ');
            call_str.push_str(arg);
        }
        command.arg(call_str);
        command.arg("--runs");
        command.arg(self.config.runs.to_string());
        command.arg("--export-csv");
        command.arg(&out_path);
        println!("hyperfine command: {command:?}");
        command
            .status()
            .map_err(|err| Error::hyperfine(&self.name, lang, err))?;
        Ok(())
    }

    pub fn load_all(
        exclude_lang: &[BenchmarkLanguage],
        exclude_bench: &[String],
    ) -> Result<Vec<Benchmark>, Error> {
        let mut benchmarks = vec![];
        let suite_path = PathBuf::from(SUITE_PATH);
        for path in read_dir(&suite_path).map_err(|err| Error::read_dir(&suite_path, err))? {
            let path = path
                .map_err(|_| Error::path_access(&suite_path, "Read File"))?
                .path();
            let name = path.file_name().unwrap().to_str().unwrap().to_owned();
            if !path.is_dir() || exclude_bench.contains(&name) {
                continue;
            }

            let benchmark = Benchmark::new(&name, exclude_lang)?;
            benchmarks.push(benchmark);
        }
        Ok(benchmarks)
    }
}
