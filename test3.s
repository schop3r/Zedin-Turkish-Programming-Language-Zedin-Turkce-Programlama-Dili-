.section .data
.align 3
_fmt_int: .asciz "%lld\n"
_fmt_str: .asciz "%s\n"

.section .text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
_L0:
    // HALT
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
