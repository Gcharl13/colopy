; ============================================================================
; func_04E2D6_unknown
; Region   : overlay
; Bytes    : file 0x04E2D6..0x04E51E  (584 bytes)
; Purpose  : AI action dispatcher (11 sub-actions AI10..AI20)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

04E2D6  C8 EE 00 00           ENTER  0xee, 0 ; PROLOGUE
04E2DA  57                    PUSH   di ; STACK_PUSH
04E2DB  56                    PUSH   si ; STACK_PUSH
04E2DC  C7 86 4A FF 01 00     MOV    word ptr [bp - 0xb6], 1 ; LOCAL_STORE
04E2E2  2B C0                 SUB    ax, ax ; ARITH
04E2E4  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax ; LOCAL_STORE
04E2E8  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04E2EB  89 86 54 FF           MOV    word ptr [bp - 0xac], ax ; LOCAL_STORE
04E2EF  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04E2F3  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
04E2F7  25 0F 00              AND    ax, 0xf ; LOGIC
04E2FA  89 86 1C FF           MOV    word ptr [bp - 0xe4], ax ; LOCAL_STORE
04E2FE  80 BF 4C 31 00        CMP    byte ptr [bx + 0x314c], 0 ; CMP
04E303  74 18                 JE     0x4e31d ; CJUMP
04E305  80 BF 4C 31 05        CMP    byte ptr [bx + 0x314c], 5 ; CMP
04E30A  74 11                 JE     0x4e31d ; CJUMP
04E30C  80 BF 4C 31 06        CMP    byte ptr [bx + 0x314c], 6 ; CMP
04E311  74 0A                 JE     0x4e31d ; CJUMP
04E313  80 BF 4C 31 0A        CMP    byte ptr [bx + 0x314c], 0xa ; CMP
04E318  73 03                 JAE    0x4e31d ; CJUMP
04E31A  E9 4B 39              JMP    0x51c68 ; JUMP
04E31D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04E321  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
04E325  2A E4                 SUB    ah, ah ; ARITH
04E327  89 86 7A FF           MOV    word ptr [bp - 0x86], ax ; LOCAL_STORE
04E32B  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
04E32F  2A ED                 SUB    ch, ch ; ARITH
04E331  89 8E 6E FF           MOV    word ptr [bp - 0x92], cx ; LOCAL_STORE
04E335  C7 46 8C 08 00        MOV    word ptr [bp - 0x74], 8 ; LOCAL_STORE
04E33A  8A 97 46 31           MOV    dl, byte ptr [bx + 0x3146] ; MOV
04E33E  2A F6                 SUB    dh, dh ; ARITH
04E340  89 56 9E              MOV    word ptr [bp - 0x62], dx ; LOCAL_STORE
04E343  51                    PUSH   cx ; STACK_PUSH
04E344  50                    PUSH   ax ; STACK_PUSH
04E345  8B F3                 MOV    si, bx ; MOV
04E347  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
04E34C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E34F  0B C0                 OR     ax, ax ; LOGIC
04E351  75 09                 JNE    0x4e35c ; CJUMP
04E353  C6 84 4B 31 40        MOV    byte ptr [si + 0x314b], 0x40 ; CONST_LOAD
04E358  E9 0D 39              JMP    0x51c68 ; JUMP
04E35B  90                    NOP ; NOP
04E35C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04E360  80 BF 4B 31 74        CMP    byte ptr [bx + 0x314b], 0x74 ; CMP
04E365  74 07                 JE     0x4e36e ; CJUMP
04E367  80 BF 4B 31 69        CMP    byte ptr [bx + 0x314b], 0x69 ; CMP
04E36C  75 08                 JNE    0x4e376 ; CJUMP
04E36E  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
04E373  EB 06                 JMP    0x4e37b ; JUMP
04E375  90                    NOP ; NOP
04E376  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
04E37B  FF B6 1C FF           PUSH   word ptr [bp - 0xe4] ; PUSH_GLOBAL
04E37F  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E383  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E387  9A 52 09 1F 18        LCALL  0x181f, 0x952 ; THUNK -> 0x0427:0x0BCE (thunk @file 0x01AF42 type B) overlay @file 0x0318E2
04E38C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04E38F  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
04E392  6A FF                 PUSH   -1 ; STACK_PUSH
04E394  6A FF                 PUSH   -1 ; STACK_PUSH
04E396  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E39A  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E39E  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
04E3A3  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04E3A6  89 86 1E FF           MOV    word ptr [bp - 0xe2], ax ; LOCAL_STORE
04E3AA  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
04E3AD  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
04E3B0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
04E3B4  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
04E3B7  2A E4                 SUB    ah, ah ; ARITH
04E3B9  50                    PUSH   ax ; STACK_PUSH
04E3BA  8A 07                 MOV    al, byte ptr [bx] ; MOV
04E3BC  50                    PUSH   ax ; STACK_PUSH
04E3BD  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04E3C2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E3C5  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
04E3C8  6A FF                 PUSH   -1 ; STACK_PUSH
04E3CA  FF B6 1C FF           PUSH   word ptr [bp - 0xe4] ; PUSH_GLOBAL
04E3CE  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E3D2  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E3D6  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
04E3DB  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04E3DE  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
04E3E1  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
04E3E4  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
04E3E7  83 7E A0 00           CMP    word ptr [bp - 0x60], 0 ; CMP
04E3EB  7C 1B                 JL     0x4e408 ; CJUMP
04E3ED  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
04E3F1  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
04E3F4  2A E4                 SUB    ah, ah ; ARITH
04E3F6  50                    PUSH   ax ; STACK_PUSH
04E3F7  8A 07                 MOV    al, byte ptr [bx] ; MOV
04E3F9  50                    PUSH   ax ; STACK_PUSH
04E3FA  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04E3FF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E402  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
04E405  EB 06                 JMP    0x4e40d ; JUMP
04E407  90                    NOP ; NOP
04E408  C7 46 D6 FE FF        MOV    word ptr [bp - 0x2a], 0xfffe ; LOCAL_STORE
04E40D  6A FF                 PUSH   -1 ; STACK_PUSH
04E40F  6A FF                 PUSH   -1 ; STACK_PUSH
04E411  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E415  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E419  9A 84 0D 1F 18        LCALL  0x181f, 0xd84 ; THUNK -> 0x0000:0x0356 (thunk @file 0x01B374 type A) overlay @file 0x025C56
04E41E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04E421  89 86 56 FF           MOV    word ptr [bp - 0xaa], ax ; LOCAL_STORE
04E425  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
04E428  89 86 62 FF           MOV    word ptr [bp - 0x9e], ax ; LOCAL_STORE
04E42C  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04E430  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
04E433  2A E4                 SUB    ah, ah ; ARITH
04E435  50                    PUSH   ax ; STACK_PUSH
04E436  8A 07                 MOV    al, byte ptr [bx] ; MOV
04E438  50                    PUSH   ax ; STACK_PUSH
04E439  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04E43E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E441  89 86 64 FF           MOV    word ptr [bp - 0x9c], ax ; LOCAL_STORE
04E445  FF B6 1C FF           PUSH   word ptr [bp - 0xe4] ; PUSH_GLOBAL
04E449  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04E44D  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04E452  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E455  50                    PUSH   ax ; STACK_PUSH
04E456  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
04E45B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04E45E  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
04E461  8B B6 1C FF           MOV    si, word ptr [bp - 0xe4] ; LOCAL_LOAD
04E465  D1 E6                 SHL    si, 1 ; LOGIC
04E467  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
04E46B  8B 40 0A              MOV    ax, word ptr [bx + si + 0xa] ; MOV
04E46E  89 46 C4              MOV    word ptr [bp - 0x3c], ax ; LOCAL_STORE
04E471  6A FE                 PUSH   -2 ; STACK_PUSH
04E473  FF B6 1C FF           PUSH   word ptr [bp - 0xe4] ; PUSH_GLOBAL
04E477  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E47B  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E47F  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
04E484  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04E487  89 46 B0              MOV    word ptr [bp - 0x50], ax ; LOCAL_STORE
04E48A  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
04E48D  89 46 C6              MOV    word ptr [bp - 0x3a], ax ; LOCAL_STORE
04E490  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04E494  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
04E499  72 0F                 JB     0x4e4aa ; CJUMP
04E49B  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
04E4A0  77 08                 JA     0x4e4aa ; CJUMP
04E4A2  C7 46 CE 01 00        MOV    word ptr [bp - 0x32], 1 ; LOCAL_STORE
04E4A7  EB 06                 JMP    0x4e4af ; JUMP
04E4A9  90                    NOP ; NOP
04E4AA  C7 46 CE 00 00        MOV    word ptr [bp - 0x32], 0 ; LOCAL_STORE
04E4AF  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E4B3  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E4B7  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
04E4BC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E4BF  89 86 58 FF           MOV    word ptr [bp - 0xa8], ax ; LOCAL_STORE
04E4C3  3D 19 00              CMP    ax, 0x19 ; CMP
04E4C6  74 05                 JE     0x4e4cd ; CJUMP
04E4C8  3D 1A 00              CMP    ax, 0x1a ; CMP
04E4CB  75 09                 JNE    0x4e4d6 ; CJUMP
04E4CD  C7 86 72 FF 01 00     MOV    word ptr [bp - 0x8e], 1 ; LOCAL_STORE
04E4D3  EB 07                 JMP    0x4e4dc ; JUMP
04E4D5  90                    NOP ; NOP
04E4D6  C7 86 72 FF 00 00     MOV    word ptr [bp - 0x8e], 0 ; LOCAL_STORE
04E4DC  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E4E0  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E4E4  9A 2C 07 1F 18        LCALL  0x181f, 0x72c ; THUNK -> 0x037F:0x010E (thunk @file 0x01AD1C type B) overlay @file 0x02EC4A
04E4E9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E4EC  25 40 00              AND    ax, 0x40 ; LOGIC
04E4EF  89 86 7E FF           MOV    word ptr [bp - 0x82], ax ; LOCAL_STORE
04E4F3  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E4F7  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E4FB  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
04E500  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E503  25 0A 00              AND    ax, 0xa ; LOGIC
04E506  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
04E509  FF B6 6E FF           PUSH   word ptr [bp - 0x92] ; PUSH_GLOBAL
04E50D  FF B6 7A FF           PUSH   word ptr [bp - 0x86] ; PUSH_GLOBAL
04E511  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04E516  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04E519  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
04E51C  0B C0                 OR     ax, ax ; LOGIC
