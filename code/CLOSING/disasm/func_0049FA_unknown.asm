; ============================================================================
; func_0049FA_unknown
; Region   : load_image
; Bytes    : file 0x0049FA..0x004A79  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0049FA  55                    PUSH   bp ; STACK_PUSH
0049FB  8B EC                 MOV    bp, sp ; MOV
0049FD  56                    PUSH   si ; STACK_PUSH
0049FE  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
004A01  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
004A05  74 0C                 JE     0x4a13 ; CJUMP
004A07  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2 ; CMP
004A0B  7F 06                 JG     0x4a13 ; CJUMP
004A0D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
004A11  7D 09                 JGE    0x4a1c ; CJUMP
004A13  C7 06 4A 40 16 00     MOV    word ptr [0x404a], 0x16 ; GLOBAL_LOAD
004A19  EB 52                 JMP    0x4a6d ; JUMP
004A1B  90                    NOP ; NOP
004A1C  80 64 06 EF           AND    byte ptr [si + 6], 0xef ; LOGIC
004A20  83 7E 0C 01           CMP    word ptr [bp + 0xc], 1 ; CMP
004A24  75 14                 JNE    0x4a3a ; CJUMP
004A26  56                    PUSH   si ; STACK_PUSH
004A27  9A 1E 1C 7D 03        LCALL  0x37d, 0x1c1e ; LCALL
004A2C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004A2F  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
004A32  11 56 0A              ADC    word ptr [bp + 0xa], dx ; ARITH
004A35  C7 46 0C 00 00        MOV    word ptr [bp + 0xc], 0 ; LOCAL_STORE
004A3A  56                    PUSH   si ; STACK_PUSH
004A3B  9A 36 14 7D 03        LCALL  0x37d, 0x1436 ; LCALL
004A40  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004A43  F6 44 06 80           TEST   byte ptr [si + 6], 0x80 ; LOGIC
004A47  74 04                 JE     0x4a4d ; CJUMP
004A49  80 64 06 FC           AND    byte ptr [si + 6], 0xfc ; LOGIC
004A4D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
004A50  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
004A53  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004A56  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
004A59  2A E4                 SUB    ah, ah ; ARITH
004A5B  50                    PUSH   ax ; STACK_PUSH
004A5C  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
004A61  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004A64  3D FF FF              CMP    ax, 0xffff ; CMP
004A67  75 09                 JNE    0x4a72 ; CJUMP
004A69  3B D0                 CMP    dx, ax ; CMP
004A6B  75 05                 JNE    0x4a72 ; CJUMP
004A6D  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
004A70  EB 02                 JMP    0x4a74 ; JUMP
004A72  2B C0                 SUB    ax, ax ; ARITH
004A74  5E                    POP    si ; STACK_POP
004A75  8B E5                 MOV    sp, bp ; MOV
004A77  5D                    POP    bp ; STACK_POP
004A78  CB                    RETF ; RETURN
