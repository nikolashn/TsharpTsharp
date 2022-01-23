
block parser_init do
    0 -> parser_index
    lexer_tokens parser_index read dup
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
end

block parser_eat do
    if parser_current_token_type != do
        "Syntax Error: unexpected token value '" parser_current_token_value + "'" + print
        exit
    end
    parser_index inc -> parser_index

    Tokens parser_index read dup
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
end

block parser do
    for true do
        if parser_current_token_type TOKEN_STRING == do
            false assert "strings is not implemented."
        elif parser_current_token_type TOKEN_ID == do
            false assert "identifier is not implemented."
        elif parser_current_token_type { TOKEN_PLUS TOKEN_MINUS TOKEN_MUL TOKEN_DIV } in == do
            false assert "binary operation is not implemented."
        elif parser_current_token_type TOKEN_EOF == do
            break
        else
            "Syntax Error: unexpected token value '" parser_current_token_value + "'" + print
            exit
        end
    end
end

