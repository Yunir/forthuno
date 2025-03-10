all: forthuno

forthuno: forthuno.o
	ld -o forthuno forthuno.o

forthuno.o: forthuno.asm
	nasm -f elf64 -g -F dwarf forthuno.asm -o forthuno.o

rebuild: clean forthuno

debug: forthuno
	gdb forthuno -f .gdbinit

run: forthuno
	./forthuno

tests: test1 test2 test3 test4 test5 test6 test7 test8

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

test8: forthuno
	./forthuno <tests/test08.frt

stdlib: forthuno
	./forthuno <libs/stdlib.frt

mp: forthuno
	./forthuno <mp.frt

# build and debug
bd: clean debug

# build and run
br: clean run

clean:
	rm -f forthuno *.o
