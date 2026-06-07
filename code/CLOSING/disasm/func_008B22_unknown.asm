; ============================================================================
; func_008B22_unknown
; Region   : load_image
; Bytes    : file 0x008B22..0x008B39  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008B22  55                    PUSH   bp ; STACK_PUSH
008B23  8B EC                 MOV    bp, sp ; MOV
008B25  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
008B28  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
008B2B  8B D8                 MOV    bx, ax ; MOV
008B2D  C1 EB 04              SHR    bx, 4 ; LOGIC
008B30  03 D3                 ADD    dx, bx ; ARITH
008B32  25 0F 00              AND    ax, 0xf ; LOGIC
008B35  C9                    LEAVE ; EPILOGUE
008B36  CA 04 00              RETF   4 ; RETURN
