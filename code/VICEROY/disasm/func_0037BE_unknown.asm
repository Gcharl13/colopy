; ============================================================================
; func_0037BE_unknown
; Region   : load_image
; Bytes    : file 0x0037BE..0x00380C  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0037BE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0037C2  53                    PUSH   bx ; STACK_PUSH
0037C3  50                    PUSH   ax ; STACK_PUSH
0037C4  57                    PUSH   di ; STACK_PUSH
0037C5  56                    PUSH   si ; STACK_PUSH
0037C6  0B D2                 OR     dx, dx ; LOGIC
0037C8  74 30                 JE     0x37fa ; CJUMP
0037CA  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
0037CD  9A 02 00 27 04        LCALL  0x427, 2 ; LCALL
0037D2  8B F0                 MOV    si, ax ; MOV
0037D4  0B F6                 OR     si, si ; LOGIC
0037D6  7C 1E                 JL     0x37f6 ; CJUMP
0037D8  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0037DB  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
0037DF  3C 0D                 CMP    al, 0xd ; CMP
0037E1  72 06                 JB     0x37e9 ; CJUMP
0037E3  3C 12                 CMP    al, 0x12 ; CMP
0037E5  77 02                 JA     0x37e9 ; CJUMP
0037E7  8B FE                 MOV    di, si ; MOV
0037E9  8B C6                 MOV    ax, si ; MOV
0037EB  9A 4A 00 27 04        LCALL  0x427, 0x4a ; LCALL
0037F0  8B F0                 MOV    si, ax ; MOV
0037F2  0B FF                 OR     di, di ; LOGIC
0037F4  7C DE                 JL     0x37d4 ; CJUMP
0037F6  0B FF                 OR     di, di ; LOGIC
0037F8  7D 03                 JGE    0x37fd ; CJUMP
0037FA  8B 7E FA              MOV    di, word ptr [bp - 6] ; LOCAL_LOAD
0037FD  8B C7                 MOV    ax, di ; MOV
0037FF  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
003802  89 07                 MOV    word ptr [bx], ax ; MOV
003804  0E                    PUSH   cs ; STACK_PUSH
003805  E8 08 FF              CALL   0x3710 ; CALL_NEAR
003808  5E                    POP    si ; STACK_POP
003809  5F                    POP    di ; STACK_POP
00380A  C9                    LEAVE ; EPILOGUE
00380B  CB                    RETF ; RETURN
