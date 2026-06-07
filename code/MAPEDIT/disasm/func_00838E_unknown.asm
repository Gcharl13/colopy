; ============================================================================
; func_00838E_unknown
; Region   : load_image
; Bytes    : file 0x00838E..0x0083C2  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00838E  55                    PUSH   bp ; STACK_PUSH
00838F  8B EC                 MOV    bp, sp ; MOV
008391  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008394  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
008397  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
00839A  26 89 07              MOV    word ptr es:[bx], ax ; MOV
00839D  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
0083A0  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
0083A4  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
0083A7  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
0083AB  8B 46 14              MOV    ax, word ptr [bp + 0x14] ; LOCAL_LOAD
0083AE  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
0083B2  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0083B5  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
0083B8  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
0083BC  26 89 57 0A           MOV    word ptr es:[bx + 0xa], dx ; MOV
0083C0  C9                    LEAVE ; EPILOGUE
0083C1  CB                    RETF ; RETURN
