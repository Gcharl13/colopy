; ============================================================================
; func_0059BE_unknown
; Region   : load_image
; Bytes    : file 0x0059BE..0x005A3D  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0059BE  55                    PUSH   bp ; STACK_PUSH
0059BF  8B EC                 MOV    bp, sp ; MOV
0059C1  56                    PUSH   si ; STACK_PUSH
0059C2  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0059C5  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0059C9  74 0C                 JE     0x59d7 ; CJUMP
0059CB  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2 ; CMP
0059CF  7F 06                 JG     0x59d7 ; CJUMP
0059D1  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
0059D5  7D 09                 JGE    0x59e0 ; CJUMP
0059D7  C7 06 A0 42 16 00     MOV    word ptr [0x42a0], 0x16 ; GLOBAL_LOAD
0059DD  EB 52                 JMP    0x5a31 ; JUMP
0059DF  90                    NOP ; NOP
0059E0  80 64 06 EF           AND    byte ptr [si + 6], 0xef ; LOGIC
0059E4  83 7E 0C 01           CMP    word ptr [bp + 0xc], 1 ; CMP
0059E8  75 14                 JNE    0x59fe ; CJUMP
0059EA  56                    PUSH   si ; STACK_PUSH
0059EB  9A CE 1C 52 04        LCALL  0x452, 0x1cce ; LCALL
0059F0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0059F3  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
0059F6  11 56 0A              ADC    word ptr [bp + 0xa], dx ; ARITH
0059F9  C7 46 0C 00 00        MOV    word ptr [bp + 0xc], 0 ; LOCAL_STORE
0059FE  56                    PUSH   si ; STACK_PUSH
0059FF  9A E6 14 52 04        LCALL  0x452, 0x14e6 ; LCALL
005A04  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005A07  F6 44 06 80           TEST   byte ptr [si + 6], 0x80 ; LOGIC
005A0B  74 04                 JE     0x5a11 ; CJUMP
005A0D  80 64 06 FC           AND    byte ptr [si + 6], 0xfc ; LOGIC
005A11  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
005A14  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
005A17  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005A1A  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
005A1D  2A E4                 SUB    ah, ah ; ARITH
005A1F  50                    PUSH   ax ; STACK_PUSH
005A20  9A EA 1A 52 04        LCALL  0x452, 0x1aea ; LCALL
005A25  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005A28  3D FF FF              CMP    ax, 0xffff ; CMP
005A2B  75 09                 JNE    0x5a36 ; CJUMP
005A2D  3B D0                 CMP    dx, ax ; CMP
005A2F  75 05                 JNE    0x5a36 ; CJUMP
005A31  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
005A34  EB 02                 JMP    0x5a38 ; JUMP
005A36  2B C0                 SUB    ax, ax ; ARITH
005A38  5E                    POP    si ; STACK_POP
005A39  8B E5                 MOV    sp, bp ; MOV
005A3B  5D                    POP    bp ; STACK_POP
005A3C  CB                    RETF ; RETURN
