; ============================================================================
; func_06C27C_unknown
; Region   : overlay
; Bytes    : file 0x06C27C..0x06C295  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C27C  55                    PUSH   bp ; STACK_PUSH
06C27D  8B EC                 MOV    bp, sp ; MOV
06C27F  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06C282  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
06C285  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06C288  C1 E3 02              SHL    bx, 2 ; LOGIC
06C28B  89 87 B0 9C           MOV    word ptr [bx - 0x6350], ax ; MOV
06C28F  89 97 B2 9C           MOV    word ptr [bx - 0x634e], dx ; MOV
06C293  C9                    LEAVE ; EPILOGUE
06C294  CB                    RETF ; RETURN
