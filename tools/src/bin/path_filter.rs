//! Rust port of path_filter.py.
//!
//! Usage: path_filter <PATH> [LOG_LEVEL]
//!
//! Drops Windows directories (under /mnt/c/) from PATH, except those matching
//! `KEEP`, and prints an `export PATH="..."` line to be sourced by zshrc/bashrc.
//! Logs go to stderr. LOG_LEVEL is DEBUG, INFO (default), WARNING, ERROR or CRITICAL.

use std::env;
use std::process::ExitCode;

const MYNAME: &str = "arlo-linux-dev/path_filter";

const KEEP: &[&str] = &["/Microsoft VS Code", "/JetBrains", ".local/wsl-bin"];

#[derive(Clone, Copy, PartialEq, PartialOrd)]
enum Level {
    Debug = 10,
    Info = 20,
    Warning = 30,
    Error = 40,
    Critical = 50,
}

impl Level {
    fn parse(s: &str) -> Option<Level> {
        match s.to_ascii_uppercase().as_str() {
            "DEBUG" => Some(Level::Debug),
            "INFO" => Some(Level::Info),
            "WARNING" | "WARN" => Some(Level::Warning),
            "ERROR" => Some(Level::Error),
            "CRITICAL" | "FATAL" => Some(Level::Critical),
            _ => None,
        }
    }
}

struct Logger {
    level: Level,
}

impl Logger {
    fn log(&self, level: Level, msg: &str) {
        if level >= self.level {
            eprintln!("▶️  {msg}");
        }
    }
}

fn include(p: &str, log: &Logger, remove_count: &mut usize) -> bool {
    // we only care about Windows paths under C:\
    if !p.starts_with("/mnt/c/") {
        return true;
    }

    // keep the path if
    if KEEP.iter().any(|match_text| p.contains(match_text)) {
        log.log(Level::Info, &format!("✅ {p}"));
        return true;
    }

    log.log(Level::Debug, &format!("❌ {p}"));
    *remove_count += 1;

    false
}

fn main() -> ExitCode {
    // args / config
    let args: Vec<String> = env::args().collect();
    let Some(path) = args.get(1) else {
        eprintln!("usage: path_filter <PATH> [DEBUG|INFO|WARNING|ERROR|CRITICAL]");
        return ExitCode::from(2);
    };

    let level = match args.get(2) {
        None => Level::Info,
        Some(s) => match Level::parse(s) {
            Some(level) => level,
            None => {
                eprintln!("{MYNAME}: unknown log level: {s}");
                return ExitCode::from(2);
            }
        },
    };
    let log = Logger { level };

    let mut remove_count = 0;
    let new_paths: Vec<&str> = path
        .split(':')
        .filter(|p| include(p, &log, &mut remove_count))
        .collect();

    if remove_count > 0 {
        log.log(
            Level::Warning,
            &format!("{MYNAME}: removed {remove_count} Windows paths"),
        );
    }

    // STDOUT will be sourced by zshrc/bashrc
    println!("export PATH=\"{}\"", new_paths.join(":"));

    ExitCode::SUCCESS
}
