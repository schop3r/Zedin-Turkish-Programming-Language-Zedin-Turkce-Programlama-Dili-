.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s0: .asciz "Merhaba Zedin!"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
_L0:
    // METIN
    adr x0, _s0
    str x0, [sp, #-16]!
    mov x9, #1
_L3:
    // YAZ
    ldr x1, [sp], #16
    cmp x9, #1
    b.eq _yaz_str_6
    adr x0, _fmt_int
    bl printf
    b _yaz_son_6
_yaz_str_6:
    adr x0, _fmt_str
    bl printf
_yaz_son_6:
_L6:
    // HALT
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
