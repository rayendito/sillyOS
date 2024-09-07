; GDT can be thought of as an array of segment descriptors
; like in the name "segment descriptors", each entry describes
; a segment in the memory (where is it, how big it is, who can access it)
; each segment descriptor is of size *8 bytes*. consists of the following
; -- 32 bits for base address (where it begins)
; -- 20 bits for the segment size
; -- rest are flags which describe the characteristic of the segment, e. g. who can access it

gdt_start:
    ; 1st entry of the GDT, the null descriptor
    gdt_null:
        dd 0x0      ; dd is 32 bits -- 32/8 = 4 bytes
        dd 0x0      ; second 4 bytes, that makes 8 bytes. (1 seg. desc. -> 8 bytes)

    ; refer to the crazy structure defined by intel
    ; https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3a-part-1-manual.pdf
    
    ; 2nd entry of the GDT, the code segment
    gdt_code:
        dw 0xffff   ;0:15 limit (db is 8 bit)
        
        dw 0x0      ;0:15 base
        db 0x0      ;16:23 base
        
        ; (left to right)
        ; present   : in memory or not
        ; privilege : defines access controls(?)
        ; code/data : 1 for code or data segment, 0 is used for traps
        ; type :
        ;           : code/data
        ;           : conforming
        ;           : readable
        ;           : accessed
        ;    present(1)--privilege(2 bits)--code/data(1 bit)--type(4 bits)
        ; db 1           00                 1                 1010b
        ; ^if we stretch it out
        db 10011010b

        ; (left to right)
        ; granularity           : multiplies the limit
        ; 32-bit default
        ; 64-bit code segment
        ; AVL                   : We can set this for our own uses (e.g. debugging)
        db 11001111b

        ; 24:31 base
        db 0x0

    gdt_data:
        dw 0xffff   ;0:15 limit (db is 8 bit)
        
        dw 0x0      ;0:15 base
        db 0x0      ;16:23 base
        
        ;everything else is the same but the 'type' bits
        ; type :
        ;           : code/data
        ;           : conforming
        ;           : readable
        ;           : accessed
        ;    present(1)--privilege(2 bits)--code/data(1 bit)--type(4 bits)
        ; db 1           00                 1                 0010b
        ; ^if we stretch it out
        db 10010010b
        db 11001111b

        ; 24:31 base
        db 0x0 

gdt_end:

;GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; minus one because?
    dd gdt_start 

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
