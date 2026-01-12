use crate::{CONFIG_PATH, errors::Error};
use std::{collections::HashMap, fs::read_to_string, path::PathBuf};

#[derive(Debug, Clone, serde::Deserialize)]
pub struct EvalConfig {
    pub versions: HashMap<String, PathBuf>,
    pub stat_args: HashMap<String, Vec<String>>,
    pub version_dir: PathBuf,
    pub num_hyperfine: u64,
}

impl EvalConfig {
    pub fn load() -> Result<EvalConfig, Error> {
        let config_path = PathBuf::from(CONFIG_PATH);
        let config_contents =
            read_to_string(&config_path).map_err(|err| Error::read_conf(&config_path, err))?;
        let mut slf = basic_toml::from_str::<EvalConfig>(&config_contents)
            .map_err(|err| Error::toml(&config_path, err))?;
        for (_, version_path) in slf.versions.iter_mut() {
            *version_path = slf.version_dir.join(&version_path);
        }
        Ok(slf)
    }
}
