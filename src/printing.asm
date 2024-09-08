; put string first character in bx
print_string:
    pusha
        mov ah, 0x0e ; tele something mode

        loop_ps:
            cmp byte [bx], 0 ; if byte value in address pointed by bx is 0, end loop. [] is dereference
            je endloop_ps
            mov al, [bx] ; al is where the ascii byte to print should go. and it's pointed to by bx
            int 0x10 ; calling the interrupt
            add bx, 1 ; increment bx to point to the next address
            jmp loop_ps ; back to loop_ps
        
        endloop_ps:
    popa
    ret

print_newline:
    pusha
        mov ah, 0x0e    ; preparing the interrupt. entering tele-something mode
        mov al, 0x0d    ; ASCII code for carriage return
        int 0x10        ; Call BIOS interrupt
        mov al, 0x0a    ; ASCII code for line feed
        int 0x10        ; Call BIOS interrupt
    popa
    ret

; print whatever hex is in
; dx
print_hex:
    pusha
        mov bx, HEX_OUT ; move in the default hex string 0x0000
        add bx, 2       ; start after the 0x

        ; change the contents of bx
        loop_ph:
            cmp word bx, HEX_OUT + 6  ; if bx is 6, done (number of chars in the original string)
            je endloop_ph
            
            mov cx, dx      ; cx as a temporary variable
            and cx, 0xf000  ; get the MSB only by masking
            shr cx, 12      ; get this MSB to LSB
            
            cmp cx, 9       ; if it's a number, add with 0x30 to get the right ascii char
            jle ascii_digit
            add cx, 0x37    ; if it's A-F, add with 0x37 to get the right ascii char
            jmp change_char
            ascii_digit:
            add cx, 0x30
            
            change_char:
            mov word [bx], cx   ; changing the value pointed to by bx to the ascii character
            shl dx, 4           ; get the next char to print
            add bx, 1           ; get the next address to store the char
            jmp loop_ph
        endloop_ph:

        ; returning to the front
        mov bx, HEX_OUT         ; return to the original first address of the dummy string
        call print_string       ; calling print string
        call print_newline
    popa
    ret

HEX_OUT:
    db '0x0000',0