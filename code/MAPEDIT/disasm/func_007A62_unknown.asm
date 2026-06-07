; ============================================================================
; func_007A62_unknown
; Region   : load_image
; Bytes    : file 0x007A62..0x007A7A  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007A62  55                    PUSH   bp ; STACK_PUSH
007A63  8B EC                 MOV    bp, sp ; MOV
007A65  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
007A68  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
007A6B  A3 9E 05              MOV    word ptr [0x59e], ax ; GLOBAL_LOAD
007A6E  89 16 A0 05           MOV    word ptr [0x5a0], dx ; GLOBAL_LOAD
007A72  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
007A75  A3 A2 05              MOV    word ptr [0x5a2], ax ; GLOBAL_LOAD
007A78  C9                    LEAVE ; EPILOGUE
007A79  CB                    RETF ; RETURN
