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

void clear_screen_text_mode(){
    char BLANK_CHAR = ' ';
    int WHITE_TXT_BLACK_BG = 0x0F;
    
    char* video_memory = (char*) 0xb8000;
    for(int i = 0; i <= 80 * 25; i++){
        video_memory[i*2 + 1] = BLANK_CHAR;
        video_memory[i*2 + 2] = WHITE_TXT_BLACK_BG;
    }
    return;
}

void print_shell(){
    char* video_memory = (char*) 0xb8000;
    video_memory[1] = 's';
    video_memory[3] = 'i';
    video_memory[5] = 'l';
    video_memory[7] = 'l';
    video_memory[9] = 'y';
    
    video_memory[11] = '@';

    video_memory[13] = 'O';
    video_memory[15] = 'S';

    video_memory[17] = ':';

    video_memory[19] = '/';
    video_memory[21] = '$';
    return;
}

void main() {
    // clearing the secreen
    clear_screen_text_mode();
    print_shell();

    // where video memory is
    char* video_memory = (char*) 0xb8000;
}