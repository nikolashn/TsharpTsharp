# Programming language

[The T# Programming Language](https://github.com/Tsharp-lang/Tsharp)


## Usage
```python
# file main.tsp

10 20 + print

10 10 == if
    100 print
end

```


```
$ ./main tsharp.tsp

$ nasm -f macho64 tsharp.asm

$ ld tsharp.o -o tsharp -macosx_version_min 11.4 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem

$ ./tsharp
```

## Todo
> _Some of these are in progress and not marked as checked_
- [ ] Implement variable assignments
- [ ] Implement function(block) definitions
- [ ] Implement function calls
- [ ] Implement conditions
- [X] Implement addition (arithmetic)
- [ ] Implement multiplication (arithmetic)
- [X] Implement subtraction (arithmetic)
- [ ] Implement division (arithmetic)
- [ ] Implement while-loops
- [X] Implement if statements
- [ ] Implement for-loops
- [X] Implement integers
- [ ] Implement main method
- [ ] Implement arrays
- [X] Implement comments

## Contributing
Welcome! 💕

