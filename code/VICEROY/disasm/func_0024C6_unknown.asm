; ============================================================================
; func_0024C6_unknown
; Region   : load_image
; Bytes    : file 0x0024C6..0x002544  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0024C6  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0024CA  80 3E 4A 00 00        CMP    byte ptr [0x4a], 0 ; CMP
0024CF  74 6C                 JE     0x253d ; CJUMP
0024D1  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
0024D6  75 65                 JNE    0x253d ; CJUMP
0024D8  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
0024DD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0024E0  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0024E3  05 1E 00              ADD    ax, 0x1e ; ARITH
0024E6  83 D2 00              ADC    dx, 0 ; ARITH
0024E9  3B 16 A6 2D           CMP    dx, word ptr [0x2da6] ; CMP
0024ED  7C 0F                 JL     0x24fe ; CJUMP
0024EF  7F 06                 JG     0x24f7 ; CJUMP
0024F1  3B 06 A4 2D           CMP    ax, word ptr [0x2da4] ; CMP
0024F5  76 07                 JBE    0x24fe ; CJUMP
0024F7  8B 16 A6 2D           MOV    dx, word ptr [0x2da6] ; GLOBAL_LOAD
0024FB  A1 A4 2D              MOV    ax, word ptr [0x2da4] ; GLOBAL_LOAD
0024FE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
002501  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
002504  9A 02 00 E7 0A        LCALL  0xae7, 2 ; LCALL
002509  0B C0                 OR     ax, ax ; LOGIC
00250B  75 19                 JNE    0x2526 ; CJUMP
00250D  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
002510  50                    PUSH   ax ; STACK_PUSH
002511  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
002514  50                    PUSH   ax ; STACK_PUSH
002515  9A 8B 03 58 0A        LCALL  0xa58, 0x38b ; LCALL
00251A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00251D  0B C0                 OR     ax, ax ; LOGIC
00251F  75 05                 JNE    0x2526 ; CJUMP
002521  BA 01 00              MOV    dx, 1 ; MOV
002524  EB 02                 JMP    0x2528 ; JUMP
002526  2B D2                 SUB    dx, dx ; ARITH
002528  0B D2                 OR     dx, dx ; LOGIC
00252A  74 11                 JE     0x253d ; CJUMP
00252C  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
002531  3B 56 FE              CMP    dx, word ptr [bp - 2] ; CMP
002534  7C CE                 JL     0x2504 ; CJUMP
002536  7F 05                 JG     0x253d ; CJUMP
002538  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
00253B  72 C7                 JB     0x2504 ; CJUMP
00253D  9A DA 00 62 02        LCALL  0x262, 0xda ; LCALL
002542  C9                    LEAVE ; EPILOGUE
002543  CB                    RETF ; RETURN
