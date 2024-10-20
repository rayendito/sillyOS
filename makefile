PAD_SIZE := 8192

# Default target
all:
	# compiling and linking kernel (including kernel entry), and compiling boot.asm
	nasm src/asm/kernel_entry.asm -f elf64 -o obj/kernel_entry.o #elf64 because https://forum.nasm.us/index.php?topic=754.0
	x86_64-elf-gcc -ffreestanding src/c/kernel.c -c -o obj/kernel.o
	x86_64-elf-ld -o bin/kernel.bin -Ttext 0x1000 obj/kernel_entry.o obj/kernel.o --oformat binary
	nasm boot.asm -f bin -o bin/boot.bin
	
	# making an OS image (first sector is boot. rest is kernel)
	cat bin/boot.bin bin/kernel.bin > images/silly-os

	# padding to 16 bytes
	./src/sh/pad_img.sh

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
