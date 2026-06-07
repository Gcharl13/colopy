; ============================================================================
; func_009FFC_unknown
; Region   : load_image
; Bytes    : file 0x009FFC..0x00A222  (550 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009FFC  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
00A000  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A003  0E                    PUSH   cs ; STACK_PUSH
00A004  E8 C1 F0              CALL   0x90c8 ; CALL_NEAR
00A007  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A00A  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
00A00D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00A010  0E                    PUSH   cs ; STACK_PUSH
00A011  E8 EE F0              CALL   0x9102 ; CALL_NEAR
00A014  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A017  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
00A01A  3B 46 EA              CMP    ax, word ptr [bp - 0x16] ; CMP
00A01D  75 05                 JNE    0xa024 ; CJUMP
00A01F  B8 01 00              MOV    ax, 1 ; MOV
00A022  EB 02                 JMP    0xa026 ; JUMP
00A024  2B C0                 SUB    ax, ax ; ARITH
00A026  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
00A029  0E                    PUSH   cs ; STACK_PUSH
00A02A  E8 F7 E4              CALL   0x8524 ; CALL_NEAR
00A02D  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
00A030  2B C8                 SUB    cx, ax ; ARITH
00A032  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A036  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
00A039  98                    CWDE ; ARITH
00A03A  F7 E9                 IMUL   cx ; ARITH
00A03C  05 32 00              ADD    ax, 0x32 ; ARITH
00A03F  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
00A042  99                    CDQ ; ARITH
00A043  F7 F9                 IDIV   cx ; ARITH
00A045  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00A048  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4 ; CMP
00A04C  73 1C                 JAE    0xa06a ; CJUMP
00A04E  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00A051  2A E4                 SUB    ah, ah ; ARITH
00A053  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
00A056  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
00A05A  75 0E                 JNE    0xa06a ; CJUMP
00A05C  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
00A05F  2D 0A 00              SUB    ax, 0xa ; ARITH
00A062  F7 D8                 NEG    ax ; ARITH
00A064  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00A067  EB 06                 JMP    0xa06f ; JUMP
00A069  90                    NOP ; NOP
00A06A  C7 46 F6 0A 00        MOV    word ptr [bp - 0xa], 0xa ; LOCAL_STORE
00A06F  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A073  80 7F 1A 04           CMP    byte ptr [bx + 0x1a], 4 ; CMP
00A077  73 0E                 JAE    0xa087 ; CJUMP
00A079  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00A07C  2A E4                 SUB    ah, ah ; ARITH
00A07E  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
00A081  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
00A085  74 05                 JE     0xa08c ; CJUMP
00A087  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
00A08C  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
00A08F  99                    CDQ ; ARITH
00A090  F7 7E F6              IDIV   word ptr [bp - 0xa] ; ARITH
00A093  F7 D8                 NEG    ax ; ARITH
00A095  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00A098  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A09C  F6 47 1C 04           TEST   byte ptr [bx + 0x1c], 4 ; LOGIC
00A0A0  74 04                 JE     0xa0a6 ; CJUMP
00A0A2  40                    INC    ax ; ARITH
00A0A3  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00A0A6  F6 47 1C 02           TEST   byte ptr [bx + 0x1c], 2 ; LOGIC
00A0AA  74 03                 JE     0xa0af ; CJUMP
00A0AC  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
00A0AF  83 7E E4 01           CMP    word ptr [bp - 0x1c], 1 ; CMP
00A0B3  1B C0                 SBB    ax, ax ; ARITH
00A0B5  24 FE                 AND    al, 0xfe ; LOGIC
00A0B7  05 03 00              ADD    ax, 3 ; ARITH
00A0BA  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A0BD  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; LOCAL_STORE
00A0C2  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
00A0C5  0E                    PUSH   cs ; STACK_PUSH
00A0C6  E8 D3 EC              CALL   0x8d9c ; CALL_NEAR
00A0C9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A0CC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00A0CF  50                    PUSH   ax ; STACK_PUSH
00A0D0  0E                    PUSH   cs ; STACK_PUSH
00A0D1  E8 10 E6              CALL   0x86e4 ; CALL_NEAR
00A0D4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A0D7  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
00A0DA  2D 19 00              SUB    ax, 0x19 ; ARITH
00A0DD  74 19                 JE     0xa0f8 ; CJUMP
00A0DF  48                    DEC    ax ; ARITH
00A0E0  7C 03                 JL     0xa0e5 ; CJUMP
00A0E2  48                    DEC    ax ; ARITH
00A0E3  7E 07                 JLE    0xa0ec ; CJUMP
00A0E5  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3 ; LOCAL_STORE
00A0EA  EB 05                 JMP    0xa0f1 ; JUMP
00A0EC  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
00A0F1  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
00A0F4  E9 ED 00              JMP    0xa1e4 ; JUMP
00A0F7  90                    NOP ; NOP
00A0F8  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2 ; LOCAL_STORE
00A0FD  EB F2                 JMP    0xa0f1 ; JUMP
00A0FF  90                    NOP ; NOP
00A100  C7 46 E8 10 00        MOV    word ptr [bp - 0x18], 0x10 ; LOCAL_STORE
00A105  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
00A109  74 05                 JE     0xa110 ; CJUMP
00A10B  B8 06 00              MOV    ax, 6 ; MOV
00A10E  EB 03                 JMP    0xa113 ; JUMP
00A110  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
00A113  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A116  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
00A119  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
00A11C  6A 24                 PUSH   0x24 ; PUSH_CONST
00A11E  0E                    PUSH   cs ; STACK_PUSH
00A11F  E8 1C E5              CALL   0x863e ; CALL_NEAR
00A122  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A125  0B C0                 OR     ax, ax ; LOGIC
00A127  75 03                 JNE    0xa12c ; CJUMP
00A129  E9 DA 00              JMP    0xa206 ; JUMP
00A12C  D1 66 FA              SHL    word ptr [bp - 6], 1 ; LOGIC
00A12F  E9 D4 00              JMP    0xa206 ; JUMP
00A132  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
00A136  74 06                 JE     0xa13e ; CJUMP
00A138  B8 06 00              MOV    ax, 6 ; MOV
00A13B  EB 04                 JMP    0xa141 ; JUMP
00A13D  90                    NOP ; NOP
00A13E  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
00A141  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A144  C7 46 E8 11 00        MOV    word ptr [bp - 0x18], 0x11 ; LOCAL_STORE
00A149  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
00A14C  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
00A14F  6A 26                 PUSH   0x26 ; PUSH_CONST
00A151  0E                    PUSH   cs ; STACK_PUSH
00A152  E8 E9 E4              CALL   0x863e ; CALL_NEAR
00A155  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A158  0B C0                 OR     ax, ax ; LOGIC
00A15A  74 03                 JE     0xa15f ; CJUMP
00A15C  D1 66 FA              SHL    word ptr [bp - 6], 1 ; LOGIC
00A15F  6A 15                 PUSH   0x15 ; PUSH_CONST
00A161  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A165  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00A168  2A E4                 SUB    ah, ah ; ARITH
00A16A  50                    PUSH   ax ; STACK_PUSH
00A16B  9A 00 00 81 09        LCALL  0x981, 0 ; LCALL
00A170  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A173  0B C0                 OR     ax, ax ; LOGIC
00A175  75 03                 JNE    0xa17a ; CJUMP
00A177  E9 8C 00              JMP    0xa206 ; JUMP
00A17A  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00A17D  D1 F8                 SAR    ax, 1 ; LOGIC
00A17F  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
00A182  E9 81 00              JMP    0xa206 ; JUMP
00A185  90                    NOP ; NOP
00A186  90                    NOP ; NOP
00A187  90                    NOP ; NOP
00A188  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
00A18B  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
00A18E  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
00A191  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
00A194  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A197  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00A19A  0E                    PUSH   cs ; STACK_PUSH
00A19B  E8 B0 E4              CALL   0x864e ; CALL_NEAR
00A19E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A1A1  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00A1A4  3D 01 00              CMP    ax, 1 ; CMP
00A1A7  7E 09                 JLE    0xa1b2 ; CJUMP
00A1A9  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00A1AC  03 46 EE              ADD    ax, word ptr [bp - 0x12] ; ARITH
00A1AF  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A1B2  83 7E F4 02           CMP    word ptr [bp - 0xc], 2 ; CMP
00A1B6  7E 08                 JLE    0xa1c0 ; CJUMP
00A1B8  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00A1BB  D1 F8                 SAR    ax, 1 ; LOGIC
00A1BD  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
00A1C0  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
00A1C4  E9 60 FF              JMP    0xa127 ; JUMP
00A1C7  90                    NOP ; NOP
00A1C8  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
00A1CB  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
00A1CE  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A1D1  C7 46 E8 12 00        MOV    word ptr [bp - 0x18], 0x12 ; LOCAL_STORE
00A1D6  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
00A1DA  74 2A                 JE     0xa206 ; CJUMP
00A1DC  D1 E0                 SHL    ax, 1 ; LOGIC
00A1DE  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A1E1  EB 23                 JMP    0xa206 ; JUMP
00A1E3  90                    NOP ; NOP
00A1E4  2D 09 00              SUB    ax, 9 ; ARITH
00A1E7  3D 08 00              CMP    ax, 8 ; CMP
00A1EA  77 1A                 JA     0xa206 ; CJUMP
00A1EC  D1 E0                 SHL    ax, 1 ; LOGIC
00A1EE  93                    XCHG   bx, ax ; MOV
00A1EF  2E FF A7 44 1F        JMP    word ptr cs:[bx + 0x1f44] ; JUMP
00A1F4  D8 1E D8 1E           FCOMP  dword ptr [0x1ed8]           ; UNKNOWN
00A1F8  D8 1E D8 1E           FCOMP  dword ptr [0x1ed8]           ; UNKNOWN
00A1FC  50                    PUSH   ax ; STACK_PUSH
00A1FD  1E                    PUSH   ds ; STACK_PUSH
00A1FE  D8 1E D8 1E           FCOMP  dword ptr [0x1ed8]           ; UNKNOWN
00A202  82 1E 18 1F 83        SBB    byte ptr [0x1f18], 0x83 ; ARITH
00A207  7E 08                 JLE    0xa211 ; CJUMP
00A209  00 74 08              ADD    byte ptr [si + 8], dh ; ARITH
00A20C  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
00A20F  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00A212  89 07                 MOV    word ptr [bx], ax ; MOV
00A214  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00A217  0B C0                 OR     ax, ax ; LOGIC
00A219  7D 02                 JGE    0xa21d ; CJUMP
00A21B  2B C0                 SUB    ax, ax ; ARITH
00A21D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00A220  C9                    LEAVE ; EPILOGUE
00A221  CB                    RETF ; RETURN
