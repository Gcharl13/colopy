; ============================================================================
; func_0091CC_unknown
; Region   : load_image
; Bytes    : file 0x0091CC..0x009281  (181 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0091CC  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0091D0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0091D3  0E                    PUSH   cs ; STACK_PUSH
0091D4  E8 F1 FE              CALL   0x90c8 ; CALL_NEAR
0091D7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0091DA  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0091DD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0091E0  0E                    PUSH   cs ; STACK_PUSH
0091E1  E8 1E FF              CALL   0x9102 ; CALL_NEAR
0091E4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0091E7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0091EA  83 7E F8 13           CMP    word ptr [bp - 8], 0x13 ; CMP
0091EE  7F 16                 JG     0x9206 ; CJUMP
0091F0  3D 1C 00              CMP    ax, 0x1c ; CMP
0091F3  75 05                 JNE    0x91fa ; CJUMP
0091F5  C7 46 FA 13 00        MOV    word ptr [bp - 6], 0x13 ; LOCAL_STORE
0091FA  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0091FD  9A 02 00 2B 01        LCALL  0x12b, 2 ; LCALL
009202  E9 8C 00              JMP    0x9291 ; JUMP
009205  90                    NOP ; NOP
009206  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
009209  05 52 00              ADD    ax, 0x52 ; ARITH
00920C  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00920F  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
009212  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
009215  75 05                 JNE    0x921c ; CJUMP
009217  B8 01 00              MOV    ax, 1 ; MOV
00921A  EB 02                 JMP    0x921e ; JUMP
00921C  2B C0                 SUB    ax, ax ; ARITH
00921E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
009221  83 7E FA 15           CMP    word ptr [bp - 6], 0x15 ; CMP
009225  75 0B                 JNE    0x9232 ; CJUMP
009227  83 7E F8 17           CMP    word ptr [bp - 8], 0x17 ; CMP
00922B  75 05                 JNE    0x9232 ; CJUMP
00922D  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
009232  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
009236  75 09                 JNE    0x9241 ; CJUMP
009238  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
00923B  05 36 00              ADD    ax, 0x36 ; ARITH
00923E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
009241  83 7E F8 15           CMP    word ptr [bp - 8], 0x15 ; CMP
009245  74 06                 JE     0x924d ; CJUMP
009247  83 7E F8 17           CMP    word ptr [bp - 8], 0x17 ; CMP
00924B  75 47                 JNE    0x9294 ; CJUMP
00924D  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
009251  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
009254  98                    CWDE ; ARITH
009255  2B 46 06              SUB    ax, word ptr [bp + 6] ; ARITH
009258  F7 D8                 NEG    ax ; ARITH
00925A  50                    PUSH   ax ; STACK_PUSH
00925B  0E                    PUSH   cs ; STACK_PUSH
00925C  E8 75 F9              CALL   0x8bd4 ; CALL_NEAR
00925F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
009262  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
009265  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
009268  80 BF 46 31 09        CMP    byte ptr [bx + 0x3146], 9 ; CMP
00926D  74 07                 JE     0x9276 ; CJUMP
00926F  80 BF 46 31 07        CMP    byte ptr [bx + 0x3146], 7 ; CMP
009274  75 1E                 JNE    0x9294 ; CJUMP
009276  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
009279  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
00927D  2A FF                 SUB    bh, bh ; ARITH
00927F  8B C3                 MOV    ax, bx ; MOV
