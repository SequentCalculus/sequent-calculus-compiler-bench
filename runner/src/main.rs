use clap::Parser;
use lib::{benchmark::Benchmark, errors::Error};

#[derive(clap::Parser)]
pub struct Args {
    #[arg(short, long, value_name = "NAME")]
    name: Option<String>,
    /// Optional heap size in MB, default is 512
    #[arg(long)]
    heap_size: Option<usize>,
    ///Optional skip benchmarks with existing results
    #[arg(long, short)]
    skip_existing: bool,
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
        benchmark.run_hyperfine_all()?;
    }
    Ok(())
}
