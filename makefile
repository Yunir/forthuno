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

test1: forthuno
	./forthuno <tests/test01.frt

test2: forthuno
	./forthuno <tests/test02.frt

test3: forthuno
	./forthuno <tests/test03.frt

test4: forthuno
	./forthuno <tests/test04.frt

test5: forthuno
	./forthuno <tests/test05.frt

test6: forthuno
	./forthuno <tests/test06.frt

test7: forthuno
	./forthuno <tests/test07.frt

# build and debug
bd: clean debug

# build and run
br: clean run
