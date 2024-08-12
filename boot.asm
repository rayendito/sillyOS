;where we are in the program
[org 0x7c00]

;
; printing hex
;

mov dx, 0x1fb6
call print_hex

mov dx, 0x2fa7
call print_hex

jmp $

%include "printing.asm"
times 510-($-$$) db 0
dw 0xAA55