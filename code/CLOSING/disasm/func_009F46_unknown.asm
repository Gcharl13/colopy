; ============================================================================
; func_009F46_unknown
; Region   : load_image
; Bytes    : file 0x009F46..0x009F65  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009F46  55                    PUSH   bp ; STACK_PUSH
009F47  8B EC                 MOV    bp, sp ; MOV
009F49  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
009F4C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
009F4F  A3 94 3F              MOV    word ptr [0x3f94], ax ; GLOBAL_LOAD
009F52  89 16 96 3F           MOV    word ptr [0x3f96], dx ; GLOBAL_LOAD
009F56  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
009F59  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
009F5C  A3 98 3F              MOV    word ptr [0x3f98], ax ; GLOBAL_LOAD
009F5F  89 16 9A 3F           MOV    word ptr [0x3f9a], dx ; GLOBAL_LOAD
009F63  C9                    LEAVE ; EPILOGUE
009F64  CB                    RETF ; RETURN
