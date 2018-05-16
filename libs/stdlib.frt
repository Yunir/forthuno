: IMMEDIATE push_lastword @ cfa 1 - dup c@ 1 or swap c! ;

: rot >r swap r> swap ;
: -rot swap >r swap  r> ;
: over >r dup r> swap ;
: 2dup over over ;
1 2 3 rot .S printnl -rot .S drop drop drop printnl
1 2 over .S drop drop drop printnl
1 2 2dup .S drop drop drop drop printnl printnl

: <> = not ;
: <= 2dup < -rot = lor ;
: > <= not ;
: >= < not ;
5 1 <> . printnl
8 8 <= . printnl
5 9 > . printnl
16 16 >= . printnl printnl

: cell% 8 ;
: cells cell% * ;
: KB 1024 * ;
: MB KB KB  ;
2 MB . printnl printnl

: allot dp @ swap over + dp ! ;

: begin here ; IMMEDIATE
: again ' branch , , ; IMMEDIATE

: if ' branchifz , here 0  , ; IMMEDIATE
: else ' branch , here 0 , swap here swap !  ; IMMEDIATE
: then here swap ! ; IMMEDIATE
: endif ' then initcmd ; IMMEDIATE

: abs dup 0 < if -1 * then ;
5 abs . printnl
-3 abs . printnl
-199 abs . printnl printnl

: repeat here ; IMMEDIATE
: until  ' branchifz , , ; IMMEDIATE

: odd 2 % abs ;
: sqr dup * ;
: prime
dup 1 > if
  dup 2 = not if
    dup odd if
    1
      repeat
      2 +
      2dup 2dup sqr >=
      -rot % land not
      until
    sqr <
    else drop 0 then
  else drop 1 then
else drop 0 then ;
2 prime . printnl
11 prime . printnl
191 prime . printnl
201 prime . printnl printnl

: for
      ' swap ,
      ' >r ,
      ' >r ,
here  ' r> ,
      ' r> ,
      ' 2dup ,
      ' >r ,
      ' >r ,
      ' < ,
      ' branchifz ,
here    0 ,
       swap ; IMMEDIATE


: endfor
      ' r> ,
      ' lit , 1 ,
        ' + ,
       ' >r ,
   ' branch ,
            ,  here swap !
       ' r> ,
     ' drop ,
       ' r> ,
     ' drop ,

;  IMMEDIATE

: do  ' swap , ' >r , ' >r ,  here ; IMMEDIATE

: loop
        ' r> ,
        ' lit , 1 ,
        ' + ,
        ' dup ,
        ' r@ ,
        ' < ,
        ' not ,
        ' swap ,
        ' >r ,
        ' branchifz , ,
        ' r> ,
        ' drop ,
        ' r> ,
        ' drop ,
 ;  IMMEDIATE

: testfor
   2dup swap . printnl . printnl printnl

  2dup
  for
  r@ . printnl
  endfor

  printnl
  do
  r@ . printnl
  loop
  0 . printnl
;

 999 .S
 1 5 testfor
 5 1 testfor
.S drop printnl

: sys-read-no 0 ;
: sys-write-no 1 ;

: sys-read  >r >r >r sys-read-no r> r> r> 0 0 0 syscall drop ;
: sys-write >r >r >r sys-write-no r> r> r> 0 0 0  syscall drop ;

: readc@ in_fd @ swap 1 sys-read ;
: readc buffer readc@ drop buffer c@ ;

: ( repeat readc 41 - not until ; IMMEDIATE
( Now we can define comments :)

: 2drop drop drop ;
: 2over >r >r dup r> swap r> swap ;
: case 0 ; IMMEDIATE
: of ' over , ' = , ' if initcmd ' drop , ; IMMEDIATE
: endof ' else initcmd ; IMMEDIATE
: endcase ' drop , dup if repeat ' then initcmd dup not until drop then  ; IMMEDIATE

1 2 .S 2drop .S printnl
1 2 3 2over .S 2drop 2drop printnl
: testcase case
1 of 1 . printnl endof
2 of 2 . printnl endof
0 . printnl endcase ;
1 testcase
2 testcase
10 testcase printnl

( num from to -- 1/0)
: in-range rot swap over >= -rot <= land ;
5 -1 5 in-range . printnl

( 1 if we are compiling )
: compiling state @ ;
compiling . printnl

: compnumber compiling if ' lit , , then ;

( -- input character's code )
: .' readc compnumber ; IMMEDIATE
.' \ . printnl

: cr 10 emit ;
: QUOTE 34 ;
