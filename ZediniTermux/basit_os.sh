cat <<EOF > boot.asm
[org 0x7c00]
KERNEL_OFFSET equ 0x1000
mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp
call load_kernel
call switch_to_pm
jmp $
%include "gdt.asm"
[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 30
    mov dl, [BOOT_DRIVE]
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    int 0x13
    ret
switch_to_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:init_pm
[bits 32]
init_pm:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    call KERNEL_OFFSET
    jmp $
BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xAA55
EOF

cat <<EOF > gdt.asm
gdt_start:
    dd 0x0, 0x0
gdt_code:
    dw 0xffff, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
gdt_data:
    dw 0xffff, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
EOF

cat <<EOF > kernel_entry.asm
[bits 32]
[extern main]
_start:
    call main
    jmp $
EOF

cat <<EOF > kernel.c
void main() {
    char* vidptr = (char*)0xb8000;
    char* msg = "ZEDINI OS: TERMINAL MODU AKTIF!";
    int i = 0;
    while(msg[i] != 0) {
        vidptr[i*2] = msg[i];
        vidptr[i*2+1] = 0x07;
        i++;
    }
    while(1);
}
EOF

