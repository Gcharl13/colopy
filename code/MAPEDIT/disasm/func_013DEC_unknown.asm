; ============================================================================
; func_013DEC_unknown
; Region   : load_image
; Bytes    : file 0x013DEC..0x013E0C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013DEC  55                    PUSH   bp ; STACK_PUSH
013DED  8B EC                 MOV    bp, sp ; MOV
013DEF  A1 68 3C              MOV    ax, word ptr [0x3c68] ; GLOBAL_LOAD
013DF2  0B C0                 OR     ax, ax ; LOGIC
013DF4  74 1C                 JE     0x13e12 ; CJUMP
013DF6  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
013DF8  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
013DFB  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
013DFF  0A C0                 OR     al, al ; LOGIC
013E01  75 0F                 JNE    0x13e12 ; CJUMP
013E03  80 FB B0              CMP    bl, 0xb0 ; CMP
013E06  75 0A                 JNE    0x13e12 ; CJUMP
013E08  8B C2                 MOV    ax, dx ; MOV
013E0A  C1                    DB     0xC1 ; DATA_BYTE
013E0B  E0                    DB     0xE0 ; DATA_BYTE
