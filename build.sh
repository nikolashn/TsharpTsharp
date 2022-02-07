
tsp tsharp.tsp

/usr/local/Cellar/nasm/2.15.05/bin/nasm -f macho64 tsharp.asm && ld tsharp.o -o tsharp -macosx_version_min 11.4 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem -no_pie

