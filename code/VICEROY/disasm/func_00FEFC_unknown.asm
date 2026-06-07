; ============================================================================
; func_00FEFC_unknown
; Region   : load_image
; Bytes    : file 0x00FEFC..0x00FF10  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FEFC  55                    PUSH   bp ; STACK_PUSH
00FEFD  8B EC                 MOV    bp, sp ; MOV
00FEFF  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00FF02  F6 87 ED 27 02        TEST   byte ptr [bx + 0x27ed], 2 ; LOGIC
00FF07  74 05                 JE     0xff0e ; CJUMP
00FF09  8D 47 E0              LEA    ax, [bx - 0x20] ; ADDR
00FF0C  EB 02                 JMP    0xff10 ; JUMP
00FF0E  8B C3                 MOV    ax, bx ; MOV
