
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
enum -> TOKEN_INT
enum -> TOKEN_ID
enum -> TOKEN_PLUS
enum -> TOKEN_MINUS
enum -> TOKEN_MUL
enum -> TOKEN_DIV
enum -> TOKEN_REM
enum -> TOKEN_EQUALS
enum -> TOKEN_EOF

# ---------------
# ---- lexer ----
# ---------------

0 -> program_length
0 -> lexer_index
{} -> lexer_tokens

block lexer_init do
    len -> program_length
    0 -> lexer_index
    {} -> lexer_tokens
end

block lexer_advance do
    lexer_index inc -> lexer_index
end

block lexer do
    for true do
        if lexer_index program_length == do
            lexer_tokens { TOKEN_EOF "TOKEN_EOF" } append -> lexer_tokens
            break
        end
        program lexer_index read -> lexer_char
        if lexer_char " " == do
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
        elif lexer_char "+" == do
            lexer_tokens { TOKEN_PLUS "+" } append -> lexer_tokens
            lexer_advance
        elif lexer_char "-" == do
            lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak ">" == do
                lexer_advance
                lexer_tokens { TOKEN_EQUALS "->" } append -> lexer_tokens
            else
                lexer_tokens { TOKEN_MINUS "-" } append -> lexer_tokens
            end
        elif lexer_char "*" == do
            lexer_tokens { TOKEN_MUL "*" } append -> lexer_tokens
            lexer_advance
        elif lexer_char "/" == do
            lexer_tokens { TOKEN_DIV "/" } append -> lexer_tokens
            lexer_advance
        elif lexer_char "%" == do
            lexer_tokens { TOKEN_REM "%" } append -> lexer_tokens
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
            lexer_tokens { TOKEN_INT lexer_int } append -> lexer_tokens
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
                end
                lexer_id lexer_char + -> lexer_id
                lexer_advance
            end
            lexer_tokens { TOKEN_ID lexer_id } append -> lexer_tokens
        end
    end
end


# ---------------------------
# ------ generate ASM  ------
# ---------------------------

"main.asm" fopen -> F
0 -> parser_index
0 -> parser_current_token_type
0 -> parser_current_token_value

block init_parser do
    0 -> parser_index
    lexer_tokens parser_index read dup
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
end

block parser_eat do
    if parser_current_token_type != do
        "Syntax Error: unexpected token value '" parser_current_token_value + "'" + println
        exit
    end
    parser_index inc -> parser_index

    lexer_tokens parser_index read dup
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
end

block parser do
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

    for true do
        if parser_current_token_type TOKEN_ID == do
            if parser_current_token_value "print" == do
                "    ; -- print --\n" F fwrite
                "    pop rdi\n" F fwrite
                "    call print\n\n" F fwrite
                TOKEN_ID parser_eat
            end
        elif parser_current_token_type TOKEN_INT == do
            "    ; -- push --\n" F fwrite
            "    push  " F fwrite parser_current_token_value "\n\n" + F fwrite
            TOKEN_INT parser_eat
        elif parser_current_token_type TOKEN_PLUS == do
            "    ; -- plus --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    add    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
            TOKEN_PLUS parser_eat
        elif parser_current_token_type TOKEN_MINUS == do
            "    ; -- subtract --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    sub    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
            TOKEN_MINUS parser_eat
        elif parser_current_token_type TOKEN_MUL == do
            "    ; -- subtract --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    mul    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
            TOKEN_MUL parser_eat
        elif parser_current_token_type TOKEN_DIV == do
            "    ; -- subtract --\n" F fwrite
            "    pop    rax\n" F fwrite
            "    pop    rbx\n" F fwrite
            "    div    rbx, rax\n" F fwrite
            "    push   rbx\n\n" F fwrite
            TOKEN_DIV parser_eat
        elif parser_current_token_type TOKEN_EOF == do
            break
        else
            "Syntax Error: unexpected token value '" parser_current_token_value + "'" + println
            exit
        end
    end
    "    mov    rax, 0x2000001 ; exit\n" F fwrite
    "    mov    rdi, 0\n" F fwrite
    "    syscall\n" F fwrite
end


# ------------------
# ------ main ------
# ------------------

"34 35 + 1 - print" -> program

block main do
    program lexer_init
    lexer
    init_parser
    parser
    F fclose # close file
end

main

