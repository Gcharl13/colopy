; ============================================================================
; func_00AE7C_unknown
; Region   : load_image
; Bytes    : file 0x00AE7C..0x00AE9B  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AE7C  55                    PUSH   bp ; STACK_PUSH
00AE7D  8B EC                 MOV    bp, sp ; MOV
00AE7F  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00AE82  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00AE85  A3 EA 41              MOV    word ptr [0x41ea], ax ; GLOBAL_LOAD
00AE88  89 16 EC 41           MOV    word ptr [0x41ec], dx ; GLOBAL_LOAD
00AE8C  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00AE8F  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00AE92  A3 EE 41              MOV    word ptr [0x41ee], ax ; GLOBAL_LOAD
00AE95  89 16 F0 41           MOV    word ptr [0x41f0], dx ; GLOBAL_LOAD
00AE99  C9                    LEAVE ; EPILOGUE
00AE9A  CB                    RETF ; RETURN
