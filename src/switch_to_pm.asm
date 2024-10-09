[bits 16]
switch_to_pm:
    cli         ; chatgpt says: When you use CLI (Clear Interrupt Flag), it only disables maskable hardware interrupts, not software interrupts like INT 0x10.
    lgdt [gdt_descriptor] ; load gdt command. this command will load 6 bytes, which is the GDT descriptor defined in gdt.asm

    ; the first bit of cr0 is the "turn on 32-bit" switch, basically
    ; but we cant set it directly, so we use eax
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; far jump is when you do a jump that uses ":" then i assume?
    ; we need to "force" to do this so that it triggers the "flush" it's current operations
    ; flushing the pipeline means completing all instructions currently in different stages of the pipeline
    ; a stage of a pipeline can be
    ; - fetching from memory
    ; - executing
    ; - putting back to memory
    ; - etc
    jmp CODE_SEG:init_pm
    ; we're trying to change the real mode code segment to our defined protected mode code segment (which is a segment selector)
    ; long jumps like this no longes shifts left by 4 bits because we're in protected mode alr
    ; the whole thing resolves the base address, etc from the segment selector we provide it, the CODE_SEG in this case

    ; in x86 protected mode, segment registers hold segment selectors,
    ; which are used to index into the GDT to find the base address and other attributes of the segment.
    ; segment selectors are 16 bits, bit 3-15 contain the actual index
    ; CS = 0x08 is a segment selector value, not a direct memory offset. (although yea it's kinda convenient)

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
