# START HERE!
# PAD_SIZE := 8192

# [0]
# all is the default build in makefile
# all: <dependency> means you need <dependency> to run 'all'
# $< is SHORTCUT to the first prerequisite
# this part is just running qemu with the compiled OS image
all: images/silly-os
	qemu-system-x86_64 -drive format=raw,file=$<

# [1]
# this is a continuation of what you need to get images/silly-os i.e. [0]
# since the previous one needs it
# $^ is SHORTCUT to all prerequisites (dependencies), space-separated.
# $@ is SHORTCUT to the target (target is the one in <target>: <dependency(s)>)
# first part is to concatenate 2 files together (order matters)
# and then the script call for memory alignment purposes.
images/silly-os: bin/boot.bin bin/kernel.bin
	cat $^ > $@
	./src/sh/pad_img.sh

# [2]
# a branch of [1]'s dependency
# this part is just compiling the boot code using nasm
# -f flag is file format (duh lol)
# `bin` just gives you the raw x86 instruction bytes (remember nasm is for x86)
# with some other '-f's like elf/win[something], it just adds some other stuff
# for linking purposes (core instruction bytes mostly dont change though, but yk
# you mostly always have to add something if your want ur stuff to be able to do something)
# q to myself: so doing 'bin' only is not linkable?
bin/boot.bin: boot.asm
	nasm $< -f bin -o $@

# [3]
# a branch of [1]'s dependency too
# x86_64-elf-ld is a linker. x86_64 signifies the CPU, elf is linux, ld is just that its a linker
# -Ttext 0x1000 means place the .text (code) section at address 0x1000
# when this binary is loaded, assume the code lives at address 0x1000
# meaning that every address, references will assume it came from 0x1000
# why? because everytime you run a program, it needs somewhere to live in the memory,
# we need to specify where since we are literally compiling raw (binary). we dont need to do it
# for elf/win though, because it assumes there's gonna be an OS that will give that address for us
# --oformat binary is like -f bin lol just output it as binary. (apparently you can do that)
bin/kernel.bin: obj/kernel_entry.o obj/kernel.o
	x86_64-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# [4]
# a dependency branch of [3]
# same thing, just compilation with nasm
# but why we are not compiling it to binary? im compiling this later
# why do we need to link? because i did some imports between these 2 files
obj/kernel_entry.o: src/asm/kernel_entry.asm
	nasm $< -f elf64 -o $@

# [5]
# a dependency branch of [3]
# just compiling c basically
# -ffreestanding is basically just telling the compiler that this is bare metal, assume no standard library etc
# -ffreestanding is related to transforming .c to .o guys
# -c is just compiling, no linking (link with what? it's just one file??)
# ackshually, gcc does automatic linking with standard library, etc (man made horrors)
obj/kernel.o: src/c/kernel.c
	x86_64-elf-gcc -ffreestanding $< -c -o $@

# cleaning hehe
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
