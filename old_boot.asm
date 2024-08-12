; we are here in the physical address
[org 0x07c00]


;
;   Question 4
;
mov bx, HELLO_MSG
call print_string

call print_newline

mov bx, GOODBYE_MSG
call print_string

; jmp the_end
jmp $

%include "printing.asm"

HELLO_MSG:
    db 'Hello, World!', 0

GOODBYE_MSG:
    db 'Goodbye!',0

; $ is the current byte number, basically
; $$ is the start of the section/segment
; so basically it's (current - begin) which gives
; how many bytes have alr been used
times 510-($-$$) db 0

; indicates a bootloader program
dw 0xAA55