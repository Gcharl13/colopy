; ============================================================================
; func_0082B2_unknown
; Region   : load_image
; Bytes    : file 0x0082B2..0x0082D8  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0082B2  55                    PUSH   bp ; STACK_PUSH
0082B3  8B EC                 MOV    bp, sp ; MOV
0082B5  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c ; CMP
0082B9  74 1D                 JE     0x82d8 ; CJUMP
0082BB  83 7E 06 13           CMP    word ptr [bp + 6], 0x13 ; CMP
0082BF  74 17                 JE     0x82d8 ; CJUMP
0082C1  83 7E 06 19           CMP    word ptr [bp + 6], 0x19 ; CMP
0082C5  74 11                 JE     0x82d8 ; CJUMP
0082C7  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a ; CMP
0082CB  74 0B                 JE     0x82d8 ; CJUMP
0082CD  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b ; CMP
0082D1  74 05                 JE     0x82d8 ; CJUMP
0082D3  B8 01 00              MOV    ax, 1 ; MOV
0082D6  C9                    LEAVE ; EPILOGUE
0082D7  CB                    RETF ; RETURN
