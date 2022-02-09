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
    lea     rsi, [rsp+rdx]
    mov     edi, 1
    mov     rdx, r8
    mov     rax, 0x2000004 ; write
    syscall
    add     rsp, 40
    ret

.L2:
    mov  r9, -3689348814741910323
    lea     rcx, [rsp+30]

.L4:
    mov     rax, rdi
    lea     r8, [rsp+32]
    mul     r9
    mov     rax, rdi
    sub     r8, rcx
    shr     rdx, 3
    lea     rsi, [rdx+rdx*4]
    add     rsi, rsi
    sub     rax, rsi
    add     eax, 48
    mov     BYTE [rcx], al
    mov     rax, rdi
    mov     rdi, rdx
    mov     rdx, rcx
    sub     rcx, 1
    cmp     rax, 9
    ja      .L4
    lea     rax, [rsp+32]
    sub     rdx, rax
    add     rdx, 32
    jmp     .L3

global start

_main:
addr_0:
    push  0

addr_1:
addr_2:
    pop rax
    push rax
    push rax

addr_3:
    push  10000000

addr_4:
    mov rcx, 0
    mov rdx, 1
    pop rax
    pop r12
    cmp r12, rax
    cmovl rcx, rdx
    push rcx

addr_5:
    pop rax
    test rax, rax
    jz addr_11

addr_6:
    pop rax
    push rax
    push rax

addr_7:
    pop rdi
    call print

addr_8:
    push  1

addr_9:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_10:
    jmp addr_1

addr_11:
    pop rax
addr_12:
    mov    rax, 0x2000001 ; exit
    mov    rdi, 0
    syscall
