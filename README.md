## Forthuno
### The forth dialect with Indirect Threaded Code (ITC) to dive into practice

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
| buf | (  -- buf_addr ) | load the predefined buffer address |
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
| & | ( b a -- [b&a] ) | bitwise and |
| &#124; (pipe) | ( b a -- [b&#124;a] ) | bitwise or |
| not | ( a -- !a ) | transform any number to 0 or if it 0 to 1 |
| rot | ( c b a -- b a c ) | move third value to the top of stack with shift |
| key | (  -- c ) | read a single character from stdin |
| emit | ( c --  ) | output a single character to stdout |
| ! | ( a addr --  ) | store value by address |
| @ | ( addr -- a ) | fetch value from address |
| find | ( addr -- addr' ) | find word in dictionary |
| cfa | ( addr -- xt_addr ) | jump pointer to execution_point place |
| initcmd | ( xt_addr --  ) | initialize command by address |
|  |  |  |
| To | Be | Continued... |

###### Additional words not for general using

##### Colon words
