VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; pm means protected mode
; ebx is pointing to the string to print -- seeing
; edx is pointing to the video memory -- writing
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

    print_string_pm_loop:
        cmp byte [ebx], 0
        je print_string_pm_done

        ;using ax as a temporary variable, as this register is no longer used for interrupts
        mov al, [ebx]               ; the character
        mov ah, WHITE_ON_BLACK      ; color and background of character
        
        mov [edx], ax               ; moving what's in ax to what's pointed to by edx, which is video memory

        ; moving next
        add ebx, 1      ; immediate next address is the next character
        add edx, 2      ; immediate next address is color info, so jump 2 to actually get to print to next

        jmp print_string_pm_loop
    
    print_string_pm_done:
    popa
    ret