MEMORY {
    DRAM : ORIGIN = 0x80000000, LENGTH = 2048M
}

PROVIDE(_stext = 0x80200000);

REGION_ALIAS("REGION_TEXT", DRAM);
REGION_ALIAS("REGION_RODATA", DRAM);
REGION_ALIAS("REGION_DATA", DRAM);
REGION_ALIAS("REGION_BSS", DRAM);
REGION_ALIAS("REGION_STACK", DRAM);