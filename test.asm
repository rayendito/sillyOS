; [bits 16]
[org 0x7c00]

; cli
; mov bx, the_string
; call print_string

mov ebx, the_string
call print_string_pm

jmp $

%include "src/printing_pm.asm"
%include "src/printing.asm"


the_string:
    db 'so this works', 0

[bits 32]

times 510-($-$$) db 0
dw 0xaa55