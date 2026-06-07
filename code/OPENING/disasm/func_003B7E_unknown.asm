; ============================================================================
; func_003B7E_unknown
; Region   : load_image
; Bytes    : file 0x003B7E..0x003BA2  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003B7E  55                    PUSH   bp ; STACK_PUSH
003B7F  8B EC                 MOV    bp, sp ; MOV
003B81  57                    PUSH   di ; STACK_PUSH
003B82  56                    PUSH   si ; STACK_PUSH
003B83  1E                    PUSH   ds ; STACK_PUSH
003B84  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
003B87  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
003B8A  48                    DEC    ax ; ARITH
003B8B  8E D8                 MOV    ds, ax ; MOV
003B8D  33 F6                 XOR    si, si ; LOGIC
003B8F  B9 08 00              MOV    cx, 8 ; MOV
003B92  AC                    LODSB  al, byte ptr [si] ; STR
003B93  0A C0                 OR     al, al ; LOGIC
003B95  AA                    STOSB  byte ptr es:[di], al ; STR
003B96  E0 FA                 LOOPNE 0x3b92 ; CJUMP
003B98  32 C0                 XOR    al, al ; LOGIC
003B9A  AA                    STOSB  byte ptr es:[di], al ; STR
003B9B  1F                    POP    ds ; STACK_POP
003B9C  5E                    POP    si ; STACK_POP
003B9D  5F                    POP    di ; STACK_POP
003B9E  C9                    LEAVE ; EPILOGUE
003B9F  CA 08 00              RETF   8 ; RETURN
