; ============================================================================
; func_025900_unknown
; Region   : overlay
; Bytes    : file 0x025900..0x025A1D  (285 bytes)
; Purpose  : init_with_owner_nation (entry to colony state init)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

025900  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
025904  56                    PUSH   si ; STACK_PUSH
025905  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025909  8A 07                 MOV    al, byte ptr [bx] ; MOV
02590B  2A E4                 SUB    ah, ah ; ARITH
02590D  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
025910  2A F6                 SUB    dh, dh ; ARITH
025912  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
025917  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02591A  0B C0                 OR     ax, ax ; LOGIC
02591C  7C 10                 JL     0x2592e ; CJUMP
02591E  6A 0A                 PUSH   0xa ; PUSH_CONST
025920  50                    PUSH   ax ; STACK_PUSH
025921  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
025926  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
025929  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02592C  EB 05                 JMP    0x25933 ; JUMP
02592E  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
025933  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff ; LOCAL_STORE
025938  2B C0                 SUB    ax, ax ; ARITH
02593A  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02593D  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
025940  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
025943  EB 19                 JMP    0x2595e ; JUMP
025945  90                    NOP ; NOP
025946  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
025949  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
02594C  2A E4                 SUB    ah, ah ; ARITH
02594E  50                    PUSH   ax ; STACK_PUSH
02594F  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
025954  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
025957  A8 40                 TEST   al, 0x40 ; LOGIC
025959  74 6D                 JE     0x259c8 ; CJUMP
02595B  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
02595E  83 7E FA 08           CMP    word ptr [bp - 6], 8 ; CMP
025962  7D 7C                 JGE    0x259e0 ; CJUMP
025964  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
025967  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
02596B  98                    CWDE ; ARITH
02596C  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
025970  8A 4C 01              MOV    cl, byte ptr [si + 1] ; MOV
025973  2A ED                 SUB    ch, ch ; ARITH
025975  03 C1                 ADD    ax, cx ; ARITH
025977  8B D0                 MOV    dx, ax ; MOV
025979  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
02597D  98                    CWDE ; ARITH
02597E  8A 0C                 MOV    cl, byte ptr [si] ; MOV
025980  03 C1                 ADD    ax, cx ; ARITH
025982  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
025987  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02598A  0B C0                 OR     ax, ax ; LOGIC
02598C  7C CD                 JL     0x2595b ; CJUMP
02598E  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
025991  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
025995  25 0F 00              AND    ax, 0xf ; LOGIC
025998  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
02599B  3D 04 00              CMP    ax, 4 ; CMP
02599E  7D BB                 JGE    0x2595b ; CJUMP
0259A0  6A 0A                 PUSH   0xa ; PUSH_CONST
0259A2  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
0259A5  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
0259AA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0259AD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0259B0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0259B4  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
0259B7  2A E4                 SUB    ah, ah ; ARITH
0259B9  3B 46 EE              CMP    ax, word ptr [bp - 0x12] ; CMP
0259BC  75 88                 JNE    0x25946 ; CJUMP
0259BE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0259C1  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
0259C4  EB 95                 JMP    0x2595b ; JUMP
0259C6  90                    NOP ; NOP
0259C7  90                    NOP ; NOP
0259C8  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0259CB  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
0259CE  39 46 EA              CMP    word ptr [bp - 0x16], ax ; CMP
0259D1  7F 88                 JG     0x2595b ; CJUMP
0259D3  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
0259D6  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
0259D9  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0259DC  E9 7C FF              JMP    0x2595b ; JUMP
0259DF  90                    NOP ; NOP
0259E0  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
0259E3  2B 46 FC              SUB    ax, word ptr [bp - 4] ; ARITH
0259E6  79 02                 JNS    0x259ea ; CJUMP
0259E8  2B C0                 SUB    ax, ax ; ARITH
0259EA  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0259ED  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0259F1  74 08                 JE     0x259fb ; CJUMP
0259F3  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
0259F6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0259F9  89 07                 MOV    word ptr [bx], ax ; MOV
0259FB  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0259FF  74 08                 JE     0x25a09 ; CJUMP
025A01  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
025A04  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
025A07  89 07                 MOV    word ptr [bx], ax ; MOV
025A09  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
025A0D  74 08                 JE     0x25a17 ; CJUMP
025A0F  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
025A12  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
025A15  89 07                 MOV    word ptr [bx], ax ; MOV
025A17  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
025A1A  5E                    POP    si ; STACK_POP
025A1B  C9                    LEAVE ; EPILOGUE
025A1C  CB                    RETF ; RETURN
