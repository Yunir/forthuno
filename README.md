## Forthuno
### The forth dialect with Indirect Threaded Code (ITC) to dive into practice

#### 2 modes
1. Interpretation mode
1. Compilation mode

#### Project structure
* forthuno.asm - implemented interpreter and compiler
* dict.inc - dictionary of forth words
* util.inc - some definitions and assembly functions to interact with the dictionary
* macro.inc - macros to ease programming and understanding the code
* io_lib.inc - assembly functions to deal with io

#### Dictionary
##### Native words
| word | stack | definition |
|-|-|-|
| buf | (  -- buf_addr ) | load the predefined buffer address |
| read | ( addr -- len ) | read word to addr |
| drop | ( a --  ) | drop the topmost element from the stack |
| prints | ( addr --  ) | print string |
| printnl | (  --  ) | print new line |
| printi | ( a --  ) | print integer number |
| compare | ( addr2 addr1 -- ans ) | check strings to equality |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
| To | Be | Continued... |

##### Colon words
