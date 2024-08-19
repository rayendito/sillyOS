;where we are in the program
[org 0x7c00]


; setting up es
mov bx, 0xa000
mov es, bx

mov [BOOT_DRIVE], dl                ; dl is where BIOS stores our boot code
                                    ; save it to the variable

;setting up stack
mov bp, 0x8000
mov sp, bp

;accessing memory
mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call disk_load

; checking what's inside
mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex

jmp $

; importing files
%include "printing.asm"
%include "disk_load.asm"

; global variables
BOOT_DRIVE:
    db 0

times 510-($-$$) db 0
dw 0xAA55
; BIOS only loads boot code up to this point (512 bytes)
; we can add our dummy data below it bc it will be stored in the
; boot disk, but not loaded to the memory automatically

times 256 dw 0xdada
times 256 dw 0xface