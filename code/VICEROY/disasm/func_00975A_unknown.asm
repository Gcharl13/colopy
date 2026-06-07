; ============================================================================
; func_00975A_unknown
; Region   : load_image
; Bytes    : file 0x00975A..0x009773  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00975A  55                    PUSH   bp ; STACK_PUSH
00975B  8B EC                 MOV    bp, sp ; MOV
00975D  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
009761  7C 1E                 JL     0x9781 ; CJUMP
009763  EB 09                 JMP    0x976e ; JUMP
009765  90                    NOP ; NOP
009766  8A 87 85 8F           MOV    al, byte ptr [bx - 0x707b] ; MOV
00976A  98                    CWDE ; ARITH
00976B  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
00976E  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
009771  8B C3                 MOV    ax, bx ; MOV
