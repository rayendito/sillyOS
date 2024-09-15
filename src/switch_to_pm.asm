[bits 16]
switch_to_pm:
    cli         ; chatgpt says: When you use CLI (Clear Interrupt Flag), it only disables maskable hardware interrupts, not software interrupts like INT 0x10.
    lgdt [gdt_descriptor]

    ; the first bit of cr0 is the "turn on 32-bit" switch, basically
    ; but we cant set it directly, so we use eax
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; far jump is when you do a jump that uses ":" then i assume?
    ; we need to "force" to do this so that it triggers the "flush"
    ; it's current operations
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    ; DATA_SEG is the start of a segment descriptor (data, in this case) in the GDT
    ; it's what registers must contain in protected mode
    mov ax, DATA_SEG
    
    ; initialize every segment register as data segment
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; initializing the stack
    mov ebp, 0x9000
    mov esp, ebp

    jmp BEGIN_PM
