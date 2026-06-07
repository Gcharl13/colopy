; ============================================================================
; func_011AF2_unknown
; Region   : load_image
; Bytes    : file 0x011AF2..0x011B09  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011AF2  55                    PUSH   bp ; STACK_PUSH
011AF3  8B EC                 MOV    bp, sp ; MOV
011AF5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
011AF8  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
011AFB  8B D8                 MOV    bx, ax ; MOV
011AFD  C1 EB 04              SHR    bx, 4 ; LOGIC
011B00  03 D3                 ADD    dx, bx ; ARITH
011B02  25 0F 00              AND    ax, 0xf ; LOGIC
011B05  C9                    LEAVE ; EPILOGUE
011B06  CA 04 00              RETF   4 ; RETURN
