SOURCE_DIR := ./src
BUILD_DIR  := ./build

SOURCE_FILES := $(wildcard $(SOURCE_DIR)/*.asm)
BUILD_FILES  := $(patsubst $(SOURCE_DIR)/%.asm, $(BUILD_DIR)/%.o, $(SOURCE_FILES))

# $^ – the names of all the prerequisites, with spaces between them
# $@ – the filename of the target of the rule
# $< – the name of the first prerequisite

all: forthuno

forthuno: $(BUILD_FILES)
	ld -o forthuno $^

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 -g -F dwarf -o $@ $<

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
	rm -f forthuno $(BUILD_DIR)
