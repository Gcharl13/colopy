; ============================================================================
; func_0034C4_unknown
; Region   : load_image
; Bytes    : file 0x0034C4..0x003536  (114 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0034C4  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
0034C8  57                    PUSH   di ; STACK_PUSH
0034C9  56                    PUSH   si ; STACK_PUSH
0034CA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0034CD  0E                    PUSH   cs ; STACK_PUSH
0034CE  E8 65 FF              CALL   0x3436 ; CALL_NEAR
0034D1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0034D4  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
0034D7  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
0034DA  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
0034DD  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
0034E0  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
0034E5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0034E8  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0034EB  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
0034EE  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
0034F1  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0034F4  2D 10 00              SUB    ax, 0x10 ; ARITH
0034F7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0034FA  8A 66 0A              MOV    ah, byte ptr [bp + 0xa] ; LOCAL_LOAD
0034FD  2A C0                 SUB    al, al ; ARITH
0034FF  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
003502  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
003505  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
003508  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
00350B  1E                    PUSH   ds ; STACK_PUSH
00350C  C4 7E FC              LES    di, ptr [bp - 4] ; MOV_FAR
00350F  C5 76 F4              LDS    si, ptr [bp - 0xc] ; MOV_FAR
003512  BB 10 00              MOV    bx, 0x10 ; CONST_LOAD
003515  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
003518  B9 10 00              MOV    cx, 0x10 ; CONST_LOAD
00351B  26 8A 05              MOV    al, byte ptr es:[di] ; MOV
00351E  0A C0                 OR     al, al ; LOGIC
003520  75 06                 JNE    0x3528 ; CJUMP
003522  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
003523  E2 F6                 LOOP   0x351b ; CJUMP
003525  EB 05                 JMP    0x352c ; JUMP
003527  90                    NOP ; NOP
003528  47                    INC    di ; ARITH
003529  46                    INC    si ; ARITH
00352A  E2 EF                 LOOP   0x351b ; CJUMP
00352C  03 FA                 ADD    di, dx ; ARITH
00352E  4B                    DEC    bx ; ARITH
00352F  75 E7                 JNE    0x3518 ; CJUMP
003531  1F                    POP    ds ; STACK_POP
003532  5E                    POP    si ; STACK_POP
003533  5F                    POP    di ; STACK_POP
003534  C9                    LEAVE ; EPILOGUE
003535  CB                    RETF ; RETURN
