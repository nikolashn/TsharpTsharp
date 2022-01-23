import "tokens/tokens.tsp"


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
            call lexer_advance
        elif lexer_char "'" == do
            call lexer_advance
            "" -> lexer_string
            for true do
                program lexer_index read -> lexer_char
                if lexer_char "'" == do
                    call lexer_advance
                    break
                end
                lexer_string lexer_char + -> lexer_string
                call lexer_advance
            end
            lexer_tokens { TOKEN_STRING lexer_string } append -> lexer_tokens
        elif lexer_char "+" == do
            lexer_tokens { TOKEN_PLUS "+" } append -> lexer_tokens
            call lexer_advance
        elif lexer_char "-" == do
            call lexer_advance
            program lexer_index read -> lexer_peak
            if lexer_peak ">" == do
                call lexer_advance
                lexer_tokens { TOKEN_EQUALS "->" } append -> lexer_tokens
            else
                lexer_tokens { TOKEN_MINUS "-" } append -> lexer_tokens
            end
        elif lexer_char "*" == do
            lexer_tokens { TOKEN_MUL "*" } append -> lexer_tokens
            call lexer_advance
        elif lexer_char "/" == do
            lexer_tokens { TOKEN_DIV "/" } append -> lexer_tokens
            call lexer_advance
        elif lexer_char "%" == do
            lexer_tokens { TOKEN_REM "%" } append -> lexer_tokens
            call lexer_advance
        else
            "" -> lexer_id
            lexer_id lexer_char + -> lexer_id
            call lexer_advance
            for true do
                if lexer_index program_length == do
                    break
                end
                program lexer_index read -> lexer_char
                if lexer_char " " == do
                    break
                end
                lexer_id lexer_char + -> lexer_id
                call lexer_advance
            end
            lexer_tokens { TOKEN_ID lexer_id } append -> lexer_tokens
        end
    end
end

