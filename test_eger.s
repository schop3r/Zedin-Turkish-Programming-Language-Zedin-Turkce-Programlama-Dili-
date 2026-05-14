.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s1: .asciz "x"
_s2: .asciz "x"
_s4: .asciz "x"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
_L0:
    // SAYI 10
    mov x0, #10
    str x0, [sp, #-16]!
_L3:
    // TANI x
    ldr x0, [sp], #16
    str x0, [x29, #-16]
_L6:
    // YUKLE x
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L9:
    // SAYI 5
    mov x0, #5
    str x0, [sp, #-16]!
_L12:
    // BUYUK
    ldr x1, [sp], #16
    ldr x0, [sp], #16
    cmp x0, x1
    cset x0, gt
    str x0, [sp, #-16]!
_L13:
    // ATLA_YANLIS
    ldr x0, [sp], #16
    cbz x0, _L22
_L16:
    // YUKLE x
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L19:
    // YAZ
    ldr x1, [sp], #16
    adr x0, _fmt_int
    bl printf
_L22:
    // HALT
    mov x0, #0
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
