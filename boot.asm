[bits 16] ; 16-bit instructions (don't really need to do this, but just for clarity)
[org 0x7c00] ; BIOS places the OS instructions in this address. so assume everything begins here
BEGIN_RM:
    ; setting up stack
    ; remember: stack grows downwards, meaning that newer pushes are stored on a lower memory address
    mov bp, 0x9000
    mov sp, bp

    ; begin in real mode
    mov bx, MESSAGE_REAL_MODE
    call print_string
    call switch_to_pm

    jmp $

; imports
%include "src/printing.asm"             ; for printing in real mode
%include "src/switch_to_pm.asm"         ; switching to protected mode
%include "src/printing_pm.asm"          ; printing in protected mode
%include "src/gdt.asm"                  ; defining the actual contents of the GDT

[bits 32] ; 32-bit instructions (we already did this on switch_to_pm.asm but let's call it again for clarity lol)
BEGIN_PM:
    mov ebx, MESSAGE_PROTECTED_MODE
    call print_string_pm                ; printing protected mode message by writing directly to video memory
    jmp $

; global variables
MESSAGE_REAL_MODE:
    db 'starting in 16-bit real mode', 0

MESSAGE_PROTECTED_MODE:
    db 'close enough, welcome back 32-bit protected mode',0

times 510-($-$$) db 0
dw 0xAA55
