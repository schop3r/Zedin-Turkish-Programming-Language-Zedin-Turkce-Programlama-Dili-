.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s1: .asciz "x"
_s3: .asciz "y"
_s4: .asciz "x"
_s5: .asciz "y"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
_L0:
    // SAYI 10
    mov x0, #10
    str x0, [sp, #-16]!
_L3:
    // TANI x
    ldr x0, [sp], #16
    str x0, [x29, #-16]
_L6:
    // SAYI 20
    mov x0, #20
    str x0, [sp, #-16]!
_L9:
    // TANI y
    ldr x0, [sp], #16
    str x0, [x29, #-32]
_L12:
    // YUKLE x
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L15:
    // YUKLE y
    ldr x0, [x29, #-32]
    str x0, [sp, #-16]!
_L18:
    // TOPLA
    ldr x1, [sp], #16
    ldr x0, [sp], #16
    add x0, x0, x1
    str x0, [sp, #-16]!
_L19:
    // YAZ
    ldr x1, [sp], #16
    adr x0, _fmt_int
    bl printf
_L22:
    // HALT
    mov x0, #0
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
