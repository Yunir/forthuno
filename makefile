all: forthuno

forthuno: forthuno.o
	ld -o forthuno forthuno.o

forthuno.o: forthuno.asm
	nasm -f elf64 -g -F dwarf forthuno.asm -o forthuno.o

clean:
	rm -f forthuno *.o

# debugging: gdb forthuno -f .gdbinit
