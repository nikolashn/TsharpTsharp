
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
        "Error: `swap` expected more than 2 elementes in stack." print
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