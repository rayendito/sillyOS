#include <stdio.h>

int main(){
    printf("hello\n");
    return 0;
}

// notes while writing this
// so the results of the compilation is directly machine code.
// but, this still has some labels

// note on GCC
// the usual GCC command will, by default: (cite https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/Invoking-GCC.html)
// When you invoke GCC, it normally does preprocessing, compilation, assembly and linking.
// so like it does everything from preprocess -> linking, until it's executable
// you can, however, not go through all of it.
// as in you can tell gcc to just do the process up to compilation (no link yet)
