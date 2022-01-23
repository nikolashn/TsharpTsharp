import "lexer.tsp"
import "parser.tsp"

block main do
    for true do
        ">>> " puts input -> program
        if program "help" == do
            call Help
        else
            program
            call lexer_init
            call lexer
            call parser_init
            call parser
        end
    end
end

call main

