; ============================================================================
; func_0146BA_unknown
; Region   : load_image
; Bytes    : file 0x0146BA..0x0146D9  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0146BA  55                    PUSH   bp ; STACK_PUSH
0146BB  8B EC                 MOV    bp, sp ; MOV
0146BD  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0146C0  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0146C3  A3 12 45              MOV    word ptr [0x4512], ax ; GLOBAL_LOAD
0146C6  89 16 14 45           MOV    word ptr [0x4514], dx ; GLOBAL_LOAD
0146CA  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0146CD  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
0146D0  A3 16 45              MOV    word ptr [0x4516], ax ; GLOBAL_LOAD
0146D3  89 16 18 45           MOV    word ptr [0x4518], dx ; GLOBAL_LOAD
0146D7  C9                    LEAVE ; EPILOGUE
0146D8  CB                    RETF ; RETURN
