; ============================================================================
; func_004E0A_unknown
; Region   : load_image
; Bytes    : file 0x004E0A..0x004E23  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004E0A  55                    PUSH   bp ; STACK_PUSH
004E0B  8B EC                 MOV    bp, sp ; MOV
004E0D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
004E10  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
004E13  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004E16  C1 E3 02              SHL    bx, 2 ; LOGIC
004E19  89 87 8A 69           MOV    word ptr [bx + 0x698a], ax ; MOV
004E1D  89 97 8C 69           MOV    word ptr [bx + 0x698c], dx ; MOV
004E21  C9                    LEAVE ; EPILOGUE
004E22  CB                    RETF ; RETURN
