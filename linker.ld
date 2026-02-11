/* linker.ld - Linker script for kernel memory layout */

ENTRY(_start)                       /* Entry point is _start from loader.s */

SECTIONS
{
    . = 1M;                         /* Start kernel at 1MB (0x100000) */
                                    /* Avoids BIOS data, video memory, ROM */

    .multiboot :                    /* Multiboot header section */
    {
        *(.multiboot)               /* Must be first for GRUB to find it */
    }

    .text :                         /* Code section */
    {
        *(.text)                    /* All executable code */
    }

    .rodata :                       /* Read-only data section */
    {
        *(.rodata)                  /* Constants like "Hello world" string */
    }

    .data :                         /* Initialized data section */
    {
        *(.data)                    /* Global/static vars with initial values */
    }

    .bss :                          /* Uninitialized data section */
    {
        *(COMMON)                   /* Common symbols */
        *(.bss)                     /* Zero-initialized data (like our stack) */
    }
}
