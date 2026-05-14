.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"
_s1: .asciz "i"
_s2: .asciz "i"
_s4: .asciz "i"
_s5: .asciz "i"
_s7: .asciz "i"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
_L0:
    // SAYI 0
    mov x0, #0
    str x0, [sp, #-16]!
_L3:
    // TANI i
    ldr x0, [sp], #16
    str x0, [x29, #-16]
_L6:
    // YUKLE i
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L9:
    // SAYI 5
    mov x0, #5
    str x0, [sp, #-16]!
_L12:
    // KUCUK
    ldr x1, [sp], #16
    ldr x0, [sp], #16
    cmp x0, x1
    cset x0, lt
    str x0, [sp, #-16]!
_L13:
    // ATLA_YANLIS
    ldr x0, [sp], #16
    cbz x0, _L36
_L16:
    // YUKLE i
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L19:
    // YAZ
    ldr x1, [sp], #16
    adr x0, _fmt_int
    bl printf
_L22:
    // YUKLE i
    ldr x0, [x29, #-16]
    str x0, [sp, #-16]!
_L25:
    // SAYI 1
    mov x0, #1
    str x0, [sp, #-16]!
_L28:
    // TOPLA
    ldr x1, [sp], #16
    ldr x0, [sp], #16
    add x0, x0, x1
    str x0, [sp, #-16]!
_L29:
    // SAKLA i
    ldr x0, [sp], #16
    str x0, [x29, #-16]
    str x0, [sp, #-16]!
_L32:
    // POP
    add sp, sp, #16
_L33:
    // ATLA
    b _L6
_L36:
    // HALT
    mov x0, #0
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
