; ============================================================================
; func_067F50_unknown
; Region   : overlay
; Bytes    : file 0x067F50..0x0680E2  (402 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067F50  C8 2C 00 00           ENTER  0x2c, 0 ; PROLOGUE
067F54  56                    PUSH   si ; STACK_PUSH
067F55  A1 A8 A5              MOV    ax, word ptr [0xa5a8] ; GLOBAL_LOAD
067F58  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
067F5B  2B C0                 SUB    ax, ax ; ARITH
067F5D  A3 A8 A5              MOV    word ptr [0xa5a8], ax ; GLOBAL_LOAD
067F60  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
067F63  E9 C0 00              JMP    0x68026 ; JUMP
067F66  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
067F69  2B 06 7C 01           SUB    ax, word ptr [0x17c] ; ARITH
067F6D  F7 D0                 NOT    ax ; LOGIC
067F6F  40                    INC    ax ; ARITH
067F70  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
067F73  FF 36 8A 01           PUSH   word ptr [0x18a] ; PUSH_GLOBAL
067F77  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
067F7A  2B 06 7E 01           SUB    ax, word ptr [0x17e] ; ARITH
067F7E  0B C0                 OR     ax, ax ; LOGIC
067F80  7F 0A                 JG     0x67f8c ; CJUMP
067F82  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
067F85  2B 06 7E 01           SUB    ax, word ptr [0x17e] ; ARITH
067F89  F7 D0                 NOT    ax ; LOGIC
067F8B  40                    INC    ax ; ARITH
067F8C  50                    PUSH   ax ; STACK_PUSH
067F8D  FF 76 DC              PUSH   word ptr [bp - 0x24] ; PUSH_GLOBAL
067F90  9A C8 06 1F 18        LCALL  0x181f, 0x6c8 ; THUNK -> 0x037F:0x003C (thunk @file 0x01ACB8 type B) overlay @file 0x02EB78
067F95  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
067F98  3D 01 00              CMP    ax, 1 ; CMP
067F9B  1B C0                 SBB    ax, ax ; ARITH
067F9D  F7 D8                 NEG    ax ; ARITH
067F9F  09 46 F8              OR     word ptr [bp - 8], ax ; LOGIC
067FA2  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
067FA5  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
067FA8  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
067FAC  7D 07                 JGE    0x67fb5 ; CJUMP
067FAE  2B 06 48 85           SUB    ax, word ptr [0x8548] ; ARITH
067FB2  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
067FB5  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
067FB9  7E 06                 JLE    0x67fc1 ; CJUMP
067FBB  A1 48 85              MOV    ax, word ptr [0x8548] ; GLOBAL_LOAD
067FBE  01 46 EE              ADD    word ptr [bp - 0x12], ax ; ARITH
067FC1  C4 1E 98 A5           LES    bx, ptr [0xa598] ; MOV_FAR
067FC5  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
067FC8  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067FCB  24 1F                 AND    al, 0x1f ; LOGIC
067FCD  88 46 F4              MOV    byte ptr [bp - 0xc], al ; LOCAL_STORE
067FD0  3C 18                 CMP    al, 0x18 ; CMP
067FD2  73 04                 JAE    0x67fd8 ; CJUMP
067FD4  80 66 F4 07           AND    byte ptr [bp - 0xc], 7 ; LOGIC
067FD8  8A 46 F4              MOV    al, byte ptr [bp - 0xc] ; LOCAL_LOAD
067FDB  2A E4                 SUB    ah, ah ; ARITH
067FDD  50                    PUSH   ax ; STACK_PUSH
067FDE  9A AA 06 1F 18        LCALL  0x181f, 0x6aa ; THUNK -> 0x037F:0x0614 (thunk @file 0x01AC9A type B) overlay @file 0x02F150
067FE3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
067FE6  88 46 E4              MOV    byte ptr [bp - 0x1c], al ; LOCAL_STORE
067FE9  C4 1E 94 A5           LES    bx, ptr [0xa594] ; MOV_FAR
067FED  8B 76 EE              MOV    si, word ptr [bp - 0x12] ; LOCAL_LOAD
067FF0  C4 1E 9C A5           LES    bx, ptr [0xa59c] ; MOV_FAR
067FF4  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067FF7  80 3E 9E A8 00        CMP    byte ptr [0xa89e], 0 ; CMP
067FFC  74 06                 JE     0x68004 ; CJUMP
067FFE  84 06 9E A8           TEST   byte ptr [0xa89e], al ; LOGIC
068002  74 06                 JE     0x6800a ; CJUMP
068004  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
068008  74 08                 JE     0x68012 ; CJUMP
06800A  C7 46 F2 01 00        MOV    word ptr [bp - 0xe], 1 ; LOCAL_STORE
06800F  EB 06                 JMP    0x68017 ; JUMP
068011  90                    NOP ; NOP
068012  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
068017  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
06801B  74 65                 JE     0x68082 ; CJUMP
06801D  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
068021  74 5F                 JE     0x68082 ; CJUMP
068023  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
068026  83 7E FC 04           CMP    word ptr [bp - 4], 4 ; CMP
06802A  7C 03                 JL     0x6802f ; CJUMP
06802C  E9 6F 01              JMP    0x6819e ; JUMP
06802F  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
068032  8A 87 AE 00           MOV    al, byte ptr [bx + 0xae] ; MOV
068036  98                    CWDE ; ARITH
068037  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06803A  8B C8                 MOV    cx, ax ; MOV
06803C  8A 87 A8 00           MOV    al, byte ptr [bx + 0xa8] ; MOV
068040  98                    CWDE ; ARITH
068041  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
068044  03 06 A0 A5           ADD    ax, word ptr [0xa5a0] ; ARITH
068048  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
06804B  03 0E A2 A5           ADD    cx, word ptr [0xa5a2] ; ARITH
06804F  89 4E E8              MOV    word ptr [bp - 0x18], cx ; LOCAL_STORE
068052  51                    PUSH   cx ; STACK_PUSH
068053  50                    PUSH   ax ; STACK_PUSH
068054  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
068059  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06805C  3D 01 00              CMP    ax, 1 ; CMP
06805F  1B C0                 SBB    ax, ax ; ARITH
068061  F7 D8                 NEG    ax ; ARITH
068063  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
068066  83 3E 8A 01 00        CMP    word ptr [0x18a], 0 ; CMP
06806B  75 03                 JNE    0x68070 ; CJUMP
06806D  E9 32 FF              JMP    0x67fa2 ; JUMP
068070  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
068073  2B 06 7C 01           SUB    ax, word ptr [0x17c] ; ARITH
068077  0B C0                 OR     ax, ax ; LOGIC
068079  7F 03                 JG     0x6807e ; CJUMP
06807B  E9 E8 FE              JMP    0x67f66 ; JUMP
06807E  E9 EF FE              JMP    0x67f70 ; JUMP
068081  90                    NOP ; NOP
068082  80 7E E4 19           CMP    byte ptr [bp - 0x1c], 0x19 ; CMP
068086  74 09                 JE     0x68091 ; CJUMP
068088  80 7E E4 1A           CMP    byte ptr [bp - 0x1c], 0x1a ; CMP
06808C  74 03                 JE     0x68091 ; CJUMP
06808E  E9 A1 00              JMP    0x68132 ; JUMP
068091  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
068095  74 03                 JE     0x6809a ; CJUMP
068097  E9 98 00              JMP    0x68132 ; JUMP
06809A  C7 46 F0 07 00        MOV    word ptr [bp - 0x10], 7 ; LOCAL_STORE
06809F  EB 14                 JMP    0x680b5 ; JUMP
0680A1  90                    NOP ; NOP
0680A2  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
0680A5  39 46 EA              CMP    word ptr [bp - 0x16], ax ; CMP
0680A8  7D 08                 JGE    0x680b2 ; CJUMP
0680AA  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
0680AD  39 46 E0              CMP    word ptr [bp - 0x20], ax ; CMP
0680B0  7C 40                 JL     0x680f2 ; CJUMP
0680B2  FF 4E F0              DEC    word ptr [bp - 0x10] ; ARITH
0680B5  80 7E E4 19           CMP    byte ptr [bp - 0x1c], 0x19 ; CMP
0680B9  74 06                 JE     0x680c1 ; CJUMP
0680BB  80 7E E4 1A           CMP    byte ptr [bp - 0x1c], 0x1a ; CMP
0680BF  75 5F                 JNE    0x68120 ; CJUMP
0680C1  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
0680C5  7C 59                 JL     0x68120 ; CJUMP
0680C7  8B 5E F0              MOV    bx, word ptr [bp - 0x10] ; LOCAL_LOAD
0680CA  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
0680CE  98                    CWDE ; ARITH
0680CF  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
0680D2  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
0680D5  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
0680D9  98                    CWDE ; ARITH
0680DA  03 46 E8              ADD    ax, word ptr [bp - 0x18] ; ARITH
0680DD  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
0680E0  F6                    DB     0xF6 ; DATA_BYTE
0680E1  C3                    DB     0xC3 ; DATA_BYTE
