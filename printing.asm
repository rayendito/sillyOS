; put string first character in bx
print_string:
    pusha
    mov ah, 0x0e ; tele something mode

    loop_ps:
        cmp byte [bx], 0 ; if byte is 0, end loop
        je endloop_ps
        mov al, [bx] ; prepare the interrupt
        int 0x10 ; interrupt to print
        add bx, 1 ; increment to the next address
        jmp loop_ps
    
    endloop_ps:
    popa
    ret

print_newline:
    pusha
        mov ah, 0x0e
        mov al, 0x0d    ; ASCII code for carriage return
        int 0x10        ; Call BIOS interrupt
        mov al, 0x0a    ; ASCII code for line feed
        int 0x10        ; Call BIOS interrupt
    popa
    ret

; put hex in dx
print_hex:
    pusha
        ; move in the hex string
        ; start after the 0x
        mov bx, HEX_OUT
        add bx, 2

        ; change the contents of bx
        loop_ph:
            cmp word dx, 0
            je endloop_ph
            
            mov cx, dx
            and cx, 0xf000
            shr cx, 12
            
            cmp cx, 9
            jle ascii_digit
            add cx, 0x37 ; turn to ascii value of A-F
            jmp change_char
            ascii_digit:
            add cx, 0x30
            
            change_char:
            mov word [bx], cx
            shl dx, 4
            add bx, 1
            jmp loop_ph
        endloop_ph:

        ; returning to the front
        mov bx, HEX_OUT
        call print_string
    popa
    ret

HEX_OUT:
    db '0x0000',0