all: forthuno

forthuno: forthuno.o
	ld -o forthuno forthuno.o

forthuno.o: forthuno.asm
	nasm -f elf64 -g -F dwarf forthuno.asm -o forthuno.o

clean:
	rm -f forthuno *.o

rebuild: clean forthuno

debug: forthuno
	gdb forthuno -f .gdbinit

run: forthuno
	./forthuno

# build and debug
bd: clean debug

# build and run
br: clean run
