; ============================================================================
; func_00BC80_unknown
; Region   : load_image
; Bytes    : file 0x00BC80..0x00BCA9  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BC80  55                    PUSH   bp ; STACK_PUSH
00BC81  8B EC                 MOV    bp, sp ; MOV
00BC83  FF 36 66 03           PUSH   word ptr [0x366] ; PUSH_GLOBAL
00BC87  FF 36 64 03           PUSH   word ptr [0x364] ; PUSH_GLOBAL
00BC8B  FF 36 62 03           PUSH   word ptr [0x362] ; PUSH_GLOBAL
00BC8F  FF 36 60 03           PUSH   word ptr [0x360] ; PUSH_GLOBAL
00BC93  6A 01                 PUSH   1 ; STACK_PUSH
00BC95  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
00BC98  50                    PUSH   ax ; STACK_PUSH
00BC99  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BC9C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00BC9F  BB 01 00              MOV    bx, 1 ; MOV
00BCA2  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
00BCA7  C9                    LEAVE ; EPILOGUE
00BCA8  CB                    RETF ; RETURN
