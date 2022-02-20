# Torth Programming language

It's like Forth, Porth but written in T#.


## Usage
```python
# file main.tsp

10 20 + print

10 10 == if
    100 print
end

```


```
$ ./main torth.tsp

$ nasm -f macho64 torth.asm

$ ld torth.o -o torth -macosx_version_min 11.4 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

$ ./torth
```

```
# for loop
0 for dup 100 < do  
    dup print
    1 +
end
```

## Todo
> _Some of these are in progress and not marked as checked_
- [X] Implement integers
- [X] Implement conditions
- [X] Implement if statements
- [X] Implement for-loops
- [X] Implement addition (arithmetic)
- [X] Implement subtraction (arithmetic)
- [X] Implement comments
- [X] Implement multiplication (arithmetic)
- [ ] Implement macors
- [ ] Implement variable assignments
- [ ] Implement function(block) definitions
- [ ] Implement function calls
- [ ] Implement division (arithmetic)
- [ ] Implement main method
- [ ] Implement arrays

## Contributing
Welcome! 💕

