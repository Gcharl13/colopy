; ============================================================================
; func_0119D6_unknown
; Region   : load_image
; Bytes    : file 0x0119D6..0x011A73  (157 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0119D6  55                    PUSH   bp ; STACK_PUSH
0119D7  8B EC                 MOV    bp, sp ; MOV
0119D9  83 EC 02              SUB    sp, 2 ; STACK_ALLOC
0119DC  57                    PUSH   di ; STACK_PUSH
0119DD  56                    PUSH   si ; STACK_PUSH
0119DE  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0119E3  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
0119E7  74 1F                 JE     0x11a08 ; CJUMP
0119E9  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
0119ED  74 13                 JE     0x11a02 ; CJUMP
0119EF  81 7E 0C FF 7F        CMP    word ptr [bp + 0xc], 0x7fff ; CMP
0119F4  77 0C                 JA     0x11a02 ; CJUMP
0119F6  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
0119FA  74 0C                 JE     0x11a08 ; CJUMP
0119FC  83 7E 0A 40           CMP    word ptr [bp + 0xa], 0x40 ; CMP
011A00  74 06                 JE     0x11a08 ; CJUMP
011A02  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
011A05  E9 87 00              JMP    0x11a8f ; JUMP
011A08  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
011A0B  8B FE                 MOV    di, si ; MOV
011A0D  81 EF 0E 29           SUB    di, 0x290e ; ARITH
011A11  81 C7 AE 29           ADD    di, 0x29ae ; ARITH
011A15  56                    PUSH   si ; STACK_PUSH
011A16  9A 96 18 1D 0D        LCALL  0xd1d, 0x1896 ; LCALL
011A1B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011A1E  56                    PUSH   si ; STACK_PUSH
011A1F  E8 7E F2              CALL   0x10ca0 ; CALL_NEAR
011A22  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011A25  F6 46 0A 04           TEST   byte ptr [bp + 0xa], 4 ; LOGIC
011A29  74 15                 JE     0x11a40 ; CJUMP
011A2B  80 4C 06 04           OR     byte ptr [si + 6], 4 ; LOGIC
011A2F  C6 05 00              MOV    byte ptr [di], 0 ; MOV
011A32  8D 45 01              LEA    ax, [di + 1] ; ADDR
011A35  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
011A38  C7 46 0C 01 00        MOV    word ptr [bp + 0xc], 1 ; LOCAL_STORE
011A3D  EB 3A                 JMP    0x11a79 ; JUMP
011A3F  90                    NOP ; NOP
011A40  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
011A44  75 28                 JNE    0x11a6e ; CJUMP
011A46  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
011A49  9A 16 29 1D 0D        LCALL  0xd1d, 0x2916 ; LCALL
011A4E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
011A51  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
011A54  0B C0                 OR     ax, ax ; LOGIC
011A56  75 08                 JNE    0x11a60 ; CJUMP
011A58  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
011A5D  EB 2D                 JMP    0x11a8c ; JUMP
011A5F  90                    NOP ; NOP
011A60  80 64 06 FB           AND    byte ptr [si + 6], 0xfb ; LOGIC
011A64  80 4C 06 08           OR     byte ptr [si + 6], 8 ; LOGIC
011A68  C6 05 00              MOV    byte ptr [di], 0 ; MOV
011A6B  EB 0C                 JMP    0x11a79 ; JUMP
011A6D  90                    NOP ; NOP
011A6E  FF 06 C2 2A           INC    word ptr [0x2ac2] ; ARITH
011A72  80                    DB     0x80 ; DATA_BYTE
