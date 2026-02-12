AS = as
CXX = g++
LD = ld
GRUB = grub-mkrescue
QEMU = qemu-system-i386

# flags
ASFLAGS = --32
CXXFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
LDFLAGS = -m elf_i386

OBJS = loader.o kernel.o
TARGET = kernel.bin
ISO = os.iso
ISODIR = iso

all: $(ISO)

# compile
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# link
$(TARGET): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -T linker.ld -o $@ $(OBJS)

# iso
$(ISO): $(TARGET)
	mkdir -p $(ISODIR)/boot/grub
	cp $(TARGET) $(ISODIR)/boot/

	echo 'set timeout=5' >  $(ISODIR)/boot/grub/grub.cfg
	echo 'set default=0' >> $(ISODIR)/boot/grub/grub.cfg
	echo 'menuentry "My Kernel" {' >> $(ISODIR)/boot/grub/grub.cfg
	echo '  multiboot /boot/$(TARGET)' >> $(ISODIR)/boot/grub/grub.cfg
	echo '  boot' >> $(ISODIR)/boot/grub/grub.cfg
	echo '}' >> $(ISODIR)/boot/grub/grub.cfg

	$(GRUB) -o $@ $(ISODIR)

run: $(ISO)
	$(QEMU) -cdrom $<

clean:
	rm -rf *.o *.bin $(ISODIR) $(ISO)

