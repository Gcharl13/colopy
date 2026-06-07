; ============================================================================
; func_024342_unknown
; Region   : overlay
; Bytes    : file 0x024342..0x02455A  (536 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024342  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
024346  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0 ; LOCAL_STORE
02434B  A1 28 93              MOV    ax, word ptr [0x9328] ; GLOBAL_LOAD
02434E  39 06 3E 93           CMP    word ptr [0x933e], ax ; CMP
024352  74 03                 JE     0x24357 ; CJUMP
024354  E9 69 02              JMP    0x245c0 ; JUMP
024357  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
02435C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02435F  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
024362  83 3E EC 07 00        CMP    word ptr [0x7ec], 0 ; CMP
024367  74 10                 JE     0x24379 ; CJUMP
024369  C6 06 94 0B 00        MOV    byte ptr [0xb94], 0 ; GLOBAL_LOAD
02436E  A3 0A 2D              MOV    word ptr [0x2d0a], ax ; GLOBAL_LOAD
024371  89 16 0C 2D           MOV    word ptr [0x2d0c], dx ; GLOBAL_LOAD
024375  0E                    PUSH   cs ; STACK_PUSH
024376  E8 45 08              CALL   0x24bbe ; CALL_NEAR
024379  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02437E  75 03                 JNE    0x24383 ; CJUMP
024380  E9 39 02              JMP    0x245bc ; JUMP
024383  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
024388  75 12                 JNE    0x2439c ; CJUMP
02438A  83 3E E4 07 00        CMP    word ptr [0x7e4], 0 ; CMP
02438F  74 0B                 JE     0x2439c ; CJUMP
024391  80 3E 94 0B 00        CMP    byte ptr [0xb94], 0 ; CMP
024396  75 04                 JNE    0x2439c ; CJUMP
024398  0E                    PUSH   cs ; STACK_PUSH
024399  E8 09 08              CALL   0x24ba5 ; CALL_NEAR
02439C  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
0243A1  75 27                 JNE    0x243ca ; CJUMP
0243A3  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0243A6  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
0243A9  2B 06 0A 2D           SUB    ax, word ptr [0x2d0a] ; ARITH
0243AD  1B 16 0C 2D           SBB    dx, word ptr [0x2d0c] ; ARITH
0243B1  0B D2                 OR     dx, dx ; LOGIC
0243B3  7C 15                 JL     0x243ca ; CJUMP
0243B5  7F 05                 JG     0x243bc ; CJUMP
0243B7  3D 14 00              CMP    ax, 0x14 ; CMP
0243BA  76 0E                 JBE    0x243ca ; CJUMP
0243BC  C6 06 94 0B 01        MOV    byte ptr [0xb94], 1 ; GLOBAL_LOAD
0243C1  6A 02                 PUSH   2 ; STACK_PUSH
0243C3  0E                    PUSH   cs ; STACK_PUSH
0243C4  E8 E8 07              CALL   0x24baf ; CALL_NEAR
0243C7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0243CA  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
0243CD  2D 08 00              SUB    ax, 8 ; ARITH
0243D0  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
0243D3  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
0243D6  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
0243DA  BB 10 00              MOV    bx, 0x10 ; CONST_LOAD
0243DD  D3 FB                 SAR    bx, cl ; LOGIC
0243DF  99                    CDQ ; ARITH
0243E0  F7 FB                 IDIV   bx ; ARITH
0243E2  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0243E5  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
0243E8  99                    CDQ ; ARITH
0243E9  F7 FB                 IDIV   bx ; ARITH
0243EB  8B 4E F4              MOV    cx, word ptr [bp - 0xc] ; LOCAL_LOAD
0243EE  2B 0E 2A 83           SUB    cx, word ptr [0x832a] ; ARITH
0243F2  03 0E 28 83           ADD    cx, word ptr [0x8328] ; ARITH
0243F6  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
0243F9  2B 06 2C 83           SUB    ax, word ptr [0x832c] ; ARITH
0243FD  03 06 2E 83           ADD    ax, word ptr [0x832e] ; ARITH
024401  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
024404  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
024409  75 37                 JNE    0x24442 ; CJUMP
02440B  3B 0E 40 85           CMP    cx, word ptr [0x8540] ; CMP
02440F  75 06                 JNE    0x24417 ; CJUMP
024411  3B 06 3E 85           CMP    ax, word ptr [0x853e] ; CMP
024415  74 2B                 JE     0x24442 ; CJUMP
024417  83 3E 9C 92 00        CMP    word ptr [0x929c], 0 ; CMP
02441C  74 05                 JE     0x24423 ; CJUMP
02441E  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
024423  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
024426  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
024429  9A B8 0D 1F 18        LCALL  0x181f, 0xdb8 ; THUNK -> 0x0984:0x00E8 (thunk @file 0x01B3A8 type B) overlay @file 0x031FFE
02442E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
024431  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
024436  6A 00                 PUSH   0 ; STACK_PUSH
024438  6A 01                 PUSH   1 ; STACK_PUSH
02443A  9A 5E 05 1F 18        LCALL  0x181f, 0x55e ; THUNK -> 0x0000:0x0424 (thunk @file 0x01AB4E type A) overlay @file 0x025D24
02443F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
024442  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
024447  75 03                 JNE    0x2444c ; CJUMP
024449  E9 C5 00              JMP    0x24511 ; JUMP
02444C  80 3E 94 0B 00        CMP    byte ptr [0xb94], 0 ; CMP
024451  75 03                 JNE    0x24456 ; CJUMP
024453  E9 BB 00              JMP    0x24511 ; JUMP
024456  C7 46 E6 01 00        MOV    word ptr [bp - 0x1a], 1 ; LOCAL_STORE
02445B  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
02445E  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
024461  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
024464  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
024468  2A E4                 SUB    ah, ah ; ARITH
02446A  2B 46 F6              SUB    ax, word ptr [bp - 0xa] ; ARITH
02446D  F7 D8                 NEG    ax ; ARITH
02446F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
024472  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
024476  2A E4                 SUB    ah, ah ; ARITH
024478  2B 46 F2              SUB    ax, word ptr [bp - 0xe] ; ARITH
02447B  F7 D8                 NEG    ax ; ARITH
02447D  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
024480  0E                    PUSH   cs ; STACK_PUSH
024481  E8 3A 07              CALL   0x24bbe ; CALL_NEAR
024484  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
024488  7E 06                 JLE    0x24490 ; CJUMP
02448A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
02448D  EB 07                 JMP    0x24496 ; JUMP
02448F  90                    NOP ; NOP
024490  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
024493  F7 D0                 NOT    ax ; LOGIC
024495  40                    INC    ax ; ARITH
024496  3D 01 00              CMP    ax, 1 ; CMP
024499  7F 5F                 JG     0x244fa ; CJUMP
02449B  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
02449F  7E 05                 JLE    0x244a6 ; CJUMP
0244A1  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0244A4  EB 06                 JMP    0x244ac ; JUMP
0244A6  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0244A9  F7 D0                 NOT    ax ; LOGIC
0244AB  40                    INC    ax ; ARITH
0244AC  3D 01 00              CMP    ax, 1 ; CMP
0244AF  7F 49                 JG     0x244fa ; CJUMP
0244B1  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0244B5  75 06                 JNE    0x244bd ; CJUMP
0244B7  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0244BB  74 3D                 JE     0x244fa ; CJUMP
0244BD  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0244C1  7E 05                 JLE    0x244c8 ; CJUMP
0244C3  B8 01 00              MOV    ax, 1 ; MOV
0244C6  EB 0D                 JMP    0x244d5 ; JUMP
0244C8  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
0244CC  7C 04                 JL     0x244d2 ; CJUMP
0244CE  2B C0                 SUB    ax, ax ; ARITH
0244D0  EB 03                 JMP    0x244d5 ; JUMP
0244D2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0244D5  50                    PUSH   ax ; STACK_PUSH
0244D6  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0244DA  7E 06                 JLE    0x244e2 ; CJUMP
0244DC  B8 01 00              MOV    ax, 1 ; MOV
0244DF  EB 0E                 JMP    0x244ef ; JUMP
0244E1  90                    NOP ; NOP
0244E2  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0244E6  7C 04                 JL     0x244ec ; CJUMP
0244E8  2B C0                 SUB    ax, ax ; ARITH
0244EA  EB 03                 JMP    0x244ef ; JUMP
0244EC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0244EF  50                    PUSH   ax ; STACK_PUSH
0244F0  9A 4E 04 1F 19        LCALL  0x191f, 0x44e ; THUNK -> 0x0000:0x049E (thunk @file 0x01BA3E type A) overlay @file 0x025D9E
0244F5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0244F8  EB 17                 JMP    0x24511 ; JUMP
0244FA  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
0244FE  C6 87 4C 31 03        MOV    byte ptr [bx + 0x314c], 3 ; MOV
024503  8A 46 F6              MOV    al, byte ptr [bp - 0xa] ; LOCAL_LOAD
024506  88 87 4D 31           MOV    byte ptr [bx + 0x314d], al ; MOV
02450A  8A 46 F2              MOV    al, byte ptr [bp - 0xe] ; LOCAL_LOAD
02450D  88 87 4E 31           MOV    byte ptr [bx + 0x314e], al ; MOV
024511  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
024516  75 03                 JNE    0x2451b ; CJUMP
024518  E9 A1 00              JMP    0x245bc ; JUMP
02451B  80 3E 94 0B 00        CMP    byte ptr [0xb94], 0 ; CMP
024520  74 03                 JE     0x24525 ; CJUMP
024522  E9 97 00              JMP    0x245bc ; JUMP
024525  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
02452A  1B C0                 SBB    ax, ax ; ARITH
02452C  F7 D8                 NEG    ax ; ARITH
02452E  3B 06 9C 92           CMP    ax, word ptr [0x929c] ; CMP
024532  75 05                 JNE    0x24539 ; CJUMP
024534  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
024539  83 3E E4 07 00        CMP    word ptr [0x7e4], 0 ; CMP
02453E  75 66                 JNE    0x245a6 ; CJUMP
024540  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
024543  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
024546  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
02454B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02454E  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
024551  0B C0                 OR     ax, ax ; LOGIC
024553  7C 21                 JL     0x24576 ; CJUMP
024555  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
024559  A0                    DB     0xA0 ; DATA_BYTE
