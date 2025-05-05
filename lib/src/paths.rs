use std::path::{Path, PathBuf};

pub const SUITE_PATH: &str = "suite";
pub const RESULT_PATH: &str = "results";

pub const BIN_PATH: &str = "target_grk/bin/";
pub const BIN_X86: &str = "x86_64";
pub const BIN_AARCH: &str = "aarch_64";

pub const HYPERFINE_PATH: &str = "results/hyperfine";
pub const REPORTS_PATH: &str = "results/reports";

pub fn bin_path_x86() -> PathBuf {
    Path::new(BIN_PATH).join(BIN_X86)
}

pub fn bin_path_aarch() -> PathBuf {
    Path::new(BIN_PATH).join(BIN_AARCH)
}
