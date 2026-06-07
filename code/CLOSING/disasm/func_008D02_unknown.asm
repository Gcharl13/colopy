; ============================================================================
; func_008D02_unknown
; Region   : load_image
; Bytes    : file 0x008D02..0x008D1F  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008D02  55                    PUSH   bp ; STACK_PUSH
008D03  8B EC                 MOV    bp, sp ; MOV
008D05  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
008D08  0B 46 06              OR     ax, word ptr [bp + 6] ; LOGIC
008D0B  74 10                 JE     0x8d1d ; CJUMP
008D0D  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
008D10  89 1E F2 3E           MOV    word ptr [0x3ef2], bx ; GLOBAL_LOAD
008D14  FF 5E 04              LCALL  [bp + 4] ; LCALL
008D17  C7 06 F2 3E 00 00     MOV    word ptr [0x3ef2], 0 ; GLOBAL_LOAD
008D1D  C9                    LEAVE ; EPILOGUE
008D1E  C3                    RET ; RETURN
