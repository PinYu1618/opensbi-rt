//! Ref: https://github.com/rust-embedded/riscv-rt/blob/master/asm.S

    .section .init
    .global _start
_start:
    .global _abs_start
_abs_start:
    .cfi_startproc
    .cfi_undefined ra

    /* set up global pointer */
.option push
.option norelax
    la gp, __global_pointer$
    .option pop

    beqz    a0, 1f
    /* Other harts are halted, waiting for software interrupt */
    wfi
    j       2f
1:
    /* Prepare stack for hart 0; */
    /* stack for other harts are prepared in init code in hart 0 */
    /* Load symbols */
    la  sp, __sstack
2:
    /* If entry function returns, it should abort */
    la  ra, _start_abort
    /* Jump to rust entry function */
    j   _start_rust
    .cfi_endproc

_start_abort:
    wfi
    j   _start_abort