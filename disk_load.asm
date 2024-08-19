; args
; bx : what memory address to store the data into
; dx (split into dh and dl) :
;   dl : which boot drive
;   dh : how many sectors to read
disk_load:
    pusha
        ; function (notice how ah is used, just like the 'mov ah, 0x0e' for printing to screen)
        mov ah, 0x02

        push dx                 ; 'saving' dx because it contains dh which tells us how many sectors to read
        
        ;
        ; setting up the registers
        ;
        mov al, dh              ; read dh amount of sectors from there

        ; which track/cylinder
        mov ch, 0               ; select cylinder 0

        ; which head/surface (a head corresponds to a surface)
        mov dh, 0               ; select the first surface of the disk.

        ; which sector (remember one sector is 512)
        mov cl, 2               ; select 2nd sector (index starts from 1)
        
        ; interrupt call
        int 0x13

        ; checks
        jc disk_error_carry     ; carry flag error
        
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
