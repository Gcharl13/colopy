; ============================================================================
; func_0050BC_unknown
; Region   : load_image
; Bytes    : file 0x0050BC..0x0050EF  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0050BC  55                    PUSH   bp ; STACK_PUSH
0050BD  8B EC                 MOV    bp, sp ; MOV
0050BF  A1 96 00              MOV    ax, word ptr [0x96] ; GLOBAL_LOAD
0050C2  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
0050C5  74 26                 JE     0x50ed ; CJUMP
0050C7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0050CA  A3 94 00              MOV    word ptr [0x94], ax ; GLOBAL_LOAD
0050CD  83 3E A0 00 00        CMP    word ptr [0xa0], 0 ; CMP
0050D2  74 0D                 JE     0x50e1 ; CJUMP
0050D4  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
0050D9  75 06                 JNE    0x50e1 ; CJUMP
0050DB  C7 06 9E 00 01 00     MOV    word ptr [0x9e], 1 ; GLOBAL_LOAD
0050E1  0B C0                 OR     ax, ax ; LOGIC
0050E3  7C 08                 JL     0x50ed ; CJUMP
0050E5  B8 01 00              MOV    ax, 1 ; MOV
0050E8  9A 0E 00 D8 02        LCALL  0x2d8, 0xe ; LCALL
0050ED  C9                    LEAVE ; EPILOGUE
0050EE  CB                    RETF ; RETURN
