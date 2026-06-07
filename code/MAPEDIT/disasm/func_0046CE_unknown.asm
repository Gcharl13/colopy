; ============================================================================
; func_0046CE_unknown
; Region   : load_image
; Bytes    : file 0x0046CE..0x0046E7  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0046CE  55                    PUSH   bp ; STACK_PUSH
0046CF  8B EC                 MOV    bp, sp ; MOV
0046D1  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
0046D5  74 06                 JE     0x46dd ; CJUMP
0046D7  83 7E 06 09           CMP    word ptr [bp + 6], 9 ; CMP
0046DB  75 0B                 JNE    0x46e8 ; CJUMP
0046DD  C7 46 06 08 00        MOV    word ptr [bp + 6], 8 ; LOCAL_STORE
0046E2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0046E5  C9                    LEAVE ; EPILOGUE
0046E6  CB                    RETF ; RETURN
