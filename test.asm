[org 0x7c00]

mov ebx, the_string
call print_string_pm

jmp $

%include "printing_pm.asm"

the_string:
    db 'Hello, world!', 0

times 510-($-$$) db 0
dw 0xaa55