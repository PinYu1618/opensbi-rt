#![no_std]
#![no_main]

extern crate opensbi_rt;

use opensbi_rt::entry;

#[entry]
fn entry(hartid: usize, dtb_paddr: usize) {}