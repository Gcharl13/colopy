; ============================================================================
; func_00F450_unknown
; Region   : load_image
; Bytes    : file 0x00F450..0x00F47C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F450  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
00F454  50                    PUSH   ax ; STACK_PUSH
00F455  57                    PUSH   di ; STACK_PUSH
00F456  56                    PUSH   si ; STACK_PUSH
00F457  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
00F45C  1E                    PUSH   ds ; STACK_PUSH
00F45D  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00F460  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
00F463  8B DE                 MOV    bx, si ; MOV
00F465  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
00F468  4A                    DEC    dx ; ARITH
00F469  3B F2                 CMP    si, dx ; CMP
00F46B  7C 03                 JL     0xf470 ; CJUMP
00F46D  E9 98 00              JMP    0xf508 ; JUMP
00F470  26 8A 41 01           MOV    al, byte ptr es:[bx + di + 1] ; MOV
00F474  26 3A 01              CMP    al, byte ptr es:[bx + di] ; CMP
00F477  72 09                 JB     0xf482 ; CJUMP
00F479  46                    INC    si ; ARITH
00F47A  83                    DB     0x83 ; DATA_BYTE
00F47B  C3                    DB     0xC3 ; DATA_BYTE
