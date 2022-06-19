#![no_std]

extern crate opensbi_rt_macros as macros;

pub use macros::entry;

use core::arch::global_asm;
use core::arch::asm;

#[export_name = "_start_rust"]
fn start_rust(hartid: usize, dtb_paddr: usize) -> ! {
    loop {}
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {
        core::hint::spin_loop()
    }
}

#[no_mangle]
extern "C" fn abort() -> ! {
    panic!("abort!");
}

// supervisor interrupt handler

#[cfg(target_pointer_width = "64")]
global_asm!(
    "
    .equ REGBYTES, 8
    .macro SAVE reg, offset
        sd  \\reg, \\offset*REGBYTES(sp)
    .endm
    .macro LOAD reg, offset
        ld  \\reg, \\offset*REGBYTES(sp)
    .endm
"
);
#[cfg(target_pointer_width = "32")]
global_asm!(
    "
    .equ REGBYTES, 4
    .macro SAVE reg, offset
        sw  \\reg, \\offset*REGBYTES(sp)
    .endm
    .macro LOAD reg, offset
        lw  \\reg, \\offset*REGBYTES(sp)
    .endm
"
);

global_asm!(include_str!("asm.S"));