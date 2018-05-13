; (  -- buf_addr )
; load the predefined buffer address
native 'buffer', buffer
  push qword input_buf
  jmp next

; ( buf_addr -- len )
; read word to buffer
native 'read', read
  pop rdi
  call read_word
  push rdx
  jmp next

; ( a --  )
; drop the topmost element from the stack
native 'drop', drop
  add rsp, 8
  jmp next

; ( addr --  )
; print string
native 'prints', prints
  pop rdi
  call print_string
  jmp next

; print new line
native 'printnl', printnl
  call print_newline
  jmp next

; ( num --  )
; print integer number
native 'printi', printi
  pop rdi
  call print_int
  jmp next

; ( arg2_addr arg1_addr -- answer )
; check strings to equality
native 'compare', compare
  pop rdi
  pop rsi
  call string_equals
  push rax
  jmp next

; (  -- num len )
native 'parsei', parsei
  call parse_int          ; rax - number ; rdx - length of number
  push rax                ; save number to stack
  push rdx
  jmp next

; ( user_word_addr -- dict_word_addr )
; Find word in dictionary
native 'find', find
  pop rdi                ; rdi - user's word
  call find_word
  push rax
  jmp next

; ( addr -- xt_addr )
; jump pointer to execution_point place
native 'cfa', cfa
  pop rdi
	call call_from_address
  push rax
  jmp next

; ( xt_addr -- xt_addr answer )
native 'isimmediate', isimmediate
  pop rax
  push rax
  xor rdx, rdx
  mov dl, byte[rax - 1]
  push rdx
  jmp next

; ( xt_addr -- xt_addr )
native 'setbranch', setbranch
  pop rax
  push rax
  cmp byte[rax - 1], 2
  jne .continue
  mov byte[was_branch], 1
  .continue:
  jmp next

native 'pushlit', pushlit
  push xt_lit
  jmp next

; (  --  )
native 'unsetbranch', unsetbranch
  mov byte[was_branch], 0
  jmp next

; ( xt_addr --  )
native 'save', save
  pop rax
  mov  qword[here], rax
  add  here, word_size
  jmp next

; ( xt_addr --  )
native 'savenum', savenum
  pop rax
  mov  [here], rax
  add  here, word_size
  jmp next

; (  -- answer )
native 'wasbranch', wasbranch
  xor rdx, rdx
  mov dl, byte[was_branch]
  push rdx
  jmp next

; Pushes a value immediately following this XT
native 'lit', lit
  push qword [pc]
  add pc, 8
  jmp next

; ( answer --  )
; Jump to a location if answer is 0
native 'branchifz', branchifz
  pop rax
  test rax, rax
  jnz .skip
  mov pc, [pc]
  jmp next
  .skip:
    add pc, 8
    jmp next

; (  --  )
; Jump to a location
native 'branch', branch
  mov pc, [pc]
  jmp next

; Saves PC when the colon word starts
native 'docol', docol
  sub rstack, 8
  mov [rstack], pc
  add w, 8
  mov pc, w
  jmp next

; Returns from the colon word
native 'exit', exit
  mov pc, [rstack]
  add rstack, 8
  jmp next

; Exits program
native 'bye', bye
  mov rax, 60
  xor rdi, rdi
  syscall

; ( xt_addr --  )
native 'initcmd', initcmd
  pop rax
  push pc
  mov [program_stub], rax
  mov pc, program_stub
  mov w, [pc]
  pop pc
  jmp [w]

native 'warn', warn
  mov  rdi, warning_message
  call print_string
  call print_newline
  mov  pc, xt_loop
  jmp next

native 'comp_m', comp_m
  mov  rdi, cmode_message
  call print_string
  call print_newline
  mov  pc, xt_loop
  jmp next

native 'inte_m', inte_m
  mov  rdi, imode_message
  call print_string
  call print_newline
  mov  pc, xt_loop
  jmp next

native 'pushmode', pushmode
  xor eax, eax
  mov rax, [mode]
  push rax
  jmp next

; ( a -- a a )
native 'dup', dup
  push qword [rsp]
  jmp next

; ( b a -- [a < b] )
native '<', less
  pop rdx
  pop rax
  cmp rax, rdx
  setl al
  movzx rax, al
  push rax
  jmp next

; ( a b -- b a )
; Swap two cells on top of the stack
native 'swap', swap
    pop rax
    pop rdx
    push rax
    push rdx
    jmp next

; Shows all stack contents. Does not pop elements
native '.S', show_stack
  mov rcx, rsp
  .loop:
    cmp rcx, [stack_start]
    jae next
    mov rdi, [rcx]
    push rcx
    call print_int
    call print_newline
    pop rcx
    add rcx, 8
    jmp .loop

; ( b a -- [ b + a ] )
native '+', plus
  pop rdx
  pop rax
  add rax, rdx
  push rax
  jmp next

; ( b a -- [ b - a ] )
native '-', minus
  pop rdx
  pop rax
  sub rax, rdx
  push rax
  jmp next

; ( b a -- [ b * a ] )
native '*', mul
  pop rdx
  pop rax
  imul rdx
  push rax
  jmp next

; ( y x -- [ x / y ] )
native '/', div
  pop rax
  pop rcx
  cqo
  idiv rcx
  push rax
  jmp next

; ( b a -- [ b = a ] )
native '=', equals
  pop rdx
  pop rax
  cmp rax, rdx
  jne .nequals
  xor rax, rax
  mov rax, 1
  push rax
  jmp next
.nequals:
  xor rax, rax
  jmp next

; ( b a -- b & a )
; bitwise and
native 'and', and
  pop rdx
  pop rax
  and rax, rdx
  push rax
  jmp next

; ( a -- !a )
native 'not', not
  pop rax
  test rax, rax
  jz .setone
  xor rax, rax
  push rax
  jmp next
  .setone:
    xor rax, rax
    mov rax, 1
    push rax
    jmp next

; ( a b c -- b c a )
native 'rot', rot
  pop rax
  pop rdx
  pop rcx
  push rdx
  push rcx
  push rax
  jmp next

; Drops element from stack and sends it to stdout
; ( a -- )
native '.', dot
  pop rdi
  call print_int
  jmp next

; ( -- c )
; Read a single character
native 'key', key
  call read_char
  push rax
  jmp next

; ( c -- )
; Outputs a single character to stdout
native 'emit', emit
  pop rdi
  call print_char
  jmp next

; ( val addr -- )
; Store value by address
native '!', write
  pop rax
  pop rdx
  mov [rax], rdx
  jmp next

; ( addr -- value )
; Fetch value from memory
native '@', fetch
  pop rax
  push qword[rax]
  jmp next

; bitwise or
; ( y x -- y | x )
native 'or', or
  pop rax
  or [rsp], rax
  jmp next

; ( x -- )
; Add x to the word being defined
native ',', comma
  mov rax, [here]
  pop qword [rax]
  add qword [here], 8
  jmp next

; ( flags name --  )
; Create an entry in the dictionary
; name is the new name as a null-terminated string
; only immediate flag is implemented ATM
native 'create', create
  ; link
  mov rcx, [last_word]
  mov rsi, [here]
  mov [rsi], rcx
  mov [last_word], rsi
  add rsi, 8
  mov byte [rsi], 0
  inc rsi

  ; name
  pop rdi
  push rsi
  call string_copy
  pop rsi
  push rsi
  mov rdi, rsi
  call string_length
  pop rsi
  add rsi, rax
  ; flags
  inc rsi
  pop rax
  mov [rsi], al
  inc rsi

  mov [here], rsi
  jmp next

; Initializes registers
native 'init', init
  mov rstack, rstack_start
  mov stack, stack_start
  mov qword[mode], 0
  mov pc, xt_run
  jmp next


; ( a -- [ a + a ] )
colon 'double', double
  dq xt_dup                 ; The words consisting `dup` start here.
  dq xt_plus
  dq xt_exit

colon '>', greater
  dq xt_swap
  dq xt_less
  dq exit

; Read word from stdin and start defining it
colon ':', colon
  .restart:
  dq xt_buffer
  dq xt_read
  branchif0 .restart
  dq xt_lit, 0, xt_buffer, xt_create
  dq xt_lit, 1
  ;dq xt_state, xt_write
  dq xt_lit, docol_impl, xt_comma
  dq xt_exit

colon ';', semicolon, 1
  dq xt_lit, 0
  ;dq xt_state
  dq xt_write
  dq xt_lit, xt_exit
  dq xt_comma
  dq xt_exit

; Read word and place its address on stack
; ( -- a )
colon "'", tick, 1
  dq xt_buffer
  dq xt_read
  dq xt_drop
  dq xt_buffer
  dq xt_find, xt_dup
  branchif0 .no_such_word
  dq xt_cfa
  ;dq xt_state, xt_fetch
  branchif0 .interpret
  dq xt_lit, xt_lit
  dq xt_comma
  dq xt_comma
  .interpret:
    dq xt_exit
    .no_such_word:
      dq xt_warn
      dq xt_exit
