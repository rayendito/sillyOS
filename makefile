PAD_SIZE := 8192

# Default target
all:
	# compiling and linking kernel with 
	x86_64-elf-gcc -ffreestanding src/c/kernel.c -c -o obj/kernel.o
	x86_64-elf-ld -o bin/kernel.bin -Ttext 0x1000 obj/kernel.o --oformat binary
	nasm boot.asm -f bin -o bin/boot.bin
	
	# making an OS image (first sector is boot. rest is kernel)
	cat bin/boot.bin bin/kernel.bin > images/silly-os

	# padding to 16 bytes
	actual_size=$(shell stat -f "%z" images/silly-os); \
	if [ $$actual_size -lt $(PAD_SIZE) ]; then \
		dd if=/dev/zero bs=1 count=$$(( $(PAD_SIZE) - $$actual_size )) >> images/silly-os; \
	fi

	# running qemu
	qemu-system-x86_64 -drive format=raw,file=images/silly-os

test:
	nasm test.asm -f bin -o bin/test.bin
	qemu-system-x86_64 bin/test.bin

funny:
	nasm funny.asm -f bin -o bin/funny.bin
	qemu-system-x86_64 bin/funny.bin

disk:
	nasm disk_driver.asm -f bin -o bin/disk_driver.bin
	qemu-system-x86_64 bin/disk_driver.bin
