use std::{path::PathBuf, env, fs, io::Write};

fn main() {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());

    // Put the linker script somewhere the linker can find it
    fs::File::create(out_dir.join("link.x"))
        .unwrap()
        .write_all(include_bytes!("src/link.x"))
        .unwrap();
    println!("cargo:rustc-link-search={}", out_dir.display());

    println!("cargo:rustc-link-arg-examples=examples/memory.x");
    println!("cargo:rustc-link-arg-examples={}/link.x", out_dir.display());
    
    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:rerun-if-changed=src/link.x");
}