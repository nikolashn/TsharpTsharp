
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
    except StackIndexError do
        enum_index
    end
    enum_index 1 + -> enum_index
end

true
call enum -> TOKEN_INT
call enum -> TOKEN_STRING
call enum -> TOKEN_ID
call enum -> TOKEN_PLUS
call enum -> TOKEN_MINUS
call enum -> TOKEN_MUL
call enum -> TOKEN_DIV
call enum -> TOKEN_REM
call enum -> TOKEN_EOF
call enum -> TOKEN_EQUALS

