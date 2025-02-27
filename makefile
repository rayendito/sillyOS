# PAD_SIZE := 8192

all: images/silly-os
	qemu-system-x86_64 -drive format=raw,file=$<

images/silly-os: bin/boot.bin bin/kernel.bin
	cat $^ > $@
	./src/sh/pad_img.sh

bin/boot.bin: boot.asm
	nasm $< -f bin -o $@

bin/kernel.bin: obj/kernel_entry.o obj/kernel.o
	x86_64-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

obj/kernel_entry.o: src/asm/kernel_entry.asm
	nasm $< -f elf64 -o $@

obj/kernel.o: src/c/kernel.c
	x86_64-elf-gcc -ffreestanding $< -c -o $@

clean:
	rm bin/*.bin obj/*.o

test:
	nasm test.asm -f bin -o bin/test.bin
	qemu-system-x86_64 bin/test.bin

funny:
	nasm funny.asm -f bin -o bin/funny.bin
	qemu-system-x86_64 bin/funny.bin

disk:
	nasm disk_driver.asm -f bin -o bin/disk_driver.bin
	qemu-system-x86_64 bin/disk_driver.bin
