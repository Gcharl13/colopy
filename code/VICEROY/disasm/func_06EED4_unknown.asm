; ============================================================================
; func_06EED4_unknown
; Region   : overlay
; Bytes    : file 0x06EED4..0x06EEEC  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06EED4  55                    PUSH   bp ; STACK_PUSH
06EED5  8B EC                 MOV    bp, sp ; MOV
06EED7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06EEDA  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
06EEDD  A3 9E 1F              MOV    word ptr [0x1f9e], ax ; GLOBAL_LOAD
06EEE0  89 16 A0 1F           MOV    word ptr [0x1fa0], dx ; GLOBAL_LOAD
06EEE4  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06EEE7  A3 A2 1F              MOV    word ptr [0x1fa2], ax ; GLOBAL_LOAD
06EEEA  C9                    LEAVE ; EPILOGUE
06EEEB  CB                    RETF ; RETURN
