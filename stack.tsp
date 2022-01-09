
[] -> stack
0 -> stack_len

block op_push do
    stack_len 1 + -> stack_len
    stack swap append -> stack
end

block op_print do
    if stack_len 0 == do
        "Error: the stack is empty." print
    else
        stack len 1 - read print drop
        call op_drop
    end
end

block op_drop do
    if stack_len 0 == do
        "Error: the stack is empty." print
    else
        stack_len 1 - -> stack_len
        stack len 1 - remove -> stack
    end
end

block op_swap do
    if stack_len 2 < do
        "Error: `swap` expected more than 2 elements in stack." print
    else
        stack len 1 - read -> first
        len 2 - read       -> second
        call op_drop
        call op_drop
        drop
        first call op_push
        second call op_push
    end
end

block op_dup do
    if stack_len 1 < do
        "Error: `dup` expected more than 1 element in stack." print
    else
        stack len 1 - read -> first
        drop
        first call op_push
    end
end

block op_over do
    if stack_len 2 < do
        "Error: `over` expected more than 2 elements in stack." print
    else
        stack len 2 - read -> second
        drop
        second call op_push
    end
end

block op_print_s do
    "<" puts stack_len puts "> " puts
    0 for dup stack_len < do
        dup 1 + -> index
        stack index 1 - read puts drop
        inc
        " " puts
    end
    "← top" print
end

