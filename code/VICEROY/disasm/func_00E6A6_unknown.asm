; ============================================================================
; func_00E6A6_unknown
; Region   : load_image
; Bytes    : file 0x00E6A6..0x00E6EE  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E6A6  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00E6AA  50                    PUSH   ax ; STACK_PUSH
00E6AB  57                    PUSH   di ; STACK_PUSH
00E6AC  56                    PUSH   si ; STACK_PUSH
00E6AD  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
00E6B0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00E6B5  80 3C 00              CMP    byte ptr [si], 0 ; CMP
00E6B8  74 26                 JE     0xe6e0 ; CJUMP
00E6BA  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
00E6BD  8A 04                 MOV    al, byte ptr [si] ; MOV
00E6BF  98                    CWDE ; ARITH
00E6C0  8B F8                 MOV    di, ax ; MOV
00E6C2  4F                    DEC    di ; ARITH
00E6C3  46                    INC    si ; ARITH
00E6C4  03 7E 0A              ADD    di, word ptr [bp + 0xa] ; ARITH
00E6C7  26 8A 4D 02           MOV    cl, byte ptr es:[di + 2] ; MOV
00E6CB  2A ED                 SUB    ch, ch ; ARITH
00E6CD  0B C9                 OR     cx, cx ; LOGIC
00E6CF  7E 07                 JLE    0xe6d8 ; CJUMP
00E6D1  38 2C                 CMP    byte ptr [si], ch ; CMP
00E6D3  74 03                 JE     0xe6d8 ; CJUMP
00E6D5  03 4E FC              ADD    cx, word ptr [bp - 4] ; ARITH
00E6D8  01 4E FE              ADD    word ptr [bp - 2], cx ; ARITH
00E6DB  80 3C 00              CMP    byte ptr [si], 0 ; CMP
00E6DE  75 DD                 JNE    0xe6bd ; CJUMP
00E6E0  B8 5A 1B              MOV    ax, 0x1b5a ; CONST_LOAD
00E6E3  8E D8                 MOV    ds, ax ; MOV
00E6E5  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00E6E8  5E                    POP    si ; STACK_POP
00E6E9  5F                    POP    di ; STACK_POP
00E6EA  C9                    LEAVE ; EPILOGUE
00E6EB  CA 08 00              RETF   8 ; RETURN
