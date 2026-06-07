; ============================================================================
; func_004DAE_unknown
; Region   : load_image
; Bytes    : file 0x004DAE..0x004DC9  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004DAE  55                    PUSH   bp ; STACK_PUSH
004DAF  8B EC                 MOV    bp, sp ; MOV
004DB1  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
004DB4  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004DB7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004DBA  C1 E0 06              SHL    ax, 6 ; LOGIC
004DBD  05 4E 63              ADD    ax, 0x634e ; ARITH
004DC0  1E                    PUSH   ds ; STACK_PUSH
004DC1  50                    PUSH   ax ; STACK_PUSH
004DC2  9A EC 0D 88 13        LCALL  0x1388, 0xdec ; LCALL
004DC7  C9                    LEAVE ; EPILOGUE
004DC8  CB                    RETF ; RETURN
