use clap::Parser;

#[derive(clap::Args)]
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

fn main() -> miette::Result<()> {
    let args = Args::parse();
}
