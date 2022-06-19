/* # Developer notes

- Symbols that start with __ are considered `private`
*/

PROVIDE(_stext = ORIGIN(REGION_TEXT));
PROVIDE(_stack_size = 128K);

OUTPUT_ARCH(riscv)

ENTRY(_start)

SECTIONS
{
    .text _stext :
    {
        __stext = .;

        KEEP(*(.init));
        KEEP(*(.init.rust));        

        *(.text .text.*);

        . = ALIGN(4);
        __etext = .;
    } > REGION_TEXT

    .rodata : ALIGN(4K)
    {
        __srodata = .;
        *(.srodata .srodata.*);
        *(.rodata .rodata.*)
    } > REGION_RODATA

    .data : ALIGN(4K)
    {
        PROVIDE(__global_pointer$ = . + 0x800);
        *(.sdata .sdata.*);
        *(.data .data.*)
        . = ALIGN(4);
        _edata = .;
    } > REGION_DATA

    .bss (NOLOAD) : ALIGN(4K)
    {
        __sbss = .;
        *(.sbss .bss .bss.*)
        . = ALIGN(4);
        __ebss = .;
    } > REGION_BSS

    .stack (INFO) : ALIGN(4K)
    {
        __estack = .;
        . += _stack_size;
        . = ALIGN(4);
        __sstack = .;
    } > REGION_STACK

    .eh_frame (INFO) : { KEEP(*(.eh_frame)) }
    .eh_frame_hdr (INFO) : { *(.eh_frame_hdr) }
}

ASSERT(ORIGIN(REGION_TEXT) % 4 == 0, "
ERROR(opensbi-rt): the start of the REGION_TEXT must be 4-byte aligned");

ASSERT(ORIGIN(REGION_RODATA) % 4K == 0, "
ERROR(opensbi-rt): the start of the REGION_RODATA must be 4K-byte aligned");

ASSERT(ORIGIN(REGION_DATA) % 4K == 0, "
ERROR(opensbi-rt): the start of the REGION_DATA must be 4K-byte aligned");

ASSERT(ORIGIN(REGION_STACK) % 4K == 0, "
ERROR(opensbi-rt): the start of the REGION_STACK must be 4K-byte aligned");

ASSERT(_stext % 4 == 0, "
ERROR(opensbi-rt): `_stext` must be 4-byte aligned");