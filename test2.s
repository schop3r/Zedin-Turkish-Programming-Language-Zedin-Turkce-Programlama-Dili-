.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s1: .asciz "a"
_s3: .asciz "b"
_s4: .asciz "a"
_s5: .asciz "b"
_s6: .asciz "toplam"
_s7: .asciz "toplam"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #64
_L0:
    // SAYI 10
    mov x0, #10
    str x0, [sp, #-16]!
_L3:
    // TANI a
    ldr x0, [sp], #16
    str x0, [x29, #-16]
_L6:
    // SAYI 32
    mov x0, #32
    str x0, [sp, #-16]!
_L9:
    // TANI b
    ldr x0, [sp], #16
    str x0, [x29, #-32]
_L12:
    // YUKLE a
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L15:
    // YUKLE b
    ldr x0, [x29, #-32]
    str x0, [sp, #-16]!
_L18:
    // TOPLA
    ldr x1, [sp], #16
    ldr x0, [sp], #16
    add x0, x0, x1
    str x0, [sp, #-16]!
_L19:
    // TANI toplam
    ldr x0, [sp], #16
    str x0, [x29, #-48]
_L22:
    // YUKLE toplam
    ldr x0, [x29, #-48]
    str x0, [sp, #-16]!
_L25:
    // YAZ
    ldr x1, [sp], #16
    adr x0, _fmt_int
    bl printf
_L28:
    // HALT
    mov x0, #0
    add sp, sp, #64
    ldp x29, x30, [sp], #16
    ret
