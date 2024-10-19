# Default target
all:
	nasm boot.asm -f bin -o bin/boot.bin
	qemu-system-x86_64 bin/boot.bin

test:
	nasm test.asm -f bin -o bin/test.bin
	qemu-system-x86_64 bin/test.bin

funny:
	nasm funny.asm -f bin -o bin/funny.bin
	qemu-system-x86_64 bin/funny.bin

disk:
	nasm disk_driver.asm -f bin -o bin/disk_driver.bin
	qemu-system-x86_64 bin/disk_driver.bin
