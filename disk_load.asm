; args
; bx : what memory address to store the data into
; dx (split into dh and dl) :
;   dl : which boot drive
;   dh : how many sectors to read
disk_load:
    pusha
        push dx                 ; 'saving' dx because it conteins dh which tells us how many sectors to read
        ; setting up the registers
        mov ah, 0x02            ; function (notice how ah is used, just like the 'mov ah, 0x0e' for printing to screen)

        mov al, dh              ; read dh amount of sectors from there

        ; which track/cylinder
        mov ch, 0x00            ; select cylinder 0. begins from outer

        ; which head/surface (a head corresponds to a surface)
        mov dh, 0x00            ; select the first surface of the disk.

        ; which sector
        mov cl, 0x02            ; select 2nd sector from the track (just after the bootcode)
        
        ; interrupt call
        int 0x13

        ; checks
        jc disk_error_carry           ; carry flag error
        
        pop dx                  ; dh is now the dx that contains the 'original' dh
        cmp al, dh              ; after the interrupt actual number of sectors read is stored in al
        jne disk_error_unequal
    popa
    ret

disk_error_carry:
    mov bx, DISK_ERROR_MSG_CARRY
    call print_string
    jmp $

disk_error_unequal:
    mov bx, DISK_ERROR_UNEQUAL
    call print_string
    jmp $

DISK_ERROR_MSG_CARRY:
    db "Disk read error! (carry flag set)", 0

DISK_ERROR_UNEQUAL:
    db "Disk read error! (expected and read sector are not the same)", 0
