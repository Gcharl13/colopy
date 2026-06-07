; ============================================================================
; func_030550_unknown
; Region   : overlay
; Bytes    : file 0x030550..0x030565  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030550  55                    PUSH   bp ; STACK_PUSH
030551  8B EC                 MOV    bp, sp ; MOV
030553  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
030556  A3 12 9E              MOV    word ptr [0x9e12], ax ; GLOBAL_LOAD
030559  69 C0 3C 01           IMUL   ax, ax, 0x13c ; ARITH
03055D  05 08 88              ADD    ax, 0x8808 ; ARITH
030560  A3 FC 84              MOV    word ptr [0x84fc], ax ; GLOBAL_LOAD
030563  C9                    LEAVE ; EPILOGUE
030564  CB                    RETF ; RETURN
