# loader.s - Assembly bootloader with Multiboot header

# Multiboot header constants (required by GRUB)
.set MAGIC, 0x1badb002              # Multiboot magic number
.set FLAGS, (1 << 0 | 1 << 1)       # Flags: page-align modules + memory map
.set CHECKSUM, -(MAGIC + FLAGS)     # Checksum: must make sum zero

# Multiboot header (must be in first 8KB of binary)
.section .multiboot
    .align 4                        # Align to 4-byte boundary
    .long MAGIC                     # Write magic number
    .long FLAGS                     # Write flags
    .long CHECKSUM                  # Write checksum

# Stack space allocation (4KB)
.section .bss
    .align 16                       # Align stack to 16 bytes
stack_bottom:
    .skip 4096                      # Reserve 4KB for stack
stack_top:                          # Stack grows downward to bottom

# Code section
.section .text
.global _start                      # Make _start visible to linker
.extern kernel_main                 # Declare external C++ function

_start:
    mov $stack_top, %esp            # Set stack pointer to top (grows down)
    
    push %ebx                       # Push multiboot info address (2nd param)
    push %eax                       # Push magic number (1st param)
    
    call kernel_main                # Jump to C++ kernel code
    
hang:
    hlt                             # Halt CPU
    jmp hang                        # Loop if interrupt wakes CPU
		
