[org 0x7c00] ; BIOS places the OS instructions in this address. so assume everything begins here

KERNEL_OFFSET equ 0x1000 ; where the kernel instructions (compiled from c) resides
mov [BOOT_DRIVE], dl ; dl contains boot drive at the beginning. we save it to a label in case we use the dx register later

BEGIN_RM:
    ; setting up stack
    ; remember: stack grows downwards, meaning that newer pushes are stored on a lower memory address
    mov bp, 0x9000
    mov sp, bp

    ; begin in real mode
    mov bx, MESSAGE_REAL_MODE
    call print_string
    call print_newline

    call load_kernel
    call switch_to_pm

    jmp $

; imports
%include "src/printing.asm"             ; for printing in real mode
%include "src/disk_load.asm"            ; for loading 
%include "src/gdt.asm"                  ; defining the actual contents of the GDT
%include "src/switch_to_pm.asm"         ; switching to protected mode
%include "src/printing_pm.asm"          ; printing in protected mode

[bits 16] ; 16-bit instructions for loading the kernel code to 0x1000
load_kernel:
    ; printing ygy
    mov bx, MESSAGE_LOAD_KERNEL
    call print_string
    call print_newline

    mov bx, KERNEL_OFFSET   ; where to store the read bytes into
    mov dh, 1               ; how many sectors to read
    mov dl, [BOOT_DRIVE]    ; which boot drive
    call disk_load          ; note: we didn't specify which sector bc in this disk_load routine, it's alr hardcoded begin from the second sector
    ret

[bits 32] ; 32-bit instructions (we already did this on switch_to_pm.asm but let's call it again for clarity lol)
BEGIN_PM:
    mov ebx, MESSAGE_PROTECTED_MODE
    call print_string_pm    ; printing protected mode message by writing directly to video memory
    call KERNEL_OFFSET      ; EXECUTE C CODE GUANNNNN
    jmp $

; global variables
BOOT_DRIVE:
    db 0

MESSAGE_REAL_MODE:
    db 'starting in 16-bit real mode', 0

MESSAGE_LOAD_KERNEL:
    db 'loading kernel w BIOS interrupt', 0

MESSAGE_PROTECTED_MODE:
    db 'close enough, welcome back 32-bit protected mode',0

times 510-($-$$) db 0
dw 0xAA55
