## Forthuno
### The forth dialect with Indirect Threaded Code (ITC) to dive into practice

#### How to use
First of all, you may want to understand how this dialect works. In this situation use make instructions to comprehend the idea of each forth word:
> $ make test1 <br>
> $ make test2 <br>
> ... <br>
> $ make test7 <br>
> $ make test8 <br>
> $ make stdlib

#### 2 modes
1. Interpretation mode
1. Compilation mode

#### Project structure
* **forthuno.asm** - implemented interpreter and compiler
* **dict.inc** - dictionary of forth words
* **util.inc** - some definitions and assembly functions to interact with the dictionary
* **macro.inc** - macros to ease programming and understanding the code
* **io_lib.inc** - assembly functions to deal with io

#### Dictionary
##### Native words
| word | stack | definition |
|-|-|-|
| buf | (  -- buf_addr ) | load the predefined forth buffer address |
| read | ( addr -- len ) | read word to addr |
| drop | ( a --  ) | drop last element from the stack |
| prints | ( addr --  ) | print string |
| printnl | **does not affect** | print new line |
| . | ( a --  ) | print integer number |
| compare | ( addr2 addr1 -- ans ) | check strings to equality |
| dup | ( a -- a a ) | duplicate last element of stack |
| + | ( b a -- [b+a] ) | put the result of sum to the stack |
| - | ( b a -- [b-a] ) | put the result of subtraction to the stack |
| * | ( b a -- [b*a] ) | put the result of multiplication to the stack |
| / | ( b a -- [b/a] ) | put the result of division to the stack |
| < | ( b a -- [a<b] ) | compare two numbers in the stack |
| swap | ( b a -- a b ) | swap two cells on top of the stack |
| .S | **does not affect** | print all stack elements |
| = | ( b a -- [b=a] ) | compare two numbers in the stack |
| and | ( b a -- [b&a] ) | bitwise and |
| or | ( b a -- [b&#124;a] ) | bitwise or |
| not | ( a -- !a ) | transform any number to 0 or if it 0 to 1 |
| rot | ( c b a -- b a c ) | move third value to the top of stack with shift |
| key | (  -- c ) | read a single character from stdin |
| emit | ( c --  ) | output a single character to stdout |
| ! | ( a addr --  ) | store value by address |
| @ | ( addr -- a ) | fetch value from address |
| c! | ( val addr -- ) | store value by address |
| c@ | ( addr -- char ) | read one byte starting at addr |
| lor | ( b a -- [b lor a]) | logic or |
| land | ( b a -- [b land a]) | logic and |
| find | ( addr -- addr' ) | find word in dictionary |
| cfa | ( addr -- xt_addr ) | jump pointer to execution_point place |
| initcmd | ( xt_addr --  ) | initialize command by address |
| bye | **does not affect** | terminate the program |
| warn | **does not affect** | print warning message |
| isimmediate | ( xt_addr -- xt_addr ans ) | put to the stack immediate-flag of the word |
| parsei | ( addr -- num len ) | get the integer number from the address |
| pushmode | (  -- mode ) | push mode-flag: 0 - inter. 1 - compil. |
| pushmode_addr | (  -- addr ) | push mode-flag address |

###### Additional words not for general using
| word | stack | definition |
|-|-|-|
| init | **does not affect** | perform general operations to start the interpreter |
| buffer | (  -- addr ) | load the predefined assembly buffer address |
| docol | **does not affect** | save PC when the colon word starts |
| exit | **does not affect** | return from the colon word |
| branchifz | ( ans --  ) | jump to a location if answer is 0 |
| branch | **does not affect** | jump to a location |
| create | ( flag name --  ) | create an entry in the dictionary |
| , | ( a -- ) | add element from stack to the defining word |
| isbranch | **does not affect** | check is word branch by xt_address in the stack |
| unsetbranch | **does not affect** | set the flag was_branch to 0 |
| wasbranch | (  -- answer ) | put was_branch flag state to the stack  |
| pushlit | (  -- xt_addr ) | push xt_addr of lit to the stack |
| lit | **does not affect** | push a value immediately following this XT |
| saveword | ( xt_addr --  ) | add xt_addr of word to defining word |
| savenum | ( xt_addr --  ) | add xt_addr of num to defining word |
| syscall | ( call_num a1 a2 a3 a4 a5 a6 -- new_rax new_rdx ) | execute syscall |

For debugging: comp_m, inte_m

##### Colon words
| word | stack | definition |
|-|-|-|
| double | ( a -- [a+a] ) | multiply by 2 the number in the stack |
| > | ( b a -- [b>a] ) | compare two numbers in the stack |
| : | **does not affect** | read word from stdin and start defining it |
| ; | **does not affect** | finish defining word from stdin |
| ' | ( -- xt_addr ) | read word and place its xt_address on the stack |
