use super::langs::BenchmarkLanguage;
use std::{
    fmt,
    path::{Path, PathBuf},
};

#[derive(Debug)]
pub enum Error {
    ReadDir {
        path: PathBuf,
        msg: String,
    },
    PathAccess {
        path: PathBuf,
        tried: String,
    },
    FileAccess {
        path: PathBuf,
        tried: String,
        msg: String,
    },
    WorkingDir {
        tried: String,
        msg: String,
    },
    TestFailure {
        num_fail: usize,
    },
    TomlParse {
        path: PathBuf,
        msg: String,
    },
    DirIsFile {
        path: PathBuf,
    },
    UnknownLanguage {
        lang: String,
        tried: String,
    },
    Compile {
        bench: String,
        lang: String,
        stdout: String,
        stderr: String,
    },
    Run {
        bench: String,
        lang: String,
        msg: String,
    },
    Hyperfine {
        bench: String,
        lang: String,
        msg: String,
    },
}

impl Error {
    pub fn read_dir<T: std::error::Error>(path: &Path, err: T) -> Error {
        Error::ReadDir {
            path: path.to_path_buf(),
            msg: err.to_string(),
        }
    }

    pub fn path_access(path: &Path, tried: &str) -> Error {
        Error::PathAccess {
            path: path.to_path_buf(),
            tried: tried.to_owned(),
        }
    }

    pub fn file_access<T: std::error::Error>(path: &Path, tried: &str, err: T) -> Error {
        Error::FileAccess {
            path: path.to_path_buf(),
            tried: tried.to_owned(),
            msg: err.to_string(),
        }
    }

    pub fn working_dir<T: std::error::Error>(tried: &str, err: T) -> Error {
        Error::WorkingDir {
            tried: tried.to_owned(),
            msg: err.to_string(),
        }
    }

    pub fn parse_toml<T: std::error::Error>(path: &Path, err: T) -> Error {
        Error::TomlParse {
            path: path.to_path_buf(),
            msg: err.to_string(),
        }
    }

    pub fn unknown_lang<L>(tried: &str, lang: &L) -> Error
    where
        L: fmt::Display + ?Sized,
    {
        Error::UnknownLanguage {
            tried: tried.to_owned(),
            lang: lang.to_string(),
        }
    }

    pub fn compile(name: &str, lang: &BenchmarkLanguage, stdout: &str, stderr: &str) -> Error {
        Error::Compile {
            bench: name.to_owned(),
            lang: lang.to_string(),
            stdout: stdout.to_owned(),
            stderr: stderr.to_owned(),
        }
    }

    pub fn run<T: fmt::Display>(name: &str, lang: &BenchmarkLanguage, err: T) -> Error {
        Error::Run {
            bench: name.to_owned(),
            lang: lang.to_string(),
            msg: err.to_string(),
        }
    }

    pub fn hyperfine<T: std::error::Error>(name: &str, lang: &BenchmarkLanguage, err: T) -> Error {
        Error::Hyperfine {
            bench: name.to_owned(),
            lang: lang.to_string(),
            msg: err.to_string(),
        }
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::ReadDir { path, msg } => {
                write!(f, "Could not load contents of {path:?}:\n\t{msg}")
            }
            Error::PathAccess { path, tried } => write!(f, "Could not get {tried} for {path:?}"),
            Error::FileAccess { path, tried, msg } => {
                write!(f, "Could not {tried} file {path:?}:\n\t{msg}")
            }
            Error::WorkingDir { tried, msg } => {
                write!(f, "Could not {tried} working dir:\n\t{msg}")
            }
            Error::TestFailure { num_fail } => write!(f, "{num_fail} tests have failed"),
            Error::TomlParse { path, msg } => {
                write!(f, "Could not parse toml of {path:?}\n\t{msg}")
            }
            Error::DirIsFile { path } => write!(f, "{path:?} is a file, should be a directoty"),
            Error::UnknownLanguage { lang, tried } => {
                write!(f, "Could not {tried}, {lang} does not exist")
            }
            Error::Compile {
                bench,
                lang,
                stdout,
                stderr,
            } => {
                write!(
                    f,
                    "Could not compile {bench} ({lang}):\n\tstdout{stdout}\n\tstderr {stderr}"
                )
            }
            Error::Run { bench, lang, msg } => write!(f, "Could not run {bench} ({lang}): {msg}"),
            Error::Hyperfine { bench, lang, msg } => {
                write!(f, "Could not run hyperfine for {bench} ({lang}): {msg}")
            }
        }
    }
}

impl std::error::Error for Error {}
