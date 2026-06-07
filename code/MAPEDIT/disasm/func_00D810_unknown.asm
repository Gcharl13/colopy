; ============================================================================
; func_00D810_unknown
; Region   : load_image
; Bytes    : file 0x00D810..0x00D833  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D810  55                    PUSH   bp ; STACK_PUSH
00D811  8B EC                 MOV    bp, sp ; MOV
00D813  8B 0E 24 07           MOV    cx, word ptr [0x724] ; GLOBAL_LOAD
00D817  3B C1                 CMP    ax, cx ; CMP
00D819  7F 19                 JG     0xd834 ; CJUMP
00D81B  3B D9                 CMP    bx, cx ; CMP
00D81D  7C 15                 JL     0xd834 ; CJUMP
00D81F  8B 1E 26 07           MOV    bx, word ptr [0x726] ; GLOBAL_LOAD
00D823  3B D3                 CMP    dx, bx ; CMP
00D825  7F 0D                 JG     0xd834 ; CJUMP
00D827  39 5E 06              CMP    word ptr [bp + 6], bx ; CMP
00D82A  7C 08                 JL     0xd834 ; CJUMP
00D82C  B8 01 00              MOV    ax, 1 ; MOV
00D82F  C9                    LEAVE ; EPILOGUE
00D830  CA 02 00              RETF   2 ; RETURN
