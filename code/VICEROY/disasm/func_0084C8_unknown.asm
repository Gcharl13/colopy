; ============================================================================
; func_0084C8_unknown
; Region   : load_image
; Bytes    : file 0x0084C8..0x0084DB  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0084C8  55                    PUSH   bp ; STACK_PUSH
0084C9  8B EC                 MOV    bp, sp ; MOV
0084CB  83 7E 06 1C           CMP    word ptr [bp + 6], 0x1c ; CMP
0084CF  75 05                 JNE    0x84d6 ; CJUMP
0084D1  C7 46 06 13 00        MOV    word ptr [bp + 6], 0x13 ; LOCAL_STORE
0084D6  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0084D9  C9                    LEAVE ; EPILOGUE
0084DA  CB                    RETF ; RETURN
