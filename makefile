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