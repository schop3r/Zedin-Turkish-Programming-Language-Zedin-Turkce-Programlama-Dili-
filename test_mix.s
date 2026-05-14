.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s1: .asciz "x"
_s2: .asciz "Sayi:"
_s3: .asciz "x"
_s4: .asciz "Bitti!"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
_L0:
    // SAYI 42
    mov x0, #42
    str x0, [sp, #-16]!
    mov x9, #0
_L3:
    // TANI x
    ldr x0, [sp], #16
    str x0, [x29, #-16]
_L6:
    // METIN
    adr x0, _s2
    str x0, [sp, #-16]!
    mov x9, #1
_L9:
    // YAZ
    ldr x1, [sp], #16
    cmp x9, #1
    b.eq _yaz_str_12
    adr x0, _fmt_int
    bl printf
    b _yaz_son_12
_yaz_str_12:
    adr x0, _fmt_str
    bl printf
_yaz_son_12:
_L12:
    // YUKLE x
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L15:
    // YAZ
    ldr x1, [sp], #16
    cmp x9, #1
    b.eq _yaz_str_18
    adr x0, _fmt_int
    bl printf
    b _yaz_son_18
_yaz_str_18:
    adr x0, _fmt_str
    bl printf
_yaz_son_18:
_L18:
    // METIN
    adr x0, _s4
    str x0, [sp, #-16]!
    mov x9, #1
_L21:
    // YAZ
    ldr x1, [sp], #16
    cmp x9, #1
    b.eq _yaz_str_24
    adr x0, _fmt_int
    bl printf
    b _yaz_son_24
_yaz_str_24:
    adr x0, _fmt_str
    bl printf
_yaz_son_24:
_L24:
    // HALT
    mov x0, #0
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
