# Default target
all:
	x86_64-elf-gcc -ffreestanding c_files/kernel.c -c -o c_files/kernel.o
	x86_64-elf-ld -o bin/kernel.bin -Ttext 0x1000 c_files/kernel.o --oformat binary
	nasm boot.asm -f bin -o bin/boot.bin
	cat bin/boot.bin bin/kernel.bin > images/os-image
	qemu-system-x86_64 -drive format=raw,file=images/os-image

test:
	nasm test.asm -f bin -o bin/test.bin
	qemu-system-x86_64 bin/test.bin

funny:
	nasm funny.asm -f bin -o bin/funny.bin
	qemu-system-x86_64 bin/funny.bin

disk:
	nasm disk_driver.asm -f bin -o bin/disk_driver.bin
	qemu-system-x86_64 bin/disk_driver.bin
