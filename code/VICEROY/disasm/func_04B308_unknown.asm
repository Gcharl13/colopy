; ============================================================================
; func_04B308_unknown
; Region   : overlay
; Bytes    : file 0x04B308..0x04B57F  (631 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MADATSHIPS"  (auto-named via string xrefs)
; ============================================================================

04B308  C8 BA 00 00           ENTER  0xba, 0 ; PROLOGUE
04B30C  56                    PUSH   si ; STACK_PUSH
04B30D  C7 46 A8 01 00        MOV    word ptr [bp - 0x58], 1 ; LOCAL_STORE
04B312  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0 ; LOCAL_STORE
04B317  2B C0                 SUB    ax, ax ; ARITH
04B319  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
04B31C  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
04B31F  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
04B322  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
04B325  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04B328  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04B32B  9A F0 09 1F 18        LCALL  0x181f, 0x9f0 ; THUNK -> 0x0000:0x0304 (thunk @file 0x01AFE0 type A) overlay @file 0x025C04
04B330  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B333  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
04B336  50                    PUSH   ax ; STACK_PUSH
04B337  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
04B33C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B33F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B343  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
04B347  25 0F 00              AND    ax, 0xf ; LOGIC
04B34A  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
04B34D  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04B351  8A 4F 02              MOV    cl, byte ptr [bx + 2] ; MOV
04B354  2A ED                 SUB    ch, ch ; ARITH
04B356  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
04B359  83 E9 04              SUB    cx, 4 ; ARITH
04B35C  89 4E A0              MOV    word ptr [bp - 0x60], cx ; LOCAL_STORE
04B35F  50                    PUSH   ax ; STACK_PUSH
04B360  51                    PUSH   cx ; STACK_PUSH
04B361  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04B366  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B369  89 86 46 FF           MOV    word ptr [bp - 0xba], ax ; LOCAL_STORE
04B36D  8B 76 98              MOV    si, word ptr [bp - 0x68] ; LOCAL_LOAD
04B370  D1 E6                 SHL    si, 1 ; LOGIC
04B372  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04B376  8B 40 0A              MOV    ax, word ptr [bx + si + 0xa] ; MOV
04B379  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
04B37C  83 7E 98 04           CMP    word ptr [bp - 0x68], 4 ; CMP
04B380  7D 34                 JGE    0x4b3b6 ; CJUMP
04B382  6B 5E 98 34           IMUL   bx, word ptr [bp - 0x68], 0x34 ; ARITH
04B386  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04B38B  75 29                 JNE    0x4b3b6 ; CJUMP
04B38D  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
04B392  75 22                 JNE    0x4b3b6 ; CJUMP
04B394  83 3E 52 8D 00        CMP    word ptr [0x8d52], 0 ; CMP
04B399  75 05                 JNE    0x4b3a0 ; CJUMP
04B39B  6A 07                 PUSH   7 ; STACK_PUSH
04B39D  EB 0F                 JMP    0x4b3ae ; JUMP
04B39F  90                    NOP ; NOP
04B3A0  83 3E 52 8D 01        CMP    word ptr [0x8d52], 1 ; CMP
04B3A5  75 05                 JNE    0x4b3ac ; CJUMP
04B3A7  6A 06                 PUSH   6 ; STACK_PUSH
04B3A9  EB 03                 JMP    0x4b3ae ; JUMP
04B3AB  90                    NOP ; NOP
04B3AC  6A 05                 PUSH   5 ; STACK_PUSH
04B3AE  9A AC 04 1F 18        LCALL  0x181f, 0x4ac ; THUNK -> 0x029F:0x0318 (thunk @file 0x01AA9C type B) overlay @file 0x022340
04B3B3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B3B6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B3BA  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
04B3BF  72 5B                 JB     0x4b41c ; CJUMP
04B3C1  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
04B3C6  77 54                 JA     0x4b41c ; CJUMP
04B3C8  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04B3CB  FF 76 98              PUSH   word ptr [bp - 0x68] ; PUSH_GLOBAL
04B3CE  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
04B3D3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B3D6  A8 20                 TEST   al, 0x20 ; LOGIC
04B3D8  75 0C                 JNE    0x4b3e6 ; CJUMP
04B3DA  8D 1E F7 16           LEA    bx, [0x16f7] ; ADDR
04B3DE  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
04B3E3  E9 EC 05              JMP    0x4b9d2 ; JUMP
04B3E6  83 BE 46 FF 4B        CMP    word ptr [bp - 0xba], 0x4b ; CMP
04B3EB  7D 06                 JGE    0x4b3f3 ; CJUMP
04B3ED  83 7E 9C 40           CMP    word ptr [bp - 0x64], 0x40 ; CMP
04B3F1  7C 29                 JL     0x4b41c ; CJUMP
04B3F3  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04B3F6  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04B3FB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B3FE  50                    PUSH   ax ; STACK_PUSH
04B3FF  6A 00                 PUSH   0 ; STACK_PUSH
04B401  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04B406  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B409  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04B40D  68 05 17              PUSH   0x1705                       ; STRING: "MADATSHIPS"
04B410  9A 9C 01 1F 19        LCALL  0x191f, 0x19c ; THUNK -> 0x0000:0x3760 (thunk @file 0x01B78C type A) overlay @file 0x029060
04B415  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B418  E9 B7 05              JMP    0x4b9d2 ; JUMP
04B41B  90                    NOP ; NOP
04B41C  83 7E 98 04           CMP    word ptr [bp - 0x68], 4 ; CMP
04B420  7D 0E                 JGE    0x4b430 ; CJUMP
04B422  6B 5E 98 34           IMUL   bx, word ptr [bp - 0x68], 0x34 ; ARITH
04B426  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04B42B  75 03                 JNE    0x4b430 ; CJUMP
04B42D  E9 3A 01              JMP    0x4b56a ; JUMP
04B430  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B434  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
04B438  2A E4                 SUB    ah, ah ; ARITH
04B43A  E9 07 01              JMP    0x4b544 ; JUMP
04B43D  90                    NOP ; NOP
04B43E  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
04B442  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04B446  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04B44B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B44E  3D 4B 00              CMP    ax, 0x4b ; CMP
04B451  7D 5B                 JGE    0x4b4ae ; CJUMP
04B453  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04B456  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
04B45A  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
04B45F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B462  A8 20                 TEST   al, 0x20 ; LOGIC
04B464  74 48                 JE     0x4b4ae ; CJUMP
04B466  8B 1E 98 53           MOV    bx, word ptr [0x5398] ; GLOBAL_LOAD
04B46A  8A 87 7C 91           MOV    al, byte ptr [bx - 0x6e84] ; MOV
04B46E  8B 5E 98              MOV    bx, word ptr [bp - 0x68] ; LOCAL_LOAD
04B471  38 87 7C 91           CMP    byte ptr [bx - 0x6e84], al ; CMP
04B475  73 37                 JAE    0x4b4ae ; CJUMP
04B477  69 DB 3C 01           IMUL   bx, bx, 0x13c ; ARITH
04B47B  83 BF 34 88 00        CMP    word ptr [bx - 0x77cc], 0 ; CMP
04B480  7C 2C                 JL     0x4b4ae ; CJUMP
04B482  7F 08                 JG     0x4b48c ; CJUMP
04B484  81 BF 32 88 DC 05     CMP    word ptr [bx - 0x77ce], 0x5dc ; CMP
04B48A  72 22                 JB     0x4b4ae ; CJUMP
04B48C  6A 04                 PUSH   4 ; STACK_PUSH
04B48E  6A 00                 PUSH   0 ; STACK_PUSH
04B490  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04B495  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B498  0B C0                 OR     ax, ax ; LOGIC
04B49A  75 0A                 JNE    0x4b4a6 ; CJUMP
04B49C  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04B4A0  80 7F 05 00           CMP    byte ptr [bx + 5], 0 ; CMP
04B4A4  7C 08                 JL     0x4b4ae ; CJUMP
04B4A6  C7 46 AC 07 00        MOV    word ptr [bp - 0x54], 7 ; LOCAL_STORE
04B4AB  E9 41 04              JMP    0x4b8ef ; JUMP
04B4AE  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04B4B2  80 7F 05 00           CMP    byte ptr [bx + 5], 0 ; CMP
04B4B6  7D 08                 JGE    0x4b4c0 ; CJUMP
04B4B8  C7 46 AC 03 00        MOV    word ptr [bp - 0x54], 3 ; LOCAL_STORE
04B4BD  E9 2F 04              JMP    0x4b8ef ; JUMP
04B4C0  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
04B4C3  25 0F 00              AND    ax, 0xf ; LOGIC
04B4C6  3B 46 98              CMP    ax, word ptr [bp - 0x68] ; CMP
04B4C9  75 03                 JNE    0x4b4ce ; CJUMP
04B4CB  E9 04 05              JMP    0x4b9d2 ; JUMP
04B4CE  C7 46 AC 04 00        MOV    word ptr [bp - 0x54], 4 ; LOCAL_STORE
04B4D3  E9 19 04              JMP    0x4b8ef ; JUMP
04B4D6  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1 ; LOCAL_STORE
04B4DB  E9 11 04              JMP    0x4b8ef ; JUMP
04B4DE  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B4E2  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
04B4E6  2A E4                 SUB    ah, ah ; ARITH
04B4E8  50                    PUSH   ax ; STACK_PUSH
04B4E9  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
04B4ED  50                    PUSH   ax ; STACK_PUSH
04B4EE  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04B4F3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04B4F6  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
04B4F9  C7 46 AC 09 00        MOV    word ptr [bp - 0x54], 9 ; LOCAL_STORE
04B4FE  E9 EE 03              JMP    0x4b8ef ; JUMP
04B501  90                    NOP ; NOP
04B502  C7 46 AC 06 00        MOV    word ptr [bp - 0x54], 6 ; LOCAL_STORE
04B507  E9 E5 03              JMP    0x4b8ef ; JUMP
04B50A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04B50D  9A 78 0B 1F 18        LCALL  0x181f, 0xb78 ; THUNK -> 0x05EB:0x0902 (thunk @file 0x01B168 type B) overlay @file 0x0278F2
04B512  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B515  0B C0                 OR     ax, ax ; LOGIC
04B517  7D 03                 JGE    0x4b51c ; CJUMP
04B519  E9 B6 04              JMP    0x4b9d2 ; JUMP
04B51C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04B520  80 BF 5B 31 1C        CMP    byte ptr [bx + 0x315b], 0x1c ; CMP
04B525  74 0A                 JE     0x4b531 ; CJUMP
04B527  80 BF 5B 31 19        CMP    byte ptr [bx + 0x315b], 0x19 ; CMP
04B52C  74 03                 JE     0x4b531 ; CJUMP
04B52E  E9 A1 04              JMP    0x4b9d2 ; JUMP
04B531  83 BE 46 FF 4B        CMP    word ptr [bp - 0xba], 0x4b ; CMP
04B536  7C 03                 JL     0x4b53b ; CJUMP
04B538  E9 97 04              JMP    0x4b9d2 ; JUMP
04B53B  C7 46 AC 05 00        MOV    word ptr [bp - 0x54], 5 ; LOCAL_STORE
04B540  E9 AC 03              JMP    0x4b8ef ; JUMP
04B543  90                    NOP ; NOP
04B544  48                    DEC    ax ; ARITH
04B545  3D 0B 00              CMP    ax, 0xb ; CMP
04B548  77 C0                 JA     0x4b50a ; CJUMP
04B54A  D1 E0                 SHL    ax, 1 ; LOGIC
04B54C  93                    XCHG   bx, ax ; MOV
04B54D  2E FF A7 72 47        JMP    word ptr cs:[bx + 0x4772] ; JUMP
04B552  FE 46 2A              INC    byte ptr [bp + 0x2a] ; ARITH
04B555  47                    INC    di ; ARITH
04B556  5E                    POP    si ; STACK_POP
04B557  46                    INC    si ; ARITH
04B558  FE 46 22              INC    byte ptr [bp + 0x22] ; ARITH
04B55B  47                    INC    di ; ARITH
04B55C  2A 47 2A              SUB    al, byte ptr [bx + 0x2a] ; ARITH
04B55F  47                    INC    di ; ARITH
04B560  2A 47 2A              SUB    al, byte ptr [bx + 0x2a] ; ARITH
04B563  47                    INC    di ; ARITH
04B564  2A 47 FE              SUB    al, byte ptr [bx - 2] ; ARITH
04B567  46                    INC    si ; ARITH
04B568  F6 46 6A 07           TEST   byte ptr [bp + 0x6a], 7 ; LOGIC
04B56C  9A 24 05 1F 18        LCALL  0x181f, 0x524 ; THUNK -> 0x02FD:0x006C (thunk @file 0x01AB14 type B) overlay @file 0x0287EA
04B571  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04B574  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
04B578  8A 5F 02              MOV    bl, byte ptr [bx + 2] ; MOV
04B57B  2A FF                 SUB    bh, bh ; ARITH
04B57D  8B C3                 MOV    ax, bx ; MOV
