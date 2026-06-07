; ============================================================================
; func_00B1EC_unknown
; Region   : load_image
; Bytes    : file 0x00B1EC..0x00B216  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B1EC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00B1F0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00B1F5  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00B1F9  8A 07                 MOV    al, byte ptr [bx] ; MOV
00B1FB  2A E4                 SUB    ah, ah ; ARITH
00B1FD  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
00B200  2A F6                 SUB    dh, dh ; ARITH
00B202  9A 5C 00 27 04        LCALL  0x427, 0x5c ; LCALL
00B207  EB 29                 JMP    0xb232 ; JUMP
00B209  90                    NOP ; NOP
00B20A  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
00B20E  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
00B212  2A FF                 SUB    bh, bh ; ARITH
00B214  8B C3                 MOV    ax, bx ; MOV
