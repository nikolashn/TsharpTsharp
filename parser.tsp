import "stack.tsp"

block ParserInit do
    0 -> ParserIndex
    Tokens ParserIndex read
    swap drop
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
    drop
end

block parser_parse_string do
    if parser_current_token_value "exit" == do
        TOKEN_ID call ParserEat
        exit
    elif parser_current_token_value "print" == do
        call op_print
        TOKEN_ID call ParserEat
    elif parser_current_token_value "swap" == do
        call op_swap
        TOKEN_ID call ParserEat
    elif parser_current_token_value "drop" == do
        call op_drop
        TOKEN_ID call ParserEat
    elif parser_current_token_value "over" == do
        call op_over
        TOKEN_ID call ParserEat
    elif parser_current_token_value "dup" == do
        call op_dup
        TOKEN_ID call ParserEat
    elif parser_current_token_value "printS" == do
        call op_print_s
        TOKEN_ID call ParserEat
    else
        "Syntax Error: unexpected token value '" parser_current_token_value + "'" + print
        exit
    end
end

block Parser do
    for true do
        if parser_current_token_type TOKEN_STRING == do
            parser_current_token_value call op_push
            TOKEN_STRING call ParserEat
        elif parser_current_token_type TOKEN_ID == do
            call parser_parse_string
        elif parser_current_token_type TOKEN_PLUS == do
            "Error: parsing `+` are not implemented." print
            TOKEN_PLUS call ParserEat
        elif parser_current_token_type TOKEN_MINUS == do
            "Error: parsing `-` are not implemented." print
            TOKEN_MINUS call ParserEat
        elif parser_current_token_type TOKEN_MUL == do
            "Error: parsing `*` are not implemented." print
            TOKEN_MUL call ParserEat
        elif parser_current_token_type TOKEN_DIV == do
            "Error: parsing `/` are not implemented." print
            TOKEN_DIV call ParserEat
        elif parser_current_token_type TOKEN_EOF == do
            break
        else
            "Syntax Error: unexpected token value '" parser_current_token_value + "'" + print
            exit
        end
    end
end

block ParserEat do
    if parser_current_token_type != do
        "Syntax Error: unexpected token value '" parser_current_token_value + "'" + print
        exit
    end
    ParserIndex inc -> ParserIndex

    Tokens ParserIndex read
    swap drop
    0 read -> parser_current_token_type
    1 read -> parser_current_token_value
    drop
end

