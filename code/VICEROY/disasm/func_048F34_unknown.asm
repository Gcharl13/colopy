; ============================================================================
; func_048F34_unknown
; Region   : overlay
; Bytes    : file 0x048F34..0x0492CE  (922 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048F34  C8 A4 00 00           ENTER  0xa4, 0 ; PROLOGUE
048F38  57                    PUSH   di ; STACK_PUSH
048F39  56                    PUSH   si ; STACK_PUSH
048F3A  2B C0                 SUB    ax, ax ; ARITH
048F3C  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax ; LOCAL_STORE
048F40  89 86 62 FF           MOV    word ptr [bp - 0x9e], ax ; LOCAL_STORE
048F44  89 86 66 FF           MOV    word ptr [bp - 0x9a], ax ; LOCAL_STORE
048F48  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
048F4B  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
048F4E  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
048F51  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
048F54  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
048F57  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
048F5A  89 46 88              MOV    word ptr [bp - 0x78], ax ; LOCAL_STORE
048F5D  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
048F60  89 46 84              MOV    word ptr [bp - 0x7c], ax ; LOCAL_STORE
048F63  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
048F66  89 46 8C              MOV    word ptr [bp - 0x74], ax ; LOCAL_STORE
048F69  EB 0C                 JMP    0x48f77 ; JUMP
048F6B  90                    NOP ; NOP
048F6C  8B 76 8C              MOV    si, word ptr [bp - 0x74] ; LOCAL_LOAD
048F6F  C6 82 68 FF 00        MOV    byte ptr [bp + si - 0x98], 0 ; LOCAL_STORE
048F74  FF 46 8C              INC    word ptr [bp - 0x74] ; ARITH
048F77  83 7E 8C 19           CMP    word ptr [bp - 0x74], 0x19 ; CMP
048F7B  7C EF                 JL     0x48f6c ; CJUMP
048F7D  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0 ; LOCAL_STORE
048F82  E9 AA 00              JMP    0x4902f ; JUMP
048F85  90                    NOP ; NOP
048F86  FF 46 90              INC    word ptr [bp - 0x70] ; ARITH
048F89  83 7E 90 05           CMP    word ptr [bp - 0x70], 5 ; CMP
048F8D  7C 03                 JL     0x48f92 ; CJUMP
048F8F  E9 88 00              JMP    0x4901a ; JUMP
048F92  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048F96  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
048F99  2A E4                 SUB    ah, ah ; ARITH
048F9B  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
048F9F  8A 4C 01              MOV    cl, byte ptr [si + 1] ; MOV
048FA2  2A ED                 SUB    ch, ch ; ARITH
048FA4  2B C1                 SUB    ax, cx ; ARITH
048FA6  03 46 8A              ADD    ax, word ptr [bp - 0x76] ; ARITH
048FA9  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
048FAC  48                    DEC    ax ; ARITH
048FAD  48                    DEC    ax ; ARITH
048FAE  50                    PUSH   ax ; STACK_PUSH
048FAF  8A 07                 MOV    al, byte ptr [bx] ; MOV
048FB1  2A E4                 SUB    ah, ah ; ARITH
048FB3  8A 0C                 MOV    cl, byte ptr [si] ; MOV
048FB5  2B C1                 SUB    ax, cx ; ARITH
048FB7  03 46 90              ADD    ax, word ptr [bp - 0x70] ; ARITH
048FBA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
048FBD  48                    DEC    ax ; ARITH
048FBE  48                    DEC    ax ; ARITH
048FBF  50                    PUSH   ax ; STACK_PUSH
048FC0  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
048FC5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048FC8  0B C0                 OR     ax, ax ; LOGIC
048FCA  74 BA                 JE     0x48f86 ; CJUMP
048FCC  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
048FD0  7C B4                 JL     0x48f86 ; CJUMP
048FD2  83 7E FC 05           CMP    word ptr [bp - 4], 5 ; CMP
048FD6  7D AE                 JGE    0x48f86 ; CJUMP
048FD8  83 7E A6 00           CMP    word ptr [bp - 0x5a], 0 ; CMP
048FDC  7C A8                 JL     0x48f86 ; CJUMP
048FDE  83 7E A6 05           CMP    word ptr [bp - 0x5a], 5 ; CMP
048FE2  7D A2                 JGE    0x48f86 ; CJUMP
048FE4  83 7E 90 02           CMP    word ptr [bp - 0x70], 2 ; CMP
048FE8  75 06                 JNE    0x48ff0 ; CJUMP
048FEA  83 7E 8A 02           CMP    word ptr [bp - 0x76], 2 ; CMP
048FEE  74 12                 JE     0x49002 ; CJUMP
048FF0  FF 76 8A              PUSH   word ptr [bp - 0x76] ; PUSH_GLOBAL
048FF3  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
048FF6  9A E0 0C 1F 18        LCALL  0x181f, 0xce0 ; THUNK -> 0x05EB:0x06A6 (thunk @file 0x01B2D0 type B) overlay @file 0x027696
048FFB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
048FFE  0A C0                 OR     al, al ; LOGIC
049000  7C 84                 JL     0x48f86 ; CJUMP
049002  8B 76 8A              MOV    si, word ptr [bp - 0x76] ; LOCAL_LOAD
049005  8B C6                 MOV    ax, si ; MOV
049007  C1 E6 02              SHL    si, 2 ; LOGIC
04900A  03 F0                 ADD    si, ax ; ARITH
04900C  03 76 90              ADD    si, word ptr [bp - 0x70] ; ARITH
04900F  89 76 92              MOV    word ptr [bp - 0x6e], si ; LOCAL_STORE
049012  C6 82 68 FF 01        MOV    byte ptr [bp + si - 0x98], 1 ; LOCAL_STORE
049017  E9 6C FF              JMP    0x48f86 ; JUMP
04901A  FF 46 8A              INC    word ptr [bp - 0x76] ; ARITH
04901D  83 7E 8A 05           CMP    word ptr [bp - 0x76], 5 ; CMP
049021  7D 09                 JGE    0x4902c ; CJUMP
049023  C7 46 90 00 00        MOV    word ptr [bp - 0x70], 0 ; LOCAL_STORE
049028  E9 5E FF              JMP    0x48f89 ; JUMP
04902B  90                    NOP ; NOP
04902C  FF 46 8C              INC    word ptr [bp - 0x74] ; ARITH
04902F  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
049032  39 46 8C              CMP    word ptr [bp - 0x74], ax ; CMP
049035  7D 13                 JGE    0x4904a ; CJUMP
049037  FF 76 8C              PUSH   word ptr [bp - 0x74] ; PUSH_GLOBAL
04903A  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
04903F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
049042  C7 46 8A 00 00        MOV    word ptr [bp - 0x76], 0 ; LOCAL_STORE
049047  EB D4                 JMP    0x4901d ; JUMP
049049  90                    NOP ; NOP
04904A  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04904E  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
049051  2A E4                 SUB    ah, ah ; ARITH
049053  48                    DEC    ax ; ARITH
049054  48                    DEC    ax ; ARITH
049055  89 46 8A              MOV    word ptr [bp - 0x76], ax ; LOCAL_STORE
049058  E9 CE 01              JMP    0x49229 ; JUMP
04905B  90                    NOP ; NOP
04905C  FF 46 A4              INC    word ptr [bp - 0x5c] ; ARITH
04905F  83 46 A8 02           ADD    word ptr [bp - 0x58], 2 ; ARITH
049063  E9 BC 00              JMP    0x49122 ; JUMP
049066  83 7E 82 19           CMP    word ptr [bp - 0x7e], 0x19 ; CMP
04906A  74 06                 JE     0x49072 ; CJUMP
04906C  83 7E 82 1A           CMP    word ptr [bp - 0x7e], 0x1a ; CMP
049070  75 20                 JNE    0x49092 ; CJUMP
049072  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
049076  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
049079  2A E4                 SUB    ah, ah ; ARITH
04907B  40                    INC    ax ; ARITH
04907C  01 46 88              ADD    word ptr [bp - 0x78], ax ; ARITH
04907F  83 7E 88 03           CMP    word ptr [bp - 0x78], 3 ; CMP
049083  7D 03                 JGE    0x49088 ; CJUMP
049085  E9 9A 00              JMP    0x49122 ; JUMP
049088  83 46 94 02           ADD    word ptr [bp - 0x6c], 2 ; ARITH
04908C  83 6E 88 03           SUB    word ptr [bp - 0x78], 3 ; ARITH
049090  EB ED                 JMP    0x4907f ; JUMP
049092  83 7E 82 08           CMP    word ptr [bp - 0x7e], 8 ; CMP
049096  7C 03                 JL     0x4909b ; CJUMP
049098  E9 87 00              JMP    0x49122 ; JUMP
04909B  83 7E 82 05           CMP    word ptr [bp - 0x7e], 5 ; CMP
04909F  75 04                 JNE    0x490a5 ; CJUMP
0490A1  83 46 AA 04           ADD    word ptr [bp - 0x56], 4 ; ARITH
0490A5  83 7E 82 07           CMP    word ptr [bp - 0x7e], 7 ; CMP
0490A9  75 04                 JNE    0x490af ; CJUMP
0490AB  83 46 AA 02           ADD    word ptr [bp - 0x56], 2 ; ARITH
0490AF  83 7E 82 04           CMP    word ptr [bp - 0x7e], 4 ; CMP
0490B3  75 04                 JNE    0x490b9 ; CJUMP
0490B5  83 46 84 04           ADD    word ptr [bp - 0x7c], 4 ; ARITH
0490B9  83 7E 82 06           CMP    word ptr [bp - 0x7e], 6 ; CMP
0490BD  75 04                 JNE    0x490c3 ; CJUMP
0490BF  83 46 84 02           ADD    word ptr [bp - 0x7c], 2 ; ARITH
0490C3  83 7E 82 03           CMP    word ptr [bp - 0x7e], 3 ; CMP
0490C7  75 04                 JNE    0x490cd ; CJUMP
0490C9  83 46 9A 04           ADD    word ptr [bp - 0x66], 4 ; ARITH
0490CD  83 7E 82 00           CMP    word ptr [bp - 0x7e], 0 ; CMP
0490D1  75 04                 JNE    0x490d7 ; CJUMP
0490D3  83 46 9C 02           ADD    word ptr [bp - 0x64], 2 ; ARITH
0490D7  83 7E 82 02           CMP    word ptr [bp - 0x7e], 2 ; CMP
0490DB  75 07                 JNE    0x490e4 ; CJUMP
0490DD  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
0490E0  83 46 94 02           ADD    word ptr [bp - 0x6c], 2 ; ARITH
0490E4  83 7E 82 01           CMP    word ptr [bp - 0x7e], 1 ; CMP
0490E8  7E 22                 JLE    0x4910c ; CJUMP
0490EA  83 46 94 02           ADD    word ptr [bp - 0x6c], 2 ; ARITH
0490EE  83 7E 82 06           CMP    word ptr [bp - 0x7e], 6 ; CMP
0490F2  7D 12                 JGE    0x49106 ; CJUMP
0490F4  FF 46 94              INC    word ptr [bp - 0x6c] ; ARITH
0490F7  F6 46 82 04           TEST   byte ptr [bp - 0x7e], 4 ; LOGIC
0490FB  75 03                 JNE    0x49100 ; CJUMP
0490FD  E9 5F FF              JMP    0x4905f ; JUMP
049100  83 46 98 02           ADD    word ptr [bp - 0x68], 2 ; ARITH
049104  EB 1C                 JMP    0x49122 ; JUMP
049106  FF 46 9C              INC    word ptr [bp - 0x64] ; ARITH
049109  EB 17                 JMP    0x49122 ; JUMP
04910B  90                    NOP ; NOP
04910C  83 7E 82 01           CMP    word ptr [bp - 0x7e], 1 ; CMP
049110  75 06                 JNE    0x49118 ; CJUMP
049112  83 46 98 04           ADD    word ptr [bp - 0x68], 4 ; ARITH
049116  EB 0A                 JMP    0x49122 ; JUMP
049118  83 7E 82 00           CMP    word ptr [bp - 0x7e], 0 ; CMP
04911C  75 04                 JNE    0x49122 ; CJUMP
04911E  83 46 A8 03           ADD    word ptr [bp - 0x58], 3 ; ARITH
049122  FF 46 90              INC    word ptr [bp - 0x70] ; ARITH
049125  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
049129  8A 07                 MOV    al, byte ptr [bx] ; MOV
04912B  2A E4                 SUB    ah, ah ; ARITH
04912D  40                    INC    ax ; ARITH
04912E  40                    INC    ax ; ARITH
04912F  3B 46 90              CMP    ax, word ptr [bp - 0x70] ; CMP
049132  7D 03                 JGE    0x49137 ; CJUMP
049134  E9 EF 00              JMP    0x49226 ; JUMP
049137  FF 76 8A              PUSH   word ptr [bp - 0x76] ; PUSH_GLOBAL
04913A  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
04913D  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
049142  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
049145  0B C0                 OR     ax, ax ; LOGIC
049147  74 D9                 JE     0x49122 ; CJUMP
049149  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04914D  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
049150  2A E4                 SUB    ah, ah ; ARITH
049152  2B 46 8A              SUB    ax, word ptr [bp - 0x76] ; ARITH
049155  F7 D8                 NEG    ax ; ARITH
049157  40                    INC    ax ; ARITH
049158  40                    INC    ax ; ARITH
049159  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
04915C  8B C8                 MOV    cx, ax ; MOV
04915E  C1 E0 02              SHL    ax, 2 ; LOGIC
049161  03 C1                 ADD    ax, cx ; ARITH
049163  8A 0F                 MOV    cl, byte ptr [bx] ; MOV
049165  2A ED                 SUB    ch, ch ; ARITH
049167  2B 4E 90              SUB    cx, word ptr [bp - 0x70] ; ARITH
04916A  F7 D9                 NEG    cx ; ARITH
04916C  41                    INC    cx ; ARITH
04916D  41                    INC    cx ; ARITH
04916E  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
049171  03 C1                 ADD    ax, cx ; ARITH
049173  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
049176  8B F0                 MOV    si, ax ; MOV
049178  80 BA 68 FF 00        CMP    byte ptr [bp + si - 0x98], 0 ; CMP
04917D  75 A3                 JNE    0x49122 ; CJUMP
04917F  FF 76 8A              PUSH   word ptr [bp - 0x76] ; PUSH_GLOBAL
049182  FF 76 90              PUSH   word ptr [bp - 0x70] ; PUSH_GLOBAL
049185  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
04918A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04918D  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
049190  3D 1B 00              CMP    ax, 0x1b ; CMP
049193  75 04                 JNE    0x49199 ; CJUMP
049195  FF 86 62 FF           INC    word ptr [bp - 0x9e] ; ARITH
049199  3D 1C 00              CMP    ax, 0x1c ; CMP
04919C  75 04                 JNE    0x491a2 ; CJUMP
04919E  FF 86 66 FF           INC    word ptr [bp - 0x9a] ; ARITH
0491A2  3D 18 00              CMP    ax, 0x18 ; CMP
0491A5  75 04                 JNE    0x491ab ; CJUMP
0491A7  83 46 A8 04           ADD    word ptr [bp - 0x58], 4 ; ARITH
0491AB  3D 08 00              CMP    ax, 8 ; CMP
0491AE  7C 05                 JL     0x491b5 ; CJUMP
0491B0  3D 10 00              CMP    ax, 0x10 ; CMP
0491B3  7C 10                 JL     0x491c5 ; CJUMP
0491B5  3D 10 00              CMP    ax, 0x10 ; CMP
0491B8  7D 03                 JGE    0x491bd ; CJUMP
0491BA  E9 A9 FE              JMP    0x49066 ; JUMP
0491BD  3D 18 00              CMP    ax, 0x18 ; CMP
0491C0  7C 03                 JL     0x491c5 ; CJUMP
0491C2  E9 A1 FE              JMP    0x49066 ; JUMP
0491C5  FF 46 94              INC    word ptr [bp - 0x6c] ; ARITH
0491C8  3D 08 00              CMP    ax, 8 ; CMP
0491CB  7C 0C                 JL     0x491d9 ; CJUMP
0491CD  3D 10 00              CMP    ax, 0x10 ; CMP
0491D0  7D 07                 JGE    0x491d9 ; CJUMP
0491D2  2D 08 00              SUB    ax, 8 ; ARITH
0491D5  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax ; LOCAL_STORE
0491D9  83 7E 82 10           CMP    word ptr [bp - 0x7e], 0x10 ; CMP
0491DD  7C 10                 JL     0x491ef ; CJUMP
0491DF  83 7E 82 18           CMP    word ptr [bp - 0x7e], 0x18 ; CMP
0491E3  7D 0A                 JGE    0x491ef ; CJUMP
0491E5  8B 46 82              MOV    ax, word ptr [bp - 0x7e] ; LOCAL_LOAD
0491E8  2D 10 00              SUB    ax, 0x10 ; ARITH
0491EB  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax ; LOCAL_STORE
0491EF  83 BE 64 FF 03        CMP    word ptr [bp - 0x9c], 3 ; CMP
0491F4  7D 03                 JGE    0x491f9 ; CJUMP
0491F6  E9 63 FE              JMP    0x4905c ; JUMP
0491F9  FF 46 8E              INC    word ptr [bp - 0x72] ; ARITH
0491FC  FF 46 98              INC    word ptr [bp - 0x68] ; ARITH
0491FF  83 BE 64 FF 05        CMP    word ptr [bp - 0x9c], 5 ; CMP
049204  75 04                 JNE    0x4920a ; CJUMP
049206  83 46 AA 02           ADD    word ptr [bp - 0x56], 2 ; ARITH
04920A  83 BE 64 FF 04        CMP    word ptr [bp - 0x9c], 4 ; CMP
04920F  75 04                 JNE    0x49215 ; CJUMP
049211  83 46 84 02           ADD    word ptr [bp - 0x7c], 2 ; ARITH
049215  83 BE 64 FF 03        CMP    word ptr [bp - 0x9c], 3 ; CMP
04921A  74 03                 JE     0x4921f ; CJUMP
04921C  E9 03 FF              JMP    0x49122 ; JUMP
04921F  83 46 9A 02           ADD    word ptr [bp - 0x66], 2 ; ARITH
049223  E9 FC FE              JMP    0x49122 ; JUMP
049226  FF 46 8A              INC    word ptr [bp - 0x76] ; ARITH
049229  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
04922C  2A E4                 SUB    ah, ah ; ARITH
04922E  40                    INC    ax ; ARITH
04922F  40                    INC    ax ; ARITH
049230  3B 46 8A              CMP    ax, word ptr [bp - 0x76] ; CMP
049233  7C 0D                 JL     0x49242 ; CJUMP
049235  8A 07                 MOV    al, byte ptr [bx] ; MOV
049237  2A E4                 SUB    ah, ah ; ARITH
049239  48                    DEC    ax ; ARITH
04923A  48                    DEC    ax ; ARITH
04923B  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
04923E  E9 E4 FE              JMP    0x49125 ; JUMP
049241  90                    NOP ; NOP
049242  8A 47 04              MOV    al, byte ptr [bx + 4] ; MOV
049245  2A E4                 SUB    ah, ah ; ARITH
049247  40                    INC    ax ; ARITH
049248  89 86 5E FF           MOV    word ptr [bp - 0xa2], ax ; LOCAL_STORE
04924C  8B C8                 MOV    cx, ax ; MOV
04924E  F7 E9                 IMUL   cx ; ARITH
049250  89 86 60 FF           MOV    word ptr [bp - 0xa0], ax ; LOCAL_STORE
049254  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0 ; LOCAL_STORE
049259  2B C0                 SUB    ax, ax ; ARITH
04925B  8B 5E 8C              MOV    bx, word ptr [bp - 0x74] ; LOCAL_LOAD
04925E  D1 E3                 SHL    bx, 1 ; LOGIC
049260  89 87 58 9E           MOV    word ptr [bx - 0x61a8], ax ; MOV
049264  89 87 78 9E           MOV    word ptr [bx - 0x6188], ax ; MOV
049268  FF 46 8C              INC    word ptr [bp - 0x74] ; ARITH
04926B  83 7E 8C 10           CMP    word ptr [bp - 0x74], 0x10 ; CMP
04926F  7C E8                 JL     0x49259 ; CJUMP
049271  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
049275  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
049278  8B C8                 MOV    cx, ax ; MOV
04927A  2A E4                 SUB    ah, ah ; ARITH
04927C  BE 07 00              MOV    si, 7 ; MOV
04927F  2B F0                 SUB    si, ax ; ARITH
049281  03 86 5E FF           ADD    ax, word ptr [bp - 0xa2] ; ARITH
049285  F7 6E 94              IMUL   word ptr [bp - 0x6c] ; ARITH
049288  99                    CDQ ; ARITH
049289  F7 FE                 IDIV   si ; ARITH
04928B  01 06 78 9E           ADD    word ptr [0x9e78], ax ; ARITH
04928F  89 8E 5C FF           MOV    word ptr [bp - 0xa4], cx ; LOCAL_STORE
049293  80 F9 01              CMP    cl, 1 ; CMP
049296  76 04                 JBE    0x4929c ; CJUMP
049298  B1 01                 MOV    cl, 1 ; MOV
04929A  EB 02                 JMP    0x4929e ; JUMP
04929C  2A C9                 SUB    cl, cl ; ARITH
04929E  8B 86 60 FF           MOV    ax, word ptr [bp - 0xa0] ; LOCAL_LOAD
0492A2  C1 E0 02              SHL    ax, 2 ; LOGIC
0492A5  D3 F8                 SAR    ax, cl ; LOGIC
0492A7  A3 58 9E              MOV    word ptr [0x9e58], ax ; GLOBAL_LOAD
0492AA  80 BE 5C FF 01        CMP    byte ptr [bp - 0xa4], 1 ; CMP
0492AF  72 5E                 JB     0x4930f ; CJUMP
0492B1  80 BE 5C FF 02        CMP    byte ptr [bp - 0xa4], 2 ; CMP
0492B6  72 3C                 JB     0x492f4 ; CJUMP
0492B8  8B 47 0C              MOV    ax, word ptr [bx + 0xc] ; MOV
0492BB  8B 1E 52 8D           MOV    bx, word ptr [0x8d52] ; GLOBAL_LOAD
0492BF  8A 8F 2A 96           MOV    cl, byte ptr [bx - 0x69d6] ; MOV
0492C3  80 E9 01              SUB    cl, 1 ; ARITH
0492C6  1A D2                 SBB    dl, dl ; ARITH
0492C8  F6 D2                 NOT    dl ; LOGIC
0492CA  22 CA                 AND    cl, dl ; LOGIC
0492CC  80                    DB     0x80 ; DATA_BYTE
0492CD  C1                    DB     0xC1 ; DATA_BYTE
