// compiled and linked on an M2 chip using cross compiler and linker
// compiling
// x86_64-elf-gcc c_files/kernel.c -c -o c_files/kernel.o
// linking
// x86_64-elf-ld -o bin/kernel.bin -Ttext 0x1000 c_files/kernel.o --oformat binary

// if developing using x86 architectures, the usual gcc and ld should be ok?

// ========================================================================
// note on -Ttext
// basically this specifies the offset of this code
// exactly like [org 0x7c00] for boot code
// but we're putting our kernel instructions in 0x1000
// if you look at page 14 it shows that 0x1000 is a free space in the memory after boot
// i think we can set this to anywhere? (unlike boot code which has to be on 0x7c00)
// why 0x7c00? https://f.osdev.org/viewtopic.php?t=24129

void some_other_function(){
    return;
}

void main() {
    // where video memory is
    char* video_memory = (char*) 0xb8000;

    // add something to the video memory
    *video_memory = 'P';
}