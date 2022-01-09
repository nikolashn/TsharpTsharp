import "parser.tsp"
import "lexer.tsp"

block Help do
    "documentation: https://github.com/Tsharp-lang/Tsharp/blob/main/DOC/docs.md" print
end

block Main do
    "T# interpreter" print
    "Type 'help' for more information, 'exit' to quit." print
    for true do
        ">>> " puts input -> PROGRAM
        if PROGRAM "help" == do
            call Help
        else
            call Lexer
            call ParserInit
            call Parser
        end
    end
end

call Main

