; ============================================================================
; func_0627BE_unknown
; Region   : overlay
; Bytes    : file 0x0627BE..0x06286B  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0627BE  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
0627C2  53                    PUSH   bx ; STACK_PUSH
0627C3  52                    PUSH   dx ; STACK_PUSH
0627C4  50                    PUSH   ax ; STACK_PUSH
0627C5  56                    PUSH   si ; STACK_PUSH
0627C6  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
0627CB  C1 F8 02              SAR    ax, 2 ; LOGIC
0627CE  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0627D1  C1 FA 02              SAR    dx, 2 ; LOGIC
0627D4  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
0627D7  0B DB                 OR     bx, bx ; LOGIC
0627D9  74 0D                 JE     0x627e8 ; CJUMP
0627DB  6B F0 12              IMUL   si, ax, 0x12 ; ARITH
0627DE  8B DA                 MOV    bx, dx ; MOV
0627E0  80 B8 F6 86 00        CMP    byte ptr [bx + si - 0x790a], 0 ; CMP
0627E5  EB 0B                 JMP    0x627f2 ; JUMP
0627E7  90                    NOP ; NOP
0627E8  6B F0 12              IMUL   si, ax, 0x12 ; ARITH
0627EB  8B DA                 MOV    bx, dx ; MOV
0627ED  80 B8 E8 85 00        CMP    byte ptr [bx + si - 0x7a18], 0 ; CMP
0627F2  74 05                 JE     0x627f9 ; CJUMP
0627F4  C7 46 F2 08 00        MOV    word ptr [bp - 0xe], 8 ; LOCAL_STORE
0627F9  83 7E F2 08           CMP    word ptr [bp - 0xe], 8 ; CMP
0627FD  75 3D                 JNE    0x6283c ; CJUMP
0627FF  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
062802  50                    PUSH   ax ; STACK_PUSH
062803  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
062806  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
062809  C1 E0 02              SHL    ax, 2 ; LOGIC
06280C  40                    INC    ax ; ARITH
06280D  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
062810  C1 E2 02              SHL    dx, 2 ; LOGIC
062813  42                    INC    dx ; ARITH
062814  8D 5E FE              LEA    bx, [bp - 2] ; ADDR
062817  E8 F6 F5              CALL   0x61e10 ; CALL_NEAR
06281A  0B C0                 OR     ax, ax ; LOGIC
06281C  74 19                 JE     0x62837 ; CJUMP
06281E  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
062821  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
062824  6A 12                 PUSH   0x12 ; PUSH_CONST
062826  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
062829  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
06282C  8B 5E E6              MOV    bx, word ptr [bp - 0x1a] ; LOCAL_LOAD
06282F  0E                    PUSH   cs ; STACK_PUSH
062830  E8 8F 0B              CALL   0x633c2 ; CALL_NEAR
062833  0B C0                 OR     ax, ax ; LOGIC
062835  7D 05                 JGE    0x6283c ; CJUMP
062837  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
06283C  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
062840  7C 03                 JL     0x62845 ; CJUMP
062842  E9 E7 00              JMP    0x6292c ; JUMP
062845  C7 46 EC 63 00        MOV    word ptr [bp - 0x14], 0x63 ; LOCAL_STORE
06284A  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
06284F  EB 10                 JMP    0x62861 ; JUMP
062851  90                    NOP ; NOP
062852  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
062856  7C 06                 JL     0x6285e ; CJUMP
062858  83 7E F8 12           CMP    word ptr [bp - 8], 0x12 ; CMP
06285C  7C 30                 JL     0x6288e ; CJUMP
06285E  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
062861  83 7E F4 08           CMP    word ptr [bp - 0xc], 8 ; CMP
062865  7C 03                 JL     0x6286a ; CJUMP
062867  E9 C2 00              JMP    0x6292c ; JUMP
06286A  8B                    DB     0x8B ; DATA_BYTE
