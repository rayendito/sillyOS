# Default target
all:
	nasm boot.asm -f bin -o boot.bin
	qemu-system-x86_64 boot.bin

test:
	nasm test.asm -f bin -o test.bin
	qemu-system-x86_64 test.bin