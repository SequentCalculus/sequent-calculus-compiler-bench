use std::path::{Path, PathBuf};

pub const SUITE_PATH: &str = "suite";

pub const BIN_PATH: &str = "target_scc/bin/";
pub const BIN_X86: &str = "x86_64";
pub const BIN_AARCH: &str = "aarch_64";

pub const RAW_PATH: &str = "results/raw";
pub const PLOTS_PATH: &str = "results/plots";

pub fn bin_path_x86() -> PathBuf {
    let path = Path::new(BIN_PATH).join(BIN_X86);
    if !path.exists() {
        std::fs::create_dir_all(&path).expect("Could not create out dir");
    }
    path
}

pub fn bin_path_aarch() -> PathBuf {
    let path = Path::new(BIN_PATH).join(BIN_AARCH);
    if !path.exists() {
        std::fs::create_dir_all(&path).expect("Could not create out dir");
    }
    path
}
