; ============================================================================
; func_0078F4_unknown
; Region   : load_image
; Bytes    : file 0x0078F4..0x007936  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0078F4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0078F8  57                    PUSH   di ; STACK_PUSH
0078F9  56                    PUSH   si ; STACK_PUSH
0078FA  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0078FD  2B FF                 SUB    di, di ; ARITH
0078FF  8B C6                 MOV    ax, si ; MOV
007901  0E                    PUSH   cs ; STACK_PUSH
007902  E8 6D ED              CALL   0x6672 ; CALL_NEAR
007905  8B F0                 MOV    si, ax ; MOV
007907  0B F6                 OR     si, si ; LOGIC
007909  7C 25                 JL     0x7930 ; CJUMP
00790B  0B FF                 OR     di, di ; LOGIC
00790D  75 21                 JNE    0x7930 ; CJUMP
00790F  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007912  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
007916  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
007919  3C 0D                 CMP    al, 0xd ; CMP
00791B  72 07                 JB     0x7924 ; CJUMP
00791D  3C 12                 CMP    al, 0x12 ; CMP
00791F  77 03                 JA     0x7924 ; CJUMP
007921  BF 01 00              MOV    di, 1 ; MOV
007924  8B C6                 MOV    ax, si ; MOV
007926  0E                    PUSH   cs ; STACK_PUSH
007927  E8 90 ED              CALL   0x66ba ; CALL_NEAR
00792A  8B F0                 MOV    si, ax ; MOV
00792C  0B F6                 OR     si, si ; LOGIC
00792E  7D DB                 JGE    0x790b ; CJUMP
007930  8B C7                 MOV    ax, di ; MOV
007932  5E                    POP    si ; STACK_POP
007933  5F                    POP    di ; STACK_POP
007934  C9                    LEAVE ; EPILOGUE
007935  CB                    RETF ; RETURN
