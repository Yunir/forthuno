%include 'src/io_lib.inc'
%include 'src/macro.inc'
%include 'src/util.inc'
%include 'src/dict.inc'

global _start

section .data
  last_word: dq link
  dp: dq user_mem
  in_fd: dq 0

section .text
_start:
  xor eax, eax
  push rax            ; stdin
  jmp init_impl

run:
  dq docol_impl

  main_loop:
    dq xt_buffer
    dq xt_read               ; read the word
    branchif0 exit           ; word read error or empty string
    dq xt_buffer
    dq xt_find               ; addr or 0

    ; dq xt_printnl

    dq xt_pushmode
    branchif0 .interpreter_mode

  .compiler_mode:
    ;dq xt_comp_m
    dq xt_dup                 ; copy address
    branchif0 .compiler_number

    dq xt_cfa                 ; xt_address

    ; Check command's flag. Immediate commands must be interpreted.
    dq xt_isimmediate
    branchif0 .notImmediate

    .immediate:
      dq xt_initcmd
      branch main_loop

    .notImmediate:
      dq xt_isbranch
      dq xt_comma
      branch main_loop

    .compiler_number:
      dq xt_drop
      dq xt_buffer
      dq xt_parsei

      branchif0 .warning
      dq xt_wasbranch
      branchif0 .lit

      dq xt_unsetbranch
      dq xt_savenum
      branch main_loop

  	  .lit:
  		dq xt_lit, xt_lit
      dq xt_comma
      dq xt_comma


      branch main_loop


  .interpreter_mode:
    ;dq xt_inte_m
    dq xt_dup
    branchif0 .interpreter_number

    dq xt_cfa                 ; rax - execution address
    dq xt_initcmd
    branch main_loop

    .interpreter_number:
      dq xt_drop
      dq xt_buffer
      dq xt_parsei
      branchif0 .warning
      branch main_loop

  .warning:
    dq xt_drop
  	dq xt_warn
    branch main_loop

exit:
  dq xt_bye
