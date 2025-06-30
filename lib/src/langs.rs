#![allow(unused_imports)]
use super::{
    errors::Error,
    paths::{bin_path_aarch, bin_path_x86},
};
use std::{fmt, path::PathBuf, process::Command, str::FromStr};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BenchmarkLanguage {
    Scc,
    Rust,
    SmlMlton,
    SmlNj,
    OCaml,
    Effekt,
    Koka,
}

impl BenchmarkLanguage {
    pub fn from_ext(ext: &str) -> Option<BenchmarkLanguage> {
        match ext {
            "sc" => Some(BenchmarkLanguage::Scc),
            "rs" => Some(BenchmarkLanguage::Rust),
            "mlb" => Some(BenchmarkLanguage::SmlMlton),
            "cm" => Some(BenchmarkLanguage::SmlNj),
            "ml" => Some(BenchmarkLanguage::OCaml),
            "effekt" => Some(BenchmarkLanguage::Effekt),
            "kk" => Some(BenchmarkLanguage::Koka),
            _ => None,
        }
    }

    pub fn ext(&self) -> &str {
        match self {
            BenchmarkLanguage::Scc => "sc",
            BenchmarkLanguage::Rust => "rs",
            BenchmarkLanguage::SmlNj => "cm",
            BenchmarkLanguage::SmlMlton => "mlb",
            BenchmarkLanguage::OCaml => "ml",
            BenchmarkLanguage::Effekt => "effekt",
            BenchmarkLanguage::Koka => "kk",
        }
    }

    pub fn suffix(&self) -> &str {
        match self {
            BenchmarkLanguage::Scc => "scc",
            BenchmarkLanguage::Rust => "rust",
            BenchmarkLanguage::SmlNj => "smlnj",
            BenchmarkLanguage::SmlMlton => "mlton",
            BenchmarkLanguage::OCaml => "ocaml",
            BenchmarkLanguage::Effekt => "effekt",
            BenchmarkLanguage::Koka => "koka",
        }
    }

    pub fn compile_cmd(&self, source_file: &PathBuf, heap_size: Option<usize>) -> Command {
        let mut source_base = source_file
            .as_path()
            .file_stem()
            .expect("Could not get file name")
            .to_owned();
        source_base.push("_");
        source_base.push(self.suffix());
        #[cfg(target_arch = "x86_64")]
        let out_path = bin_path_x86().join(source_base);
        #[cfg(target_arch = "aarch64")]
        let out_path = bin_path_aarch().join(source_base);

        match self {
            BenchmarkLanguage::Scc => {
                let mut cmd = Command::new("scc");
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
                cmd.arg(out_path);
                cmd.arg("-C");
                cmd.arg("opt-level=3");
                cmd.arg("-Awarnings");
                cmd
            }
            BenchmarkLanguage::SmlNj => {
                let mut cmd = Command::new("ml-build");
                cmd.arg(source_file);
                cmd.arg("Main.main");
                cmd.arg(out_path);
                cmd
            }
            BenchmarkLanguage::SmlMlton => {
                let mut cmd = Command::new("mlton");
                cmd.arg("-default-type");
                cmd.arg("int64");
                cmd.arg("-output");
                cmd.arg(out_path);
                cmd.arg(source_file);
                cmd
            }
            BenchmarkLanguage::OCaml => {
                let mut cmd = Command::new("ocamlopt");
                cmd.arg(source_file);
                cmd.arg("-o");
                cmd.arg(out_path);
                cmd
            }
            BenchmarkLanguage::Effekt => {
                let mut cmd = Command::new("effekt");
                cmd.arg(source_file);
                cmd.arg("-b");
                cmd.arg("--backend");
                cmd.arg("llvm");
                cmd.arg("-o");
                cmd.arg(out_path);
                cmd
            }
            BenchmarkLanguage::Koka => {
                let source_base = source_file
                    .file_name()
                    .expect("Could not read file name")
                    .to_str()
                    .expect("Could not get file name as string")
                    .to_lowercase();
                let source_file = source_file
                    .parent()
                    .expect("Could not get file path")
                    .join(source_base);
                let mut cmd = Command::new("koka");
                cmd.arg(&source_file);
                cmd.arg("-o");
                cmd.arg(out_path);
                cmd.arg("-O2");
                cmd
            }
        }
    }
}

impl fmt::Display for BenchmarkLanguage {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            BenchmarkLanguage::Scc => f.write_str("Compiling-SC"),
            BenchmarkLanguage::Rust => f.write_str("Rust"),
            BenchmarkLanguage::SmlNj => f.write_str("SML/NJ"),
            BenchmarkLanguage::SmlMlton => f.write_str("MLton"),
            BenchmarkLanguage::OCaml => f.write_str("OCaml"),
            BenchmarkLanguage::Effekt => f.write_str("Effekt"),
            BenchmarkLanguage::Koka => f.write_str("Koka"),
        }
    }
}

impl FromStr for BenchmarkLanguage {
    type Err = Error;
    fn from_str(s: &str) -> Result<BenchmarkLanguage, Self::Err> {
        match s.to_lowercase().trim() {
            "scc" => Ok(BenchmarkLanguage::Scc),
            "rust" => Ok(BenchmarkLanguage::Rust),
            "smlnj" => Ok(BenchmarkLanguage::SmlNj),
            "ocaml" => Ok(BenchmarkLanguage::OCaml),
            "mlton" => Ok(BenchmarkLanguage::SmlMlton),
            "effekt" => Ok(BenchmarkLanguage::Effekt),
            "koka" => Ok(BenchmarkLanguage::Koka),
            _ => Err(Error::unknown_lang("Parse Language Name", s)),
        }
    }
}
