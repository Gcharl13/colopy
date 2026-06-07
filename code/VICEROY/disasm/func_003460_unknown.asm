; ============================================================================
; func_003460_unknown
; Region   : load_image
; Bytes    : file 0x003460..0x0034C3  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003460  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
003464  57                    PUSH   di ; STACK_PUSH
003465  56                    PUSH   si ; STACK_PUSH
003466  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
003469  0E                    PUSH   cs ; STACK_PUSH
00346A  E8 C9 FF              CALL   0x3436 ; CALL_NEAR
00346D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
003470  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
003473  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
003476  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
003479  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
00347C  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
003481  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
003484  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
003487  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
00348A  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00348D  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
003490  2D 10 00              SUB    ax, 0x10 ; ARITH
003493  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
003496  8A 66 0A              MOV    ah, byte ptr [bp + 0xa] ; LOCAL_LOAD
003499  2A C0                 SUB    al, al ; ARITH
00349B  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
00349E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0034A1  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0034A4  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
0034A7  1E                    PUSH   ds ; STACK_PUSH
0034A8  C4 7E FC              LES    di, ptr [bp - 4] ; MOV_FAR
0034AB  C5 76 F4              LDS    si, ptr [bp - 0xc] ; MOV_FAR
0034AE  BB 10 00              MOV    bx, 0x10 ; CONST_LOAD
0034B1  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
0034B4  B9 10 00              MOV    cx, 0x10 ; CONST_LOAD
0034B7  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0034B9  03 FA                 ADD    di, dx ; ARITH
0034BB  4B                    DEC    bx ; ARITH
0034BC  75 F6                 JNE    0x34b4 ; CJUMP
0034BE  1F                    POP    ds ; STACK_POP
0034BF  5E                    POP    si ; STACK_POP
0034C0  5F                    POP    di ; STACK_POP
0034C1  C9                    LEAVE ; EPILOGUE
0034C2  CB                    RETF ; RETURN
