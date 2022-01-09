import "token.tsp"

block LexerInit do
    PROGRAM len -> Length drop
    0 -> Index
    [] -> Tokens
end

block LexerAdvance do
    Index inc -> Index
end

block Lexer do
    call LexerInit
    for true do
        if Index Length == do
            [] TOKEN_EOF append "TOKEN_EOF" append -> EOFArr
            Tokens EOFArr append -> Tokens
            break
        end
        PROGRAM Index read -> char drop
        if char " " == do
            call LexerAdvance
        elif char "'" == do
            "" -> STRINGValue
            call LexerAdvance
            for true do
                PROGRAM Index read -> char drop
                if char "'" == do
                    call LexerAdvance
                    break
                end
                STRINGValue char + -> STRINGValue
                call LexerAdvance
            end
            [] TOKEN_STRING append STRINGValue append -> STRINGArr
            Tokens STRINGArr append -> Tokens
        elif char "+" == do
            [] TOKEN_PLUS append "+" append -> PLUSArr
            Tokens PLUSArr append -> Tokens
            call LexerAdvance
        elif char "-" == do
            [] TOKEN_MINUS append "-" append -> MINUSArr
            Tokens MINUSArr append -> Tokens
            call LexerAdvance
        elif char "*" == do
            [] TOKEN_MUL append "*" append -> MULArr
            Tokens MULArr append -> Tokens
            call LexerAdvance
        elif char "/" == do
            [] TOKEN_DIV append "/" append -> DIVArr
            Tokens DIVArr append -> Tokens
            call LexerAdvance
        else
            "" -> IDValue
            IDValue char + -> IDValue
            call LexerAdvance
            for true do
                if Index Length == do
                    break
                end
                PROGRAM Index read -> char drop
                if char " " == do
                    break
                end
                IDValue char + -> IDValue
                call LexerAdvance
            end
            [] TOKEN_ID append IDValue append -> IDArr
            Tokens IDArr append -> Tokens
        end
    end
end

