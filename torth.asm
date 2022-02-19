GLOBAL _main

section .text

print:
    sub     rsp, 40
    mov     BYTE [rsp+31], 0xA
    test    rdi, rdi
    jne     .L2
    mov     BYTE [rsp+30], 48
    mov     edx, 30
    mov     r8d, 2

.L3:
 