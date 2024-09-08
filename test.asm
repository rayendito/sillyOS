; [BITS 32]
[org 0x7c00]

mov ebx, the_string
call print_string_pm

jmp $

%include "src/printing_pm.asm"

the_string:
    db 'it runs lmao', 0

times 510-($-$$) db 0
dw 0xaa55