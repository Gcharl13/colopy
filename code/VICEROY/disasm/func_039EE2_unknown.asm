; ============================================================================
; func_039EE2_unknown
; Region   : overlay
; Bytes    : file 0x039EE2..0x03A1CC  (746 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039EE2  C8 7E 00 00           ENTER  0x7e, 0 ; PROLOGUE
039EE6  A0 A8 53              MOV    al, byte ptr [0x53a8] ; GLOBAL_LOAD
039EE9  98                    CWDE ; ARITH
039EEA  8B C8                 MOV    cx, ax ; MOV
039EEC  B0 64                 MOV    al, 0x64 ; CONST_LOAD
039EEE  F6 2E A7 53           IMUL   byte ptr [0x53a7] ; ARITH
039EF2  03 C8                 ADD    cx, ax ; ARITH
039EF4  89 4E 96              MOV    word ptr [bp - 0x6a], cx ; LOCAL_STORE
039EF7  2B C0                 SUB    ax, ax ; ARITH
039EF9  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
039EFC  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
039EFF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
039F02  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
039F05  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
039F08  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
039F0B  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
039F0E  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
039F11  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
039F14  89 46 8C              MOV    word ptr [bp - 0x74], ax ; LOCAL_STORE
039F17  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
039F1A  EB 1A                 JMP    0x39f36 ; JUMP
039F1C  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
039F1F  39 46 82              CMP    word ptr [bp - 0x7e], ax ; CMP
039F22  74 0F                 JE     0x39f33 ; CJUMP
039F24  69 5E 82 3C 01        IMUL   bx, word ptr [bp - 0x7e], 0x13c ; ARITH
039F29  F6 87 08 88 04        TEST   byte ptr [bx - 0x77f8], 4 ; LOGIC
039F2E  74 03                 JE     0x39f33 ; CJUMP
039F30  FF 46 AA              INC    word ptr [bp - 0x56] ; ARITH
039F33  FF 46 82              INC    word ptr [bp - 0x7e] ; ARITH
039F36  83 7E 82 04           CMP    word ptr [bp - 0x7e], 4 ; CMP
039F3A  7C E0                 JL     0x39f1c ; CJUMP
039F3C  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
039F3F  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
039F42  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
039F46  75 03                 JNE    0x39f4b ; CJUMP
039F48  E9 4F 01              JMP    0x3a09a ; JUMP
039F4B  0E                    PUSH   cs ; STACK_PUSH
039F4C  E8 2A 14              CALL   0x3b379 ; CALL_NEAR
039F4F  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
039F52  2A E4                 SUB    ah, ah ; ARITH
039F54  50                    PUSH   ax ; STACK_PUSH
039F55  B8 05 00              MOV    ax, 5 ; MOV
039F58  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
039F5B  50                    PUSH   ax ; STACK_PUSH
039F5C  68 40 01              PUSH   0x140 ; PUSH_CONST
039F5F  6A 00                 PUSH   0 ; STACK_PUSH
039F61  FF 36 9E 2E           PUSH   word ptr [0x2e9e] ; PUSH_GLOBAL
039F65  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
039F6A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039F6D  52                    PUSH   dx ; STACK_PUSH
039F6E  50                    PUSH   ax ; STACK_PUSH
039F6F  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
039F74  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
039F77  F6 06 82 53 10        TEST   byte ptr [0x5382], 0x10 ; LOGIC
039F7C  74 2C                 JE     0x39faa ; CJUMP
039F7E  A0 30 08              MOV    al, byte ptr [0x830] ; GLOBAL_LOAD
039F81  2A E4                 SUB    ah, ah ; ARITH
039F83  50                    PUSH   ax ; STACK_PUSH
039F84  B8 61 00              MOV    ax, 0x61 ; CONST_LOAD
039F87  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
039F8A  50                    PUSH   ax ; STACK_PUSH
039F8B  68 40 01              PUSH   0x140 ; PUSH_CONST
039F8E  6A 00                 PUSH   0 ; STACK_PUSH
039F90  FF 36 B6 2E           PUSH   word ptr [0x2eb6] ; PUSH_GLOBAL
039F94  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
039F99  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039F9C  52                    PUSH   dx ; STACK_PUSH
039F9D  50                    PUSH   ax ; STACK_PUSH
039F9E  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
039FA3  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
039FA6  E9 EF 09              JMP    0x3a998 ; JUMP
039FA9  90                    NOP ; NOP
039FAA  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
039FAE  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
039FB1  2A E4                 SUB    ah, ah ; ARITH
039FB3  40                    INC    ax ; ARITH
039FB4  01 46 9E              ADD    word ptr [bp - 0x62], ax ; ARITH
039FB7  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
039FBB  8A 1E A6 53           MOV    bl, byte ptr [0x53a6] ; GLOBAL_LOAD
039FBF  2A FF                 SUB    bh, bh ; ARITH
039FC1  D1 E3                 SHL    bx, 1 ; LOGIC
039FC3  FF B7 94 83           PUSH   word ptr [bx - 0x7c6c] ; PUSH_GLOBAL
039FC7  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
039FCA  50                    PUSH   ax ; STACK_PUSH
039FCB  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
039FD0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
039FD3  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
039FD6  50                    PUSH   ax ; STACK_PUSH
039FD7  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
039FDC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039FDF  6B 46 82 34           IMUL   ax, word ptr [bp - 0x7e], 0x34 ; ARITH
039FE3  05 0E 54              ADD    ax, 0x540e ; ARITH
039FE6  50                    PUSH   ax ; STACK_PUSH
039FE7  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
039FEA  50                    PUSH   ax ; STACK_PUSH
039FEB  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
039FF0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
039FF3  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
039FF6  50                    PUSH   ax ; STACK_PUSH
039FF7  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
039FFC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039FFF  FF 36 E0 2D           PUSH   word ptr [0x2de0] ; PUSH_GLOBAL
03A003  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A006  50                    PUSH   ax ; STACK_PUSH
03A007  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03A00C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03A00F  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A012  50                    PUSH   ax ; STACK_PUSH
03A013  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03A018  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A01B  FF 76 82              PUSH   word ptr [bp - 0x7e] ; PUSH_GLOBAL
03A01E  9A 5E 06 1F 18        LCALL  0x181f, 0x65e ; THUNK -> 0x05B3:0x024E (thunk @file 0x01AC4E type B) overlay @file 0x05FE7A
03A023  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A026  50                    PUSH   ax ; STACK_PUSH
03A027  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A02A  50                    PUSH   ax ; STACK_PUSH
03A02B  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03A030  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03A033  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A036  50                    PUSH   ax ; STACK_PUSH
03A037  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
03A03C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A03F  8B 1E 8C 53           MOV    bx, word ptr [0x538c] ; GLOBAL_LOAD
03A043  D1 E3                 SHL    bx, 1 ; LOGIC
03A045  FF B7 00 98           PUSH   word ptr [bx - 0x6800] ; PUSH_GLOBAL
03A049  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A04C  50                    PUSH   ax ; STACK_PUSH
03A04D  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03A052  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03A055  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A058  50                    PUSH   ax ; STACK_PUSH
03A059  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03A05E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A061  FF 36 8A 53           PUSH   word ptr [0x538a] ; PUSH_GLOBAL
03A065  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A068  16                    PUSH   ss ; STACK_PUSH
03A069  50                    PUSH   ax ; STACK_PUSH
03A06A  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03A06F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03A072  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
03A075  2A E4                 SUB    ah, ah ; ARITH
03A077  50                    PUSH   ax ; STACK_PUSH
03A078  FF 76 9E              PUSH   word ptr [bp - 0x62] ; PUSH_GLOBAL
03A07B  68 40 01              PUSH   0x140 ; PUSH_CONST
03A07E  6A 00                 PUSH   0 ; STACK_PUSH
03A080  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03A083  16                    PUSH   ss ; STACK_PUSH
03A084  50                    PUSH   ax ; STACK_PUSH
03A085  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03A08A  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03A08D  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
03A091  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03A094  2A E4                 SUB    ah, ah ; ARITH
03A096  40                    INC    ax ; ARITH
03A097  01 46 9E              ADD    word ptr [bp - 0x62], ax ; ARITH
03A09A  C7 46 9E 18 00        MOV    word ptr [bp - 0x62], 0x18 ; LOCAL_STORE
03A09F  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
03A0A2  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
03A0A5  A3 0E 2D              MOV    word ptr [0x2d0e], ax ; GLOBAL_LOAD
03A0A8  C7 06 10 2D 20 00     MOV    word ptr [0x2d10], 0x20 ; GLOBAL_LOAD
03A0AE  C7 46 84 00 00        MOV    word ptr [bp - 0x7c], 0 ; LOCAL_STORE
03A0B3  EB 68                 JMP    0x3a11d ; JUMP
03A0B5  90                    NOP ; NOP
03A0B6  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0 ; LOCAL_STORE
03A0BB  EB 20                 JMP    0x3a0dd ; JUMP
03A0BD  90                    NOP ; NOP
03A0BE  83 7E 90 19           CMP    word ptr [bp - 0x70], 0x19 ; CMP
03A0C2  74 0C                 JE     0x3a0d0 ; CJUMP
03A0C4  83 7E 90 1A           CMP    word ptr [bp - 0x70], 0x1a ; CMP
03A0C8  74 06                 JE     0x3a0d0 ; CJUMP
03A0CA  83 7E 90 1B           CMP    word ptr [bp - 0x70], 0x1b ; CMP
03A0CE  75 06                 JNE    0x3a0d6 ; CJUMP
03A0D0  FF 46 92              INC    word ptr [bp - 0x6e] ; ARITH
03A0D3  EB 05                 JMP    0x3a0da ; JUMP
03A0D5  90                    NOP ; NOP
03A0D6  83 46 92 04           ADD    word ptr [bp - 0x6e], 4 ; ARITH
03A0DA  FF 46 A2              INC    word ptr [bp - 0x5e] ; ARITH
03A0DD  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03A0E1  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
03A0E4  98                    CWDE ; ARITH
03A0E5  3B 46 A2              CMP    ax, word ptr [bp - 0x5e] ; CMP
03A0E8  7E 30                 JLE    0x3a11a ; CJUMP
03A0EA  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
03A0ED  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
03A0F2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A0F5  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
03A0F8  9A C6 02 1F 18        LCALL  0x181f, 0x2c6 ; THUNK -> 0x012B:0x0002 (thunk @file 0x01A8B6 type B) overlay @file 0x02356C
03A0FD  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03A100  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03A104  74 07                 JE     0x3a10d ; CJUMP
03A106  50                    PUSH   ax ; STACK_PUSH
03A107  E8 8E FD              CALL   0x39e98 ; CALL_NEAR
03A10A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A10D  83 7E 90 1C           CMP    word ptr [bp - 0x70], 0x1c ; CMP
03A111  75 AB                 JNE    0x3a0be ; CJUMP
03A113  83 46 92 02           ADD    word ptr [bp - 0x6e], 2 ; ARITH
03A117  EB C1                 JMP    0x3a0da ; JUMP
03A119  90                    NOP ; NOP
03A11A  FF 46 84              INC    word ptr [bp - 0x7c] ; ARITH
03A11D  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
03A120  39 46 84              CMP    word ptr [bp - 0x7c], ax ; CMP
03A123  7D 2F                 JGE    0x3a154 ; CJUMP
03A125  FF 76 84              PUSH   word ptr [bp - 0x7c] ; PUSH_GLOBAL
03A128  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03A12D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A130  8A 46 82              MOV    al, byte ptr [bp - 0x7e] ; LOCAL_LOAD
03A133  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03A137  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03A13A  75 03                 JNE    0x3a13f ; CJUMP
03A13C  E9 77 FF              JMP    0x3a0b6 ; JUMP
03A13F  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03A144  74 D4                 JE     0x3a11a ; CJUMP
03A146  A0 D2 53              MOV    al, byte ptr [0x53d2] ; GLOBAL_LOAD
03A149  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03A14C  75 03                 JNE    0x3a151 ; CJUMP
03A14E  E9 65 FF              JMP    0x3a0b6 ; JUMP
03A151  EB C7                 JMP    0x3a11a ; JUMP
03A153  90                    NOP ; NOP
03A154  C7 46 86 00 00        MOV    word ptr [bp - 0x7a], 0 ; LOCAL_STORE
03A159  EB 13                 JMP    0x3a16e ; JUMP
03A15B  90                    NOP ; NOP
03A15C  FF 76 86              PUSH   word ptr [bp - 0x7a] ; PUSH_GLOBAL
03A15F  9A 78 0B 1F 18        LCALL  0x181f, 0xb78 ; THUNK -> 0x05EB:0x0902 (thunk @file 0x01B168 type B) overlay @file 0x0278F2
03A164  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A167  0B C0                 OR     ax, ax ; LOGIC
03A169  7D 2F                 JGE    0x3a19a ; CJUMP
03A16B  FF 46 86              INC    word ptr [bp - 0x7a] ; ARITH
03A16E  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
03A171  39 46 86              CMP    word ptr [bp - 0x7a], ax ; CMP
03A174  7C 03                 JL     0x3a179 ; CJUMP
03A176  E9 83 00              JMP    0x3a1fc ; JUMP
03A179  6B 5E 86 1C           IMUL   bx, word ptr [bp - 0x7a], 0x1c ; ARITH
03A17D  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03A181  24 0F                 AND    al, 0xf ; LOGIC
03A183  3A 46 82              CMP    al, byte ptr [bp - 0x7e] ; CMP
03A186  74 D4                 JE     0x3a15c ; CJUMP
03A188  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03A18D  74 DC                 JE     0x3a16b ; CJUMP
03A18F  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
03A192  39 46 82              CMP    word ptr [bp - 0x7e], ax ; CMP
03A195  74 C5                 JE     0x3a15c ; CJUMP
03A197  EB D2                 JMP    0x3a16b ; JUMP
03A199  90                    NOP ; NOP
03A19A  8B 46 86              MOV    ax, word ptr [bp - 0x7a] ; LOCAL_LOAD
03A19D  9A DA 02 1F 18        LCALL  0x181f, 0x2da ; THUNK -> 0x012B:0x0060 (thunk @file 0x01A8CA type B) overlay @file 0x0235CA
03A1A2  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03A1A5  3D 4A 00              CMP    ax, 0x4a ; CMP
03A1A8  7C 19                 JL     0x3a1c3 ; CJUMP
03A1AA  3D 4E 00              CMP    ax, 0x4e ; CMP
03A1AD  7F 14                 JG     0x3a1c3 ; CJUMP
03A1AF  6B 5E 86 1C           IMUL   bx, word ptr [bp - 0x7a], 0x1c ; ARITH
03A1B3  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
03A1B7  98                    CWDE ; ARITH
03A1B8  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
03A1BB  9A C6 02 1F 18        LCALL  0x181f, 0x2c6 ; THUNK -> 0x012B:0x0002 (thunk @file 0x01A8B6 type B) overlay @file 0x02356C
03A1C0  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
03A1C3  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
03A1C7  74 07                 JE     0x3a1d0 ; CJUMP
03A1C9  50                    PUSH   ax ; STACK_PUSH
03A1CA  E8                    DB     0xE8 ; DATA_BYTE
03A1CB  CB                    DB     0xCB ; DATA_BYTE
