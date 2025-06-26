use clap::Parser;
use lib::{benchmark::Benchmark, errors::Error, langs::BenchmarkLanguage};
use std::str;

#[derive(clap::Parser)]
pub struct Args {
    #[arg(short, long, value_name = "NAME")]
    name: Option<String>,
    /// Optional: heap size in MB, default is 512
    #[arg(long)]
    heap_size: Option<usize>,
    ///Optional: skip benchmarks with existing results
    #[arg(long, short)]
    skip_existing: bool,
    ///Optional: Run benchmark instead of hypefine
    #[arg(long, short)]
    exec: bool,
    ///Optional: Exclude language
    #[arg(long)]
    exclude_language: Vec<BenchmarkLanguage>,
}

fn main() -> Result<(), Error> {
    let args = Args::parse();
    let benchmarks;
    println!("{:?}", args.exclude_language);
    if let Some(name) = args.name {
        benchmarks = vec![Benchmark::new(&name, &args.exclude_language)?];
    } else {
        benchmarks = Benchmark::load_all(&args.exclude_language)?;
    }

    for benchmark in benchmarks {
        if args.skip_existing && benchmark.results_exist()? {
            continue;
        }
        benchmark.compile_all()?;
        if args.exec {
            let out = benchmark.run_all(false)?;
            for output in out {
                println!(
                    "{}",
                    str::from_utf8(&output.stdout).expect("Could not read stdout")
                );
            }
        } else {
            benchmark.run_hyperfine_all()?;
        }
    }
    Ok(())
}
