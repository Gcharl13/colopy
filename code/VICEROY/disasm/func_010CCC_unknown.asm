; ============================================================================
; func_010CCC_unknown
; Region   : load_image
; Bytes    : file 0x010CCC..0x010D80  (180 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010CCC  55                    PUSH   bp ; STACK_PUSH
010CCD  8B EC                 MOV    bp, sp ; MOV
010CCF  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
010CD2  57                    PUSH   di ; STACK_PUSH
010CD3  56                    PUSH   si ; STACK_PUSH
010CD4  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
010CD7  8A 07                 MOV    al, byte ptr [bx] ; MOV
010CD9  98                    CWDE ; ARITH
010CDA  3D 77 00              CMP    ax, 0x77 ; CMP
010CDD  74 45                 JE     0x10d24 ; CJUMP
010CDF  77 08                 JA     0x10ce9 ; CJUMP
010CE1  2C 61                 SUB    al, 0x61 ; ARITH
010CE3  74 49                 JE     0x10d2e ; CJUMP
010CE5  2C 11                 SUB    al, 0x11 ; ARITH
010CE7  74 05                 JE     0x10cee ; CJUMP
010CE9  2B C0                 SUB    ax, ax ; ARITH
010CEB  E9 C0 00              JMP    0x10dae ; JUMP
010CEE  2B F6                 SUB    si, si ; ARITH
010CF0  C6 46 FC 01           MOV    byte ptr [bp - 4], 1 ; LOCAL_STORE
010CF4  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
010CF9  FF 46 08              INC    word ptr [bp + 8] ; ARITH
010CFC  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
010CFF  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
010D02  74 5A                 JE     0x10d5e ; CJUMP
010D04  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
010D08  74 54                 JE     0x10d5e ; CJUMP
010D0A  8A 07                 MOV    al, byte ptr [bx] ; MOV
010D0C  98                    CWDE ; ARITH
010D0D  3D 74 00              CMP    ax, 0x74 ; CMP
010D10  74 34                 JE     0x10d46 ; CJUMP
010D12  77 08                 JA     0x10d1c ; CJUMP
010D14  2C 2B                 SUB    al, 0x2b ; ARITH
010D16  74 1C                 JE     0x10d34 ; CJUMP
010D18  2C 37                 SUB    al, 0x37 ; ARITH
010D1A  74 36                 JE     0x10d52 ; CJUMP
010D1C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
010D21  EB D6                 JMP    0x10cf9 ; JUMP
010D23  90                    NOP ; NOP
010D24  BE 01 03              MOV    si, 0x301 ; CONST_LOAD
010D27  C6 46 FC 02           MOV    byte ptr [bp - 4], 2 ; LOCAL_STORE
010D2B  EB C7                 JMP    0x10cf4 ; JUMP
010D2D  90                    NOP ; NOP
010D2E  BE 09 01              MOV    si, 0x109 ; CONST_LOAD
010D31  EB F4                 JMP    0x10d27 ; JUMP
010D33  90                    NOP ; NOP
010D34  F7 C6 02 00           TEST   si, 2 ; LOGIC
010D38  75 E2                 JNE    0x10d1c ; CJUMP
010D3A  83 CE 02              OR     si, 2 ; LOGIC
010D3D  83 E6 FE              AND    si, 0xfffe ; LOGIC
010D40  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80 ; LOCAL_STORE
010D44  EB B3                 JMP    0x10cf9 ; JUMP
010D46  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
010D4A  75 D0                 JNE    0x10d1c ; CJUMP
010D4C  81 CE 00 40           OR     si, 0x4000 ; LOGIC
010D50  EB A7                 JMP    0x10cf9 ; JUMP
010D52  F7 C6 00 C0           TEST   si, 0xc000 ; LOGIC
010D56  75 C4                 JNE    0x10d1c ; CJUMP
010D58  81 CE 00 80           OR     si, 0x8000 ; LOGIC
010D5C  EB 9B                 JMP    0x10cf9 ; JUMP
010D5E  B8 A4 01              MOV    ax, 0x1a4 ; CONST_LOAD
010D61  50                    PUSH   ax ; STACK_PUSH
010D62  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
010D65  56                    PUSH   si ; STACK_PUSH
010D66  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
010D69  9A 46 27 1D 0D        LCALL  0xd1d, 0x2746 ; LCALL
010D6E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
010D71  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
010D74  0B C0                 OR     ax, ax ; LOGIC
010D76  7D 03                 JGE    0x10d7b ; CJUMP
010D78  E9 6E FF              JMP    0x10ce9 ; JUMP
010D7B  FF 06 C2 2A           INC    word ptr [0x2ac2] ; ARITH
010D7F  8B                    DB     0x8B ; DATA_BYTE
