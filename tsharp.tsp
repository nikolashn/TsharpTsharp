
# ----------------
# ---- tokens ----
# ----------------

0 -> enum_index
block enum do
    try
        if dup typeof bool == do
            -> bool_value
            if bool_value do
                0 -> enum_index
                enum_index
            else
                enum_index
            end
        else
            enum_index
        end
    except StackUnderflowError do
        enum_index
    end
    enum_index 1 + -> enum_index
end

true
enum -> OP_INT
enum -> OP_PRINT
enum -> OP_PLUS
enum -> OP_MINUS
enum -> OP_MUL
enum -> OP_DIV
enum -> OP_EQUALS
enum -> OP_IS_EQUALS
enum -> OP_IF
enum -> OP_END
enum -> OP_ELSE
enum -> OP_EOF

# ---------------
# ---- lexer ----
# ---------------

0 -> program_length
0 -> lexer_index
1 -> lexer_line
0 -> lexer_col 
{} -> lexer_tokens

block lexer_init do
    len -> program_length
    0 -> lexer_index
    {} -> lexer_tokens
end

block lexer_advance do
    lexer_col inc -> lexer_col
    lexer_index inc -> lexer_index
end

block lexer do
    for true do
        if lexer_index program_length == do
            lexer_tokens { OP_EOF "OP_EOF" } append -> lexer_tokens
            break
        end
        program lexer_index read -> lexer_char
        if lexer_char " " == do
            lexer_advance
        elif lexer_char "\n" == do
            lexer_line inc -> lexer_line
            0 -> lexer_col
            lexer_advance
        elif lexer_char "'" == do
            lexer_advance
            "" -> lexer_string
            for true do
                program lexer_index read -> lexer_char
                if lexer_char "'" == do
                    lexer_advance
                    break
                end
                lexer_string lexer_char + -> lexer_string
                lexer_advance
            end
            lexer_tokens { TOKEN_STRING lexer_string } append -> lexer_tokens
        elif lexer_char "#" == do
            for true do
                lexer_advance
                program lexer_index read -> lexer_char
                if lexer_char "\n" == do
                    break
                end
            end
        elif lexer_char "+" == do
            lexer_tokens { OP_PLUS "+" } append -> lexer_tokens
            lexer_advance
        elif lexer_char "-" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak ">" == do
                lexer_advance
                lexer_tokens { OP_EQUALS "->" } append -> lexer_tokens
            else
                lexer_tokens { OP_MINUS "-" } append -> lexer_tokens
            end
        elif lexer_char "=" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak "=" == do
                lexer_advance
                lexer_tokens { OP_IS_EQUALS "==" } append -> lexer_tokens
            else
                # TODO: write error message.
                "SyntaxError:" print lexer_line print ":" print lexer_col print ": unexpected token..." println
                exit
            end
        elif lexer_char "*" == do
            lexer_tokens { OP_MUL "*" } append -> lexer_tokens
            lexer_advance
        elif lexer_char "/" == do
            lexer_tokens { OP_DIV "/" } append -> lexer_tokens
            lexer_advance
        elif lexer_char isdigit do
            "" -> lexer_int
            lexer_int lexer_char + -> lexer_int
            lexer_advance
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
            lexer_tokens { OP_INT lexer_int } append -> lexer_tokens
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
                lexer_tokens { OP_PRINT lexer_id } append -> lexer_tokens
            elif lexer_id "if" == do
                lexer_tokens { OP_IF lexer_id } append -> lexer_tokens
            elif lexer_id "end" == do
                lexer_tokens { OP_END lexer_id } append -> lexer_tokens
            elif lexer_id "else" == do
                lexer_tokens { OP_ELSE lexer_id } append -> lexer_tokens
            end
        end
    end
end

block parse do
    {} -> addr_stack
    lexer_tokens len -> length
    0 for dup length < do -> i
        lexer_tokens i read -> op
        if op 0 read OP_IF == do
            addr_stack i append -> addr_stack
        elif op 0 read OP_ELSE == do
            addr_stack addr_stack len 1 - read -> if_addr
            addr_stack addr_stack len 1 - remove -> addr_stack
            lexer_tokens { OP_IF "if" i 1 + } if_addr replace -> lexer_tokens
            addr_stack i append -> addr_stack
        elif op 0 read OP_END == do
            addr_stack addr_stack len 1 - read -> block_adrr
            addr_stack addr_stack len 1 - remove -> addr_stack

            if lexer_tokens block_adrr read 0 read OP_IF == lexer_tokens block_adrr read 0 read OP_ELSE == || do
                lexer_tokens { lexer_tokens block_adrr read 0 read lexer_tokens block_adrr read 1 read i } block_adrr replace -> lexer_tokens
            end
            # lexer_tokens { OP_IF "if" i } if_addr replace -> lexer_tokens
        end
        i inc
    end drop
end

# ---------------------------
# ------ generate ASM  ------
# ---------------------------

"tsharp.asm" fopen -> F
F ftruncate
0 -> stack_size

block inc_stack_size do
    stack_size 1 + -> stack_size # decrement the stack size.
end

block dec_stack_size do
    stack_size 1 - -> stack_size # decrement the stack size.
end

block asm_gen do -> lexer_tokens

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
    "    mov     rax, 0x2000004 ; call write\n" F fwrite
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

    lexer_tokens len -> length 

    0 for dup length < do -> i
        lexer_tokens i read -> op
        op 0 read -> op_type
        op 1 read -> op_value

        if op_type OP_PRINT == do
            if stack_size 1 < do
                "Error: `print` expected at least one element on the stack." println
                exit
            end
            dec_stack_size
            "    ; -- print --\n" F fwrite
            "    pop rdi\n" F fwrite
            "    call print\n\n" F fwrite
        elif op_type OP_IF == do
            dec_stack_size
            op 2 read -> jmp_adrr
            "    ; -- if --\n" F fwrite
            "    pop rax\n" F fwrite
            "    test rax, rax\n" F fwrite
            "    jz addr_" jmp_adrr itoa "\n\n" + + F fwrite
        elif op_type OP_ELSE == do
            op 2 read -> jmp_adrr
            "    ; -- else --\n" F fwrite
            "    jmp addr_" jmp_adrr itoa "\n\n" + + F fwrite
            "addr_" i 1 + itoa ":" "\n\n" + + + F fwrite
        elif op_type OP_END == do
            "addr_" i itoa ":" "\n\n" + + + F fwrite
        elif op_type OP_INT == do
            inc_stack_size
            "    ; -- push --\n" F fwrite
            "    push  " F fwrite op_value "\n\n" + F fwrite
        elif op_type OP_PLUS == do
            if stack_size 2 < do
                "Error: `+` expected at least two <int> type element on the stack." println
                exit
            end
            dec_stack_size
            "    ; -- plus --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    add    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
        elif op_type OP_MINUS == do
            if stack_size 2 < do
                "Error: `-` expected at least two <int> type element on the stack." println
                exit
            end
            dec_stack_size
            "    ; -- subtract --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    sub    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
        elif op_type OP_MUL == do
            false assert "not implemented yet"
        elif op_type OP_DIV == do
            false assert "not implemented yet"
        elif op_type OP_IS_EQUALS == do
            if stack_size 2 < do
                "Error: `==` expected at least two <int> type element on the stack." println
                exit
            end
            dec_stack_size
            # rewrite it later
            "    ; -- is equals --\n" F fwrite
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
            "Syntax Error: unexpected token value '" op_value + "'" + println
            exit
        end
        i inc
    end
    "    mov    rax, 0x2000001 ; exit\n" F fwrite
    "    mov    rdi, 0\n" F fwrite
    "    syscall\n" F fwrite
end


# ------------------
# ------ main ------
# ------------------

"" -> program

block main do
    # read program from file
    "main.tsp" fopen -> ProgramF
    ProgramF fread -> program
    ProgramF fclose

    program lexer_init

    lexer

    parse

    lexer_tokens asm_gen

    F fclose # close file
    
    free

    # check for unhandled data
    if stack_size 0 > do
        "Error: unhandled <int> type element on the stack." println
        exit
    end
end

main

