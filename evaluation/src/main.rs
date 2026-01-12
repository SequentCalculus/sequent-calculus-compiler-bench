mod benchmark;
mod config;
mod errors;
mod examples;
mod results;

use benchmark::benchmark_examples;
use config::EvalConfig;
use errors::Error;
use examples::{compile_examples, load_examples};
use results::write_csv;

const CONFIG_PATH: &str = "evaluation/config.toml";
const BENCHMARK_PATH: &str = "suite";
const EXAMPLES_OUT: &str = "target_scc/bin/";
#[allow(unused)]
const EXAMPLES_X86: &str = "x86_64";
#[allow(unused)]
const EXAMPLES_AARCH: &str = "aarch_64";
const RESULTS_OUT: &str = "target_scc/eval_opt.csv";

fn main() -> Result<(), Error> {
    println!("Loading configuration...");
    let config = EvalConfig::load()?;
    println!("Loading examples...");
    let examples = load_examples()?;
    let mut results = Vec::with_capacity(examples.len());
    println!("Compiling examples...");
    compile_examples(&examples, &config.versions, &config.stat_args, &mut results)?;
    println!("Benchmarking examples...");
    let versions: Vec<String> = config.versions.keys().cloned().collect();
    benchmark_examples(&examples, &versions, config.num_hyperfine, &mut results)?;
    println!("Writing results...");
    write_csv(results, &versions)?;
    println!("Done");
    Ok(())
}
