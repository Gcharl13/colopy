; ============================================================================
; func_015166_unknown
; Region   : load_image
; Bytes    : file 0x015166..0x0151B1  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015166  55                    PUSH   bp ; STACK_PUSH
015167  8B EC                 MOV    bp, sp ; MOV
015169  56                    PUSH   si ; STACK_PUSH
01516A  57                    PUSH   di ; STACK_PUSH
01516B  06                    PUSH   es ; STACK_PUSH
01516C  1E                    PUSH   ds ; STACK_PUSH
01516D  2E C5 36 52 39        LDS    si, ptr cs:[0x3952] ; MOV_FAR
015172  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
015175  26 89 35              MOV    word ptr es:[di], si ; MOV
015178  83 C7 02              ADD    di, 2 ; ARITH
01517B  0B F6                 OR     si, si ; LOGIC
01517D  74 0B                 JE     0x1518a ; CJUMP
01517F  51                    PUSH   cx ; STACK_PUSH
015180  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
015183  2B F1                 SUB    si, cx ; ARITH
015185  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
015187  59                    POP    cx ; STACK_POP
015188  EB 4D                 JMP    0x151d7 ; JUMP
01518A  2E 8B 36 5C 39        MOV    si, word ptr cs:[0x395c] ; GLOBAL_LOAD
01518F  26 89 75 06           MOV    word ptr es:[di + 6], si ; MOV
015193  2E 8B 36 58 39        MOV    si, word ptr cs:[0x3958] ; GLOBAL_LOAD
015198  26 89 75 04           MOV    word ptr es:[di + 4], si ; MOV
01519C  EB 39                 JMP    0x151d7 ; JUMP
01519E  2E 80 26 DE 39 FB     AND    byte ptr cs:[0x39de], 0xfb ; LOGIC
0151A4  9A 41 13 0D 11        LCALL  0x110d, 0x1341 ; LCALL
0151A9  EA DE 1C 0D 11        LJMP   0x110d:0x1cde                ; UNKNOWN
0151AE  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
