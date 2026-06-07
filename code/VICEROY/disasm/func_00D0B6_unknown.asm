; ============================================================================
; func_00D0B6_unknown
; Region   : load_image
; Bytes    : file 0x00D0B6..0x00D0D9  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D0B6  55                    PUSH   bp ; STACK_PUSH
00D0B7  8B EC                 MOV    bp, sp ; MOV
00D0B9  8B 0E E8 07           MOV    cx, word ptr [0x7e8] ; GLOBAL_LOAD
00D0BD  3B C1                 CMP    ax, cx ; CMP
00D0BF  7F 19                 JG     0xd0da ; CJUMP
00D0C1  3B D9                 CMP    bx, cx ; CMP
00D0C3  7C 15                 JL     0xd0da ; CJUMP
00D0C5  8B 1E EA 07           MOV    bx, word ptr [0x7ea] ; GLOBAL_LOAD
00D0C9  3B D3                 CMP    dx, bx ; CMP
00D0CB  7F 0D                 JG     0xd0da ; CJUMP
00D0CD  39 5E 06              CMP    word ptr [bp + 6], bx ; CMP
00D0D0  7C 08                 JL     0xd0da ; CJUMP
00D0D2  B8 01 00              MOV    ax, 1 ; MOV
00D0D5  C9                    LEAVE ; EPILOGUE
00D0D6  CA 02 00              RETF   2 ; RETURN
