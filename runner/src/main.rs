use clap::Parser;
use lib::{benchmark::Benchmark, errors::Error};
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
    ///Optiional: Run benchmark instead of hypefine
    #[arg(long, short)]
    exec: bool,
}

fn main() -> Result<(), Error> {
    let args = Args::parse();
    let benchmarks;
    if let Some(name) = args.name {
        benchmarks = vec![Benchmark::new(&name)?];
    } else {
        benchmarks = Benchmark::load_all()?;
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
