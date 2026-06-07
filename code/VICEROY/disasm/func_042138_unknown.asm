; ============================================================================
; func_042138_unknown
; Region   : overlay
; Bytes    : file 0x042138..0x042200  (200 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042138  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
04213C  56                    PUSH   si ; STACK_PUSH
04213D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
042140  D1 E3                 SHL    bx, 1 ; LOGIC
042142  C7 87 1C 94 00 00     MOV    word ptr [bx - 0x6be4], 0 ; MOV
042148  2A C0                 SUB    al, al ; ARITH
04214A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04214D  88 87 FC 8C           MOV    byte ptr [bx - 0x7304], al ; MOV
042151  88 87 98 92           MOV    byte ptr [bx - 0x6d68], al ; MOV
042155  88 87 08 94           MOV    byte ptr [bx - 0x6bf8], al ; MOV
042159  88 87 0C 94           MOV    byte ptr [bx - 0x6bf4], al ; MOV
04215D  88 87 10 94           MOV    byte ptr [bx - 0x6bf0], al ; MOV
042161  88 87 80 91           MOV    byte ptr [bx - 0x6e80], al ; MOV
042165  88 87 14 94           MOV    byte ptr [bx - 0x6bec], al ; MOV
042169  88 87 18 94           MOV    byte ptr [bx - 0x6be8], al ; MOV
04216D  88 87 24 94           MOV    byte ptr [bx - 0x6bdc], al ; MOV
042171  88 87 2C 94           MOV    byte ptr [bx - 0x6bd4], al ; MOV
042175  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
04217A  6B 76 06 13           IMUL   si, word ptr [bp + 6], 0x13 ; ARITH
04217E  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
042181  C6 80 4C 92 00        MOV    byte ptr [bx + si - 0x6db4], 0 ; MOV
042186  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
042189  83 7E EE 13           CMP    word ptr [bp - 0x12], 0x13 ; CMP
04218D  7C EB                 JL     0x4217a ; CJUMP
04218F  2A C0                 SUB    al, al ; ARITH
042191  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
042194  88 87 56 94           MOV    byte ptr [bx - 0x6baa], al ; MOV
042198  88 87 5A 94           MOV    byte ptr [bx - 0x6ba6], al ; MOV
04219C  2B C0                 SUB    ax, ax ; ARITH
04219E  D1 E3                 SHL    bx, 1 ; LOGIC
0421A0  89 87 4E 94           MOV    word ptr [bx - 0x6bb2], ax ; MOV
0421A4  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
0421A7  EB 2D                 JMP    0x421d6 ; JUMP
0421A9  90                    NOP ; NOP
0421AA  2A C0                 SUB    al, al ; ARITH
0421AC  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
0421AF  88 87 F2 95           MOV    byte ptr [bx - 0x6a0e], al ; MOV
0421B3  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
0421B6  C1 E1 04              SHL    cx, 4 ; LOGIC
0421B9  03 D9                 ADD    bx, cx ; ARITH
0421BB  88 87 A6 94           MOV    byte ptr [bx - 0x6b5a], al ; MOV
0421BF  88 87 E6 94           MOV    byte ptr [bx - 0x6b1a], al ; MOV
0421C3  88 87 26 95           MOV    byte ptr [bx - 0x6ada], al ; MOV
0421C7  88 87 8C 91           MOV    byte ptr [bx - 0x6e74], al ; MOV
0421CB  88 87 72 95           MOV    byte ptr [bx - 0x6a8e], al ; MOV
0421CF  88 87 B2 95           MOV    byte ptr [bx - 0x6a4e], al ; MOV
0421D3  FF 46 EE              INC    word ptr [bp - 0x12] ; ARITH
0421D6  83 7E EE 10           CMP    word ptr [bp - 0x12], 0x10 ; CMP
0421DA  7C CE                 JL     0x421aa ; CJUMP
0421DC  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0 ; LOCAL_STORE
0421E1  E9 F1 01              JMP    0x423d5 ; JUMP
0421E4  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
0421E8  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0421EC  2A 46 06              SUB    al, byte ptr [bp + 6] ; ARITH
0421EF  3C EC                 CMP    al, 0xec ; CMP
0421F1  75 07                 JNE    0x421fa ; CJUMP
0421F3  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0421F6  FE 87 5A 94           INC    byte ptr [bx - 0x6ba6] ; ARITH
0421FA  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
0421FE  8B C3                 MOV    ax, bx ; MOV
