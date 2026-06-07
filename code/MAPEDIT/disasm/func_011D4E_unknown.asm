; ============================================================================
; func_011D4E_unknown
; Region   : load_image
; Bytes    : file 0x011D4E..0x011D6B  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D4E  55                    PUSH   bp ; STACK_PUSH
011D4F  8B EC                 MOV    bp, sp ; MOV
011D51  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
011D54  0B 46 06              OR     ax, word ptr [bp + 6] ; LOGIC
011D57  74 10                 JE     0x11d69 ; CJUMP
011D59  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
011D5C  89 1E 10 44           MOV    word ptr [0x4410], bx ; GLOBAL_LOAD
011D60  FF 5E 04              LCALL  [bp + 4] ; LCALL
011D63  C7 06 10 44 00 00     MOV    word ptr [0x4410], 0 ; GLOBAL_LOAD
011D69  C9                    LEAVE ; EPILOGUE
011D6A  C3                    RET ; RETURN
