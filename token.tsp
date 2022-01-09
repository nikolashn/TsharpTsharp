
0 -> EnumIndex
block Enum do
    try
        if dup typeof bool == do
            -> BoolValue
            if BoolValue do
                0 -> EnumIndex
                EnumIndex
            else
                EnumIndex
            end
        else
            EnumIndex
        end
    except StackOutRange do
        EnumIndex
    end
    EnumIndex 1 + -> EnumIndex
end

true call Enum -> TOKEN_STRING
call Enum -> TOKEN_ID
call Enum -> TOKEN_EOF
call Enum -> TOKEN_PLUS
call Enum -> TOKEN_MINUS
call Enum -> TOKEN_MUL
call Enum -> TOKEN_DIV

