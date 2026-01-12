#![allow(unused_imports)]
use crate::{
    BENCHMARK_PATH, EXAMPLES_AARCH, EXAMPLES_OUT, EXAMPLES_X86, errors::Error, results::EvalResult,
};
use std::{
    collections::HashMap,
    fs::{read_dir, read_to_string, rename},
    path::{Path, PathBuf},
    process::Command,
};

pub struct Example {
    pub name: String,
    pub source_path: PathBuf,
    pub config: ExampleConfig,
}

#[derive(serde::Deserialize)]
pub struct ExampleConfig {
    pub test_args: Option<Vec<String>>,
    pub args: Option<Vec<String>>,
    pub heap_size: Option<u64>,
}

impl Example {
    pub fn from_dir(dir: &Path) -> Result<Example, Error> {
        let name = dir
            .file_name()
            .ok_or(Error::read_file_name(dir))?
            .to_str()
            .ok_or(Error::read_file_name(dir))?
            .to_owned();
        let mut source_path = dir.join(&name);
        source_path.set_extension("sc");

        let mut config_path = dir.join(&name);
        config_path.set_extension("args");
        let config_contents =
            read_to_string(&config_path).map_err(|err| Error::read_conf(&config_path, err))?;
        let config = basic_toml::from_str::<ExampleConfig>(&config_contents)
            .map_err(|err| Error::toml(&config_path, err))?;

        Ok(Example {
            name,
            source_path,
            config,
        })
    }

    pub fn compiled_path(&self, compiler_name: &str) -> PathBuf {
        #[cfg(target_arch = "x86_64")]
        let out_path = PathBuf::from(EXAMPLES_OUT).join(EXAMPLES_X86);
        #[cfg(target_arch = "aarch64")]
        let out_path = PathBuf::from(EXAMPLES_OUT).join(EXAMPLES_AARCH);

        out_path.join(format!("{}_{}", self.name, compiler_name))
    }

    pub fn get_args(&self) -> Vec<String> {
        if let Some(ref args) = self.config.args {
            args.clone()
        } else {
            self.config
                .test_args
                .clone()
                .expect("Neither args nor test_args defined")
        }
    }
}

pub fn load_examples() -> Result<Vec<Example>, Error> {
    let mut examples = vec![];

    let bench_path = PathBuf::from(BENCHMARK_PATH);
    for benchmark_dir in read_dir(&bench_path).map_err(|err| Error::read_dir(&bench_path, err))? {
        let dir_path = benchmark_dir
            .map_err(|err| Error::read_dir(&bench_path, err))?
            .path();
        if dir_path.is_file() {
            continue;
        }

        examples.push(Example::from_dir(&dir_path)?);
    }

    Ok(examples)
}

pub fn compile_examples(
    examples: &[Example],
    compilers: &HashMap<String, PathBuf>,
    stat_args: &HashMap<String, Vec<String>>,
    results: &mut Vec<EvalResult>,
) -> Result<(), Error> {
    #[cfg(target_arch = "x86_64")]
    let out_path = PathBuf::from(EXAMPLES_OUT).join(EXAMPLES_X86);
    #[cfg(target_arch = "aarch64")]
    let out_path = PathBuf::from(EXAMPLES_OUT).join(EXAMPLES_AARCH);

    for example in examples {
        for (compiler_name, compiler_path) in compilers.iter() {
            if !compiler_path.exists() {
                panic!(
                    "Could not find {}, please make sure all versions exist",
                    compiler_path.display()
                )
            }
            println!("Compiling {} with compiler {compiler_name}", example.name);
            let mut compile_cmd = Command::new(compiler_path);
            compile_cmd.arg("codegen").arg(&example.source_path);

            #[cfg(target_arch = "x86_64")]
            compile_cmd.arg("x86-64");
            #[cfg(target_arch = "aarch64")]
            compile_cmd.arg("aarch64");

            if let Some(size) = example.config.heap_size {
                compile_cmd.arg("--heap-size").arg(size.to_string());
            }

            let compile_res = compile_cmd.output().map_err(|err| {
                Error::start_cmd(
                    &compiler_path.display().to_string(),
                    &format!("Compile example {}", example.source_path.display()),
                    err,
                )
            })?;
            let compile_stdout = String::from_utf8(compile_res.stdout)
                .map_err(|err| Error::parse_out("scc", err))?;

            if !compile_res.status.success() {
                let stderr_str = String::from_utf8(compile_res.stderr)
                    .map_err(|err| Error::parse_out("scc", err))?;
                return Err(Error::run_cmd(
                    &format!("scc_{compiler_name}"),
                    compile_res.status,
                    &compile_stdout,
                    &stderr_str,
                ));
            }

            if let Some(args) = stat_args.get(compiler_name) {
                get_stats(compiler_path, args, example, results)?;
            }

            let example_from = out_path.join(&example.name);
            let example_to = example.compiled_path(compiler_name);
            rename(&example_from, &example_to)
                .map_err(|err| Error::move_file(&example_from, &example_to, err))?;
        }
    }
    Ok(())
}

fn update_results(results: &mut Vec<EvalResult>, stdout: String, example_name: &str) {
    let mut num_passes = None;
    let mut num_create = None;
    let mut num_switch = None;
    for line in stdout.lines() {
        if line.contains("Number of Passes") {
            let mut line_parts = line.split(":");
            line_parts.next();
            num_passes = Some(
                line_parts
                    .next()
                    .expect("Could not get number of Passes")
                    .trim()
                    .parse::<u64>()
                    .expect("Could not get number of Passes"),
            );
        }

        if line.contains("Lifted Create Clauses") {
            let mut line_parts = line.split(":");
            line_parts.next();
            num_create = Some(
                line_parts
                    .next()
                    .expect("Could not get number of Create Clauses")
                    .trim()
                    .parse::<u64>()
                    .expect("Could not get number of Create Clauses"),
            );
        }

        if line.contains("Lifted Switch Clauses") {
            let mut line_parts = line.split(":");
            line_parts.next();
            num_switch = Some(
                line_parts
                    .next()
                    .expect("Could not get number of Switch Clauses")
                    .trim()
                    .parse::<u64>()
                    .expect("Could not get number of Switch clauses"),
            );
        }
    }
    results.push(EvalResult {
        example: example_name.to_string(),
        num_passes: num_passes.expect("Could not get number of Passes"),
        lifted_create: num_create.expect("Could not get number of lifted Create Clauses"),
        lifted_switch: num_switch.expect("Could not get number of lifted Switch Clauses"),
        benchmark_times: HashMap::new(),
    });
}

fn get_stats(
    compiler_path: &Path,
    stat_args: &[String],
    example: &Example,
    results: &mut Vec<EvalResult>,
) -> Result<(), Error> {
    let mut cmd = Command::new(compiler_path);
    for arg in stat_args {
        cmd.arg(arg);
    }
    cmd.arg(&example.source_path);
    let output = cmd.output().map_err(|err| {
        Error::start_cmd(
            &compiler_path.display().to_string(),
            &format!("Compile example {}", example.source_path.display()),
            err,
        )
    })?;
    let stdout_str =
        String::from_utf8(output.stdout).map_err(|err| Error::parse_out("scc", err))?;

    if !output.status.success() {
        let stderr_str =
            String::from_utf8(output.stderr).map_err(|err| Error::parse_out("scc", err))?;
        return Err(Error::run_cmd(
            &compiler_path.display().to_string(),
            output.status,
            &stdout_str,
            &stderr_str,
        ));
    }

    update_results(results, stdout_str, &example.name);
    Ok(())
}
