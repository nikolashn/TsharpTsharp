
# ----------------
# ---- tokens ----
# ----------------

0 -> enum_count
block enum do
    try
        if dup typeof bool == do
            -> bool_value
            if bool_value do
                0 -> enum_count
                enum_count
            else
                enum_count
            end
        else
            enum_count
        end
    except StackUnderflowError do
        enum_count
    end
    enum_count 1 + -> enum_count
end

true
enum -> OP_INT
enum -> OP_STR
enum -> OP_HEX
enum -> OP_VAR
enum -> OP_PRINT
enum -> OP_DUP
enum -> OP_DUP2
enum -> OP_SWAP
enum -> OP_OVER
enum -> OP_DROP
enum -> OP_PLUS
enum -> OP_MINUS
enum -> OP_MUL
enum -> OP_DIV
enum -> OP_EQUALS
enum -> OP_IS_EQUALS
enum -> OP_LESS_THAN
enum -> OP_GREATER_THAN
enum -> OP_RIGHT_SHIFT
enum -> OP_LEFT_SHIFT
enum -> OP_BIT_OR
enum -> OP_BIT_AND
enum -> OP_IF
enum -> OP_END
enum -> OP_ELSE
enum -> OP_FOR
enum -> OP_DO
enum -> OP_MEM
enum -> OP_READ
enum -> OP_WRITE
enum -> OP_SYSCALL
enum -> OP_EOF

# ---------------
# ---- lexer ----
# ---------------

0 -> program_length
0 -> lexer_index
1 -> lexer_line
0 -> lexer_col 
{} -> arr_ops

block lexer_init do
    len -> program_length
    0 -> lexer_index
    {} -> arr_ops
end

block lexer_advance do
    lexer_col inc -> lexer_col
    lexer_index inc -> lexer_index
end

block lexer do
    for true do
        if lexer_index program_length == do
            arr_ops { OP_EOF "OP_EOF" } append -> arr_ops
            break
        end
        program lexer_index read -> lexer_char
        if lexer_char " " == do
            lexer_advance
        elif lexer_char "\n" == do
            lexer_line inc -> lexer_line
            0 -> lexer_col
            lexer_advance
        elif lexer_char "|" == do
            lexer_advance
            arr_ops { OP_BIT_OR "|" } append -> arr_ops
        elif lexer_char "&" == do
            lexer_advance
            arr_ops { OP_BIT_AND "&" } append -> arr_ops
        elif lexer_char "<" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak "<" == do
                lexer_advance
                arr_ops { OP_LEFT_SHIFT "<<" } append -> arr_ops
            else
                arr_ops { OP_LESS_THAN "<" } append -> arr_ops
            end
        elif lexer_char ">" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak ">" == do
                lexer_advance
                arr_ops { OP_RIGHT_SHIFT ">>" } append -> arr_ops    
            else
                arr_ops { OP_GREATER_THAN ">" } append -> arr_ops
            end
        elif lexer_char "#" == do
            for true do
                lexer_advance
                program lexer_index read -> lexer_char
                if lexer_char "\n" == do
                    break
                end
            end
        elif lexer_char "+" == do
            arr_ops { OP_PLUS "+" } append -> arr_ops
            lexer_advance
        elif lexer_char "-" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak ">" == do
                lexer_advance
                arr_ops { OP_EQUALS "->" } append -> arr_ops
            else
                arr_ops { OP_MINUS "-" } append -> arr_ops
            end
        elif lexer_char "=" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak "=" == do
                lexer_advance
                arr_ops { OP_IS_EQUALS "==" } append -> arr_ops
            else
                # TODO: write error message.
                "SyntaxError:" print lexer_line print ":" print lexer_col print ": unexpected token..." println
                exit
            end
        elif lexer_char "*" == do
            arr_ops { OP_MUL "*" } append -> arr_ops
            lexer_advance
        elif lexer_char "/" == do
            arr_ops { OP_DIV "/" } append -> arr_ops
            lexer_advance
        elif lexer_char isdigit do
            "" -> lexer_int
            false -> IsHex
            lexer_int lexer_char + -> lexer_int
            lexer_advance
            program lexer_index read -> lexer_char
            if lexer_char "x" == do # hexadecimal
                true -> IsHex
                lexer_int lexer_char + -> lexer_int
                lexer_advance
                program lexer_index read -> lexer_char
            end
            for true do
                if lexer_index program_length == do
                    break
                end
                program lexer_index read -> lexer_char
                if lexer_char " " == do
                    break
                elif lexer_char isdigit true != do
                    break
                end
                lexer_int lexer_char + -> lexer_int
                lexer_advance
            end
            if IsHex do
                arr_ops { OP_HEX lexer_int } append -> arr_ops
            else
                arr_ops { OP_INT lexer_int } append -> arr_ops
            end
        elif lexer_char '\"' == do
            "" -> lexer_str
            #lexer_str lexer_char + -> lexer_str
            lexer_advance
            for true do
                if lexer_index program_length == do
                    break
                end
                program lexer_index read -> lexer_char
                if lexer_char '\"' == do
                    lexer_advance
                    break
                end
                lexer_str lexer_char + -> lexer_str
                lexer_advance
            end
            arr_ops { OP_STR lexer_str } append -> arr_ops
        else
            "" -> lexer_id
            lexer_id lexer_char + -> lexer_id
            lexer_advance
            for true do
                if lexer_index program_length == do
                    break
                end
                program lexer_index read -> lexer_char
                if lexer_char " " == do
                    break
                elif lexer_char "\n" == do
                    break
                end
                lexer_id lexer_char + -> lexer_id
                lexer_advance
            end
            if lexer_id "print" == do
                arr_ops { OP_PRINT lexer_id } append -> arr_ops
            elif lexer_id "if" == do
                arr_ops { OP_IF lexer_id } append -> arr_ops
            elif lexer_id "end" == do
                arr_ops { OP_END lexer_id } append -> arr_ops
            elif lexer_id "else" == do
                arr_ops { OP_ELSE lexer_id } append -> arr_ops
            elif lexer_id "dup" == do
                arr_ops { OP_DUP lexer_id } append -> arr_ops
            elif lexer_id "for" == do
                arr_ops { OP_FOR lexer_id } append -> arr_ops
            elif lexer_id "do" == do
                arr_ops { OP_DO lexer_id } append -> arr_ops
            elif lexer_id "drop" == do
                arr_ops { OP_DROP lexer_id } append -> arr_ops
            elif lexer_id "mem" == do
                arr_ops { OP_MEM lexer_id } append -> arr_ops
            elif lexer_id "read" == do
                arr_ops { OP_READ lexer_id } append -> arr_ops
            elif lexer_id "write" == do
                arr_ops { OP_WRITE lexer_id } append -> arr_ops
            elif lexer_id "syscall" == do
                arr_ops { OP_SYSCALL lexer_id } append -> arr_ops
            elif lexer_id "dup2" == do
                arr_ops { OP_DUP2 lexer_id } append -> arr_ops
            elif lexer_id "swap" == do
                arr_ops { OP_SWAP lexer_id } append -> arr_ops
            elif lexer_id "over" == do
                arr_ops { OP_OVER lexer_id } append -> arr_ops
            else
                arr_ops { OP_VAR lexer_id } append -> arr_ops
            end
        end
    end
end

# variables { { VarName type } { VarName type } { VarName type } ... }
{} -> variables

block parse do
    # `do` `end` `if` `else`
    # { op token , op value , where to jump }

    # for loop example
    # {{0, 0}, {15, for}, {2, dup}, {0, 100}, {10, <}, {16, do, 11}, {2, dup}, {1, print}, {0, 1}, {4, +}, {13, end, 1}, {3, drop}, {17, OP_EOF}}

    {} -> addr_stack
    arr_ops len -> length

    0 -> i
    for true do
        if length i == do
            break
        end
        arr_ops i read -> op
        if op 0 read OP_IF == do
            addr_stack i append -> addr_stack
        elif op 0 read OP_ELSE == do
            addr_stack addr_stack len 1 - read -> if_addr
            addr_stack addr_stack len 1 - remove -> addr_stack
            arr_ops { OP_IF "if" i 1 + } if_addr replace -> arr_ops
            addr_stack i append -> addr_stack
        elif op 0 read OP_END == do
            addr_stack addr_stack len 1 - read -> block_adrr
            addr_stack addr_stack len 1 - remove -> addr_stack

            if arr_ops block_adrr read 0 read OP_IF == arr_ops block_adrr read 0 read OP_ELSE == || do
                arr_ops { arr_ops block_adrr read 0 read arr_ops block_adrr read 1 read i } block_adrr replace -> arr_ops
                arr_ops { OP_END "end" i 1 + } i replace -> arr_ops
            elif arr_ops block_adrr read 0 read OP_DO == do
                arr_ops { OP_END "end" arr_ops block_adrr read 2 read } i replace -> arr_ops
                arr_ops { OP_DO "do" i 1 + } block_adrr replace -> arr_ops
            end
        elif op 0 read OP_FOR == do
            addr_stack i append -> addr_stack            
        elif op 0 read OP_DO == do
            addr_stack addr_stack len 1 - read -> for_adrr
            addr_stack addr_stack len 1 - remove -> addr_stack
            arr_ops { OP_DO "do" for_adrr } i replace -> arr_ops
            addr_stack i append -> addr_stack
        elif op 0 read OP_EQUALS == do
            i inc -> i
            arr_ops i read -> op
            if op 0 read OP_VAR == do
                "variable definitions are not implemented yet :D\n" print exit
            else
                "unexpected token type" print op 0 read println exit
            end
        end
        i inc -> i
    end
end

# ---------------------------
# ------ generate ASM  ------
# ---------------------------

"torth.asm" fopen -> F
F ftruncate
0 -> stack_size

block inc_stack_size do
    stack_size 1 + -> stack_size # decrement the stack size.
end

block dec_stack_size do
    stack_size 1 - -> stack_size # decrement the stack size.
end

block asm_gen do -> arr_ops

    "GLOBAL _main\n\n" F fwrite

    "section .text\n\n" F fwrite

    "print:\n" F fwrite
    "    sub     rsp, 40\n" F fwrite
    "    mov     BYTE [rsp+31], 0xA\n" F fwrite
    "    test    rdi, rdi\n" F fwrite
    "    jne     .L2\n" F fwrite
    "    mov     BYTE [rsp+30], 48\n" F fwrite
    "    mov     edx, 30\n" F fwrite
    "    mov     r8d, 2\n\n" F fwrite

    ".L3:\n" F fwrite
    "    lea     rsi, [rsp+rdx]\n" F fwrite
    "    mov     edi, 1\n" F fwrite
    "    mov     rdx, r8\n" F fwrite
    "    mov     rax, 0x2000004 ; write\n" F fwrite
    "    syscall\n" F fwrite
    "    add     rsp, 40\n" F fwrite
    "    ret\n\n" F fwrite

    ".L2:\n" F fwrite
    "    mov  r9, -3689348814741910323\n" F fwrite
    "    lea     rcx, [rsp+30]\n\n" F fwrite

    ".L4:\n" F fwrite
    "    mov     rax, rdi\n" F fwrite
    "    lea     r8, [rsp+32]\n" F fwrite
    "    mul     r9\n" F fwrite
    "    mov     rax, rdi\n" F fwrite
    "    sub     r8, rcx\n" F fwrite
    "    shr     rdx, 3\n" F fwrite
    "    lea     rsi, [rdx+rdx*4]\n" F fwrite
    "    add     rsi, rsi\n" F fwrite
    "    sub     rax, rsi\n" F fwrite
    "    add     eax, 48\n" F fwrite
    "    mov     BYTE [rcx], al\n" F fwrite
    "    mov     rax, rdi\n" F fwrite
    "    mov     rdi, rdx\n" F fwrite
    "    mov     rdx, rcx\n" F fwrite
    "    sub     rcx, 1\n" F fwrite
    "    cmp     rax, 9\n" F fwrite
    "    ja      .L4\n" F fwrite
    "    lea     rax, [rsp+32]\n" F fwrite
    "    sub     rdx, rax\n" F fwrite
    "    add     rdx, 32\n" F fwrite
    "    jmp     .L3\n\n" F fwrite

    "global start\n\n" F fwrite

    "_main:\n" F fwrite

    arr_ops len -> length
    {} -> strings

    0 for dup length < do -> i
        "addr_" i itoa ":" "\n" + + + F fwrite

        arr_ops i read -> op
        op 0 read -> op_type
        op 1 read -> op_value

        if op_type OP_PRINT == do
            "    pop rdi\n" F fwrite
            "    call print\n\n" F fwrite
        elif op_type OP_DUP == do
            "    pop rax\n" F fwrite
            "    push rax\n" F fwrite
            "    push rax\n\n" F fwrite
        elif op_type OP_DUP2 == do
            "    pop rax\n" F fwrite
            "    pop rdx\n" F fwrite
            "    push rdx\n" F fwrite
            "    push rdx\n" F fwrite
            "    push rax\n" F fwrite
            "    push rdx\n" F fwrite
            "    push rax\n\n" F fwrite
        elif op_type OP_SWAP == do
            "    pop rax\n" F fwrite
            "    pop rbx\n" F fwrite
            "    push rax\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_LEFT_SHIFT == do
            "    pop rcx\n" F fwrite
            "    pop rbx\n" F fwrite
            "    shl rbx, cl\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_RIGHT_SHIFT == do
            "    pop rcx\n" F fwrite
            "    pop rbx\n" F fwrite
            "    shr rbx, cl\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_BIT_OR == do
            "    pop rax\n" F fwrite
            "    pop rbx\n" F fwrite
            "    or  rbx, rax\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_BIT_AND == do
            "    pop rax\n" F fwrite
            "    pop rbx\n" F fwrite
            "    and  rbx, rax\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_OVER == do
            "    pop rax\n" F fwrite
            "    pop rbx\n" F fwrite
            "    push rbx\n" F fwrite
            "    push rax\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_MEM == do
            "    mov rax, mem\n" F fwrite
            "    push rax\n\n" F fwrite
        elif op_type OP_READ == do
            "    pop rax\n" F fwrite
            "    xor rbx, rbx\n" F fwrite
            "    mov bl, [rax]\n" F fwrite
            "    push rbx\n\n" F fwrite
        elif op_type OP_WRITE == do
            "    pop rbx\n" F fwrite
            "    pop rax\n" F fwrite
            "    mov [rax], bl\n\n" F fwrite
        elif op_type OP_SYSCALL == do
            "    pop rax\n" F fwrite
            "    pop rdi\n" F fwrite
            "    pop rsi\n" F fwrite
            "    pop rdx\n" F fwrite
            "    syscall\n\n" F fwrite
        elif op_type OP_DROP == do
            "    pop rax\n" F fwrite
        elif op_type OP_IF == do
            op 2 read -> jmp_adrr
            "    pop rax\n" F fwrite
            "    test rax, rax\n" F fwrite
            "    jz addr_" jmp_adrr itoa "\n\n" + + F fwrite
        elif op_type OP_ELSE == do
            op 2 read -> jmp_adrr
            "    jmp addr_" jmp_adrr itoa "\n\n" + + F fwrite
        elif op_type OP_END == do
            op 2 read -> jmp_adrr
            if i 1 + jmp_adrr != do
                "    jmp addr_" jmp_adrr itoa "\n\n" + + F fwrite
            end            
        elif op_type OP_DO == do
            op 2 read -> jmp_adrr
            "    pop rax\n" F fwrite
            "    test rax, rax\n" F fwrite
            "    jz addr_" jmp_adrr itoa "\n\n" + + F fwrite
        elif op_type OP_INT == do
            "    push  " F fwrite op_value "\n\n" + F fwrite
        elif op_type OP_STR == do
            "    mov rax, string_len_" strings len itoa  + "\n" + F fwrite
            "    push rax\n" F fwrite
            "    mov rsi, string_" strings len itoa  + "\n" + F fwrite
            "    push rsi\n\n" F fwrite
            strings op 1 read append -> strings
        elif op_type OP_HEX == do
            "    push  " F fwrite op_value "\n\n" + F fwrite
        elif op_type OP_LESS_THAN == do
            "    mov rcx, 0\n" F fwrite
            "    mov rdx, 1\n" F fwrite
            "    pop rax\n" F fwrite
            "    pop r12\n" F fwrite
            "    cmp r12, rax\n" F fwrite
            "    cmovl rcx, rdx\n" F fwrite
            "    push rcx\n\n" F fwrite
        elif op_type OP_GREATER_THAN == do
            "    mov rcx, 0\n" F fwrite
            "    mov rdx, 1\n" F fwrite
            "    pop rax\n" F fwrite
            "    pop r12\n" F fwrite
            "    cmp r12, rax\n" F fwrite
            "    cmovg rcx, rdx\n" F fwrite
            "    push rcx\n\n" F fwrite
        elif op_type OP_PLUS == do
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    add    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
        elif op_type OP_MINUS == do
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    sub    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
        elif op_type OP_MUL == do
            false assert "not implemented yet"
        elif op_type OP_DIV == do
            false assert "not implemented yet"
        elif op_type OP_IS_EQUALS == do
            "    mov rcx, 0\n" F fwrite
            "    mov rdx, 1\n" F fwrite
            "    pop rax\n" F fwrite
            "    pop r12\n" F fwrite
            "    cmp r12, rax\n" F fwrite
            "    cmove rcx, rdx\n" F fwrite
            "    push rcx\n\n" F fwrite
        elif op_type OP_EOF == do
            break
        else
            if op_type OP_FOR != do
                "Syntax Error: unexpected token value '" op_value + "'" + println
                exit
            end
        end
        i inc
    end
    "    mov    rax, 0x2000001 ; exit\n" F fwrite
    "    mov    rdi, 0\n" F fwrite
    "    syscall\n\n" F fwrite
    "section .bss\n" F fwrite
    "    mem: resb 50000\n" F fwrite
    "section .data" F fwrite
    0 for dup strings len < do -> strings_i
        "\n    string_" F fwrite strings_i itoa F fwrite
        ': db ' F fwrite
        strings strings_i read uniquote b -> byte_arr
        0 for dup byte_arr len < do -> byte_index
            byte_arr byte_index read itoa F fwrite
            if byte_index byte_arr len 1 - < do
                ", "  F fwrite
            end
            byte_index inc
        end drop
        "\n    string_len_" F fwrite strings_i itoa F fwrite ": equ $ - " F fwrite
        "string_" F fwrite strings_i itoa F fwrite
        strings_i inc
    end
end


# ------------------
# ------ main ------
# ------------------

"" -> program

block main do
    # read program from file
    "main.torth" fopen -> ProgramF
    ProgramF fread -> program
    ProgramF fclose

    program lexer_init

    lexer

    parse

    arr_ops # println
    
    asm_gen

    F fclose # close file
    
    free

    # check for unhandled data
    #if stack_size 0 > do
    #    "Error: unhandled <int> type element on the stack." println
    #    exit
    #end
end

main

