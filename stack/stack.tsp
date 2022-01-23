
block stack do
    {} -> stack
    0 -> stack_length
end

block op_push do
    stack swap append -> stack
    stack_length inc -> stack_length
end

block op_drop do
    stack stack_length dec remove -> stack
    stack_length dec -> stack_length
end

