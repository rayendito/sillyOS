;where we are in the program
[org 0x7c00]

; setting up stack
mov bp, 0x9000
mov sp, bp

; printing rial mode message
mov bx, MESSAGE_REAL_MODE
call print_string

BEGIN_PM:
    mov ebx, MESSAGE_PROTECTED_MODE
    call print_string_pm

jmp $

; imports
%include "src/printing.asm"
%include "src/gdt.asm"
%include "src/printing_pm.asm"
%include "src/switch_to_pm.asm"

; global variables
MESSAGE_REAL_MODE:
    db 'starting in 16-bit real mode', 0

MESSAGE_PROTECTED_MODE:
    db 'close enough, welcome back 32-bit protected mode',0

times 510-($-$$) db 0
dw 0xAA55
