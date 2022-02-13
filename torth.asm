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
    mov rax, mem
    push rax

addr_1:
    push  98

addr_2:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_3:
    push  1

addr_4:
    pop rbx
    pop rax
    mov [rax], bl

addr_5:
    push  0

addr_6:
addr_7:
    pop rax
    push rax
    push rax

addr_8:
    push  98

addr_9:
    mov rcx, 0
    mov rdx, 1
    pop rax
    pop r12
    cmp r12, rax
    cmovl rcx, rdx
    push rcx

addr_10:
    pop rax
    test rax, rax
    jz addr_116

addr_11:
    push  0

addr_12:
addr_13:
    pop rax
    push rax
    push rax

addr_14:
    push  100

addr_15:
    mov rcx, 0
    mov rdx, 1
    pop rax
    pop r12
    cmp r12, rax
    cmovl rcx, rdx
    push rcx

addr_16:
    pop rax
    test rax, rax
    jz addr_44

addr_17:
    pop rax
    push rax
    push rax

addr_18:
    mov rax, mem
    push rax

addr_19:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_20:
    pop rax
    xor rbx, rbx
    mov bl, [rax]
    push rbx

addr_21:
    pop rax
    test rax, rax
    jz addr_28

addr_22:
    mov rax, mem
    push rax

addr_23:
    push  100

addr_24:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_25:
    push  42

addr_26:
    pop rbx
    pop rax
    mov [rax], bl

addr_27:
    jmp addr_33

addr_28:
    mov rax, mem
    push rax

addr_29:
    push  100

addr_30:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_31:
    push  32

addr_32:
    pop rbx
    pop rax
    mov [rax], bl

addr_33:
addr_34:
    push  1

addr_35:
    mov rax, mem
    push rax

addr_36:
    push  100

addr_37:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_38:
    push  1

addr_39:
    push  0x2000004

addr_40:
    pop rax
    pop rdi
    pop rsi
    pop rdx
    syscall

addr_41:
    push  1

addr_42:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_43:
    jmp addr_12

addr_44:
    pop rax
addr_45:
    mov rax, mem
    push rax

addr_46:
    push  100

addr_47:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_48:
    push  10

addr_49:
    pop rbx
    pop rax
    mov [rax], bl

addr_50:
    push  1

addr_51:
    mov rax, mem
    push rax

addr_52:
    push  100

addr_53:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_54:
    push  1

addr_55:
    push  0x2000004

addr_56:
    pop rax
    pop rdi
    pop rsi
    pop rdx
    syscall

addr_57:
    mov rax, mem
    push rax

addr_58:
    pop rax
    xor rbx, rbx
    mov bl, [rax]
    push rbx

addr_59:
    push  1

addr_60:
    pop rcx
    pop rbx
    shl rbx, cl
    push rbx

addr_61:
    mov rax, mem
    push rax

addr_62:
    push  1

addr_63:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_64:
    pop rax
    xor rbx, rbx
    mov bl, [rax]
    push rbx

addr_65:
    pop rax
    pop rbx
    or  rbx, rax
    push rbx

addr_66:
    push  1

addr_67:
addr_68:
    pop rax
    push rax
    push rax

addr_69:
    push  98

addr_70:
    mov rcx, 0
    mov rdx, 1
    pop rax
    pop r12
    cmp r12, rax
    cmovl rcx, rdx
    push rcx

addr_71:
    pop rax
    test rax, rax
    jz addr_99

addr_72:
    pop rax
    pop rbx
    push rax
    push rbx

addr_73:
    push  1

addr_74:
    pop rcx
    pop rbx
    shl rbx, cl
    push rbx

addr_75:
    push  7

addr_76:
    pop rax
    pop rbx
    and  rbx, rax
    push rbx

addr_77:
    pop rax
    pop rbx
    push rbx
    push rax
    push rbx

addr_78:
    mov rax, mem
    push rax

addr_79:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_80:
    push  1

addr_81:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_82:
    pop rax
    xor rbx, rbx
    mov bl, [rax]
    push rbx

addr_83:
    pop rax
    pop rbx
    or  rbx, rax
    push rbx

addr_84:
    pop rax
    pop rdx
    push rdx
    push rdx
    push rax
    push rdx
    push rax

addr_85:
    push  110

addr_86:
    pop rax
    pop rbx
    push rax
    push rbx

addr_87:
    pop rcx
    pop rbx
    shr rbx, cl
    push rbx

addr_88:
    push  1

addr_89:
    pop rax
    pop rbx
    and  rbx, rax
    push rbx

addr_90:
    pop rax
    pop rbx
    push rax
    push rbx

addr_91:
    mov rax, mem
    push rax

addr_92:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_93:
    pop rax
    pop rbx
    push rax
    push rbx

addr_94:
    pop rbx
    pop rax
    mov [rax], bl

addr_95:
    pop rax
    pop rbx
    push rax
    push rbx

addr_96:
    push  1

addr_97:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_98:
    jmp addr_67

addr_99:
    pop rax
addr_100:
    pop rax
addr_101:
    push  0

addr_102:
addr_103:
    pop rax
    push rax
    push rax

addr_104:
    push  97

addr_105:
    mov rcx, 0
    mov rdx, 1
    pop rax
    pop r12
    cmp r12, rax
    cmovl rcx, rdx
    push rcx

addr_106:
    pop rax
    test rax, rax
    jz addr_112

addr_107:
    pop rax
    pop rbx
    push rax
    push rbx

addr_108:
    pop rax
addr_109:
    push  1

addr_110:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_111:
    jmp addr_102

addr_112:
    pop rax
addr_113:
    push  1

addr_114:
    pop    rax
    pop    rbx
    add    rbx, rax
    push   rbx

addr_115:
    jmp addr_6

addr_116:
    pop rax
addr_117:
    mov    rax, 0x2000001 ; exit
    mov    rdi, 0
    syscall

section .bss
    mem: resb 50000
