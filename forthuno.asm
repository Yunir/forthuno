%include 'io_lib.inc'
%include 'macro.inc'
%include 'util.inc'
%include 'dict.inc'

global _start

_start:
  jmp init_impl

interpreter_loop:
  dq docol_impl

  dq xt_inbuf
  dq xt_word                ; read the word
  branchif0 .exit           ; word read error or empty string

  dq xt_inbuf
  dq find
  branchif0 .number

  dq cfa                   ; rax - execution address
  dq ps

  .number:
    dq numlen
    branchif0 warning
    branch interpreter_loop

  .exit:
    dq xt_bye

warning:
  dq drop
	dq warn
