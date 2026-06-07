; ============================================================================
; func_06C220_unknown
; Region   : overlay
; Bytes    : file 0x06C220..0x06C23B  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C220  55                    PUSH   bp ; STACK_PUSH
06C221  8B EC                 MOV    bp, sp ; MOV
06C223  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
06C226  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C229  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06C22C  C1 E0 06              SHL    ax, 6 ; LOGIC
06C22F  05 D2 9C              ADD    ax, 0x9cd2 ; ARITH
06C232  1E                    PUSH   ds ; STACK_PUSH
06C233  50                    PUSH   ax ; STACK_PUSH
06C234  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
06C239  C9                    LEAVE ; EPILOGUE
06C23A  CB                    RETF ; RETURN
