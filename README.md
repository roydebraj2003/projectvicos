## System Dependencies

- GNU assembler
- GNU linker
- G++
- grub-mkrescue (to create bootable ISO image)
- xorriso (required by grub-mkrescue)
- qemu-system-i386

## Installation (Ubuntu/Debian)

```bash
sudo apt install build-essential grub-pc-bin xorriso qemu-system-x86
```

## Build Steps

### 1. Assemble bootloader
```bash
as --32 loader.s -o loader.o
```

### 2. Compile kernel
```bash
g++ -m32 -c kernel.cpp -o kernel.o -ffreestanding -fno-exceptions -fno-rtti
```

### 3. Link kernel
```bash
ld -m elf_i386 -T linker.ld loader.o kernel.o -o kernel.bin
```

### 4. Verify Multiboot header
```bash
grub-file --is-x86-multiboot kernel.bin && echo "Multiboot confirmed"
```

### 5. Create ISO structure
```bash
mkdir -p iso/boot/grub
cp kernel.bin iso/boot/
```

### 6. Create GRUB config
```bash
cat > iso/boot/grub/grub.cfg << EOF
menuentry "My Kernel" {
    multiboot /boot/kernel.bin
}
EOF
```

### 7. Generate bootable ISO
```bash
grub-mkrescue -o os.iso iso
```

### 8. Run in QEMU
```bash
qemu-system-i386 -cdrom os.iso
```
