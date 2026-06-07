; ============================================================================
; func_02D3C6_unknown
; Region   : overlay
; Bytes    : file 0x02D3C6..0x02D4F8  (306 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D3C6  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
02D3CA  56                    PUSH   si ; STACK_PUSH
02D3CB  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
02D3D0  B8 01 00              MOV    ax, 1 ; MOV
02D3D3  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02D3D6  50                    PUSH   ax ; STACK_PUSH
02D3D7  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
02D3DC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D3DF  0B C0                 OR     ax, ax ; LOGIC
02D3E1  74 0B                 JE     0x2d3ee ; CJUMP
02D3E3  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
02D3E8  A1 8E 8F              MOV    ax, word ptr [0x8f8e] ; GLOBAL_LOAD
02D3EB  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
02D3EE  6A 02                 PUSH   2 ; STACK_PUSH
02D3F0  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
02D3F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D3F8  0B C0                 OR     ax, ax ; LOGIC
02D3FA  74 09                 JE     0x2d405 ; CJUMP
02D3FC  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
02D3FF  A1 9A 8F              MOV    ax, word ptr [0x8f9a] ; GLOBAL_LOAD
02D402  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
02D405  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D409  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
02D40C  2A E4                 SUB    ah, ah ; ARITH
02D40E  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02D411  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a] ; MOV
02D414  2A ED                 SUB    ch, ch ; ARITH
02D416  89 4E E6              MOV    word ptr [bp - 0x1a], cx ; LOCAL_STORE
02D419  8B D0                 MOV    dx, ax ; MOV
02D41B  8A 07                 MOV    al, byte ptr [bx] ; MOV
02D41D  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
02D420  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
02D425  EB 13                 JMP    0x2d43a ; JUMP
02D427  90                    NOP ; NOP
02D428  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
02D42B  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
02D430  75 03                 JNE    0x2d435 ; CJUMP
02D432  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
02D435  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
02D43A  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
02D43D  0B C0                 OR     ax, ax ; LOGIC
02D43F  7D E7                 JGE    0x2d428 ; CJUMP
02D441  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
02D444  F7 6E F6              IMUL   word ptr [bp - 0xa] ; ARITH
02D447  C1 E0 02              SHL    ax, 2 ; LOGIC
02D44A  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
02D44D  0B C0                 OR     ax, ax ; LOGIC
02D44F  75 03                 JNE    0x2d454 ; CJUMP
02D451  E9 AE 01              JMP    0x2d602 ; JUMP
02D454  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
02D459  EB 2B                 JMP    0x2d486 ; JUMP
02D45B  90                    NOP ; NOP
02D45C  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
02D460  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
02D465  72 07                 JB     0x2d46e ; CJUMP
02D467  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
02D46C  76 0F                 JBE    0x2d47d ; CJUMP
02D46E  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
02D471  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
02D476  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
02D479  0B C0                 OR     ax, ax ; LOGIC
02D47B  7D DF                 JGE    0x2d45c ; CJUMP
02D47D  83 7E E8 00           CMP    word ptr [bp - 0x18], 0 ; CMP
02D481  7D 41                 JGE    0x2d4c4 ; CJUMP
02D483  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
02D486  83 7E F4 08           CMP    word ptr [bp - 0xc], 8 ; CMP
02D48A  7C 03                 JL     0x2d48f ; CJUMP
02D48C  E9 73 01              JMP    0x2d602 ; JUMP
02D48F  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
02D492  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
02D496  98                    CWDE ; ARITH
02D497  03 46 EC              ADD    ax, word ptr [bp - 0x14] ; ARITH
02D49A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02D49D  50                    PUSH   ax ; STACK_PUSH
02D49E  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
02D4A2  98                    CWDE ; ARITH
02D4A3  03 46 EE              ADD    ax, word ptr [bp - 0x12] ; ARITH
02D4A6  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02D4A9  50                    PUSH   ax ; STACK_PUSH
02D4AA  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
02D4AF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D4B2  0B C0                 OR     ax, ax ; LOGIC
02D4B4  74 CD                 JE     0x2d483 ; CJUMP
02D4B6  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02D4B9  8B 56 F8              MOV    dx, word ptr [bp - 8] ; LOCAL_LOAD
02D4BC  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
02D4C1  EB B3                 JMP    0x2d476 ; JUMP
02D4C3  90                    NOP ; NOP
02D4C4  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
02D4C8  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
02D4CC  25 0F 00              AND    ax, 0xf ; LOGIC
02D4CF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02D4D2  3B 46 E6              CMP    ax, word ptr [bp - 0x1a] ; CMP
02D4D5  74 AC                 JE     0x2d483 ; CJUMP
02D4D7  50                    PUSH   ax ; STACK_PUSH
02D4D8  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
02D4DB  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
02D4E0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02D4E3  A8 40                 TEST   al, 0x40 ; LOGIC
02D4E5  74 0B                 JE     0x2d4f2 ; CJUMP
02D4E7  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
02D4EB  80 BF 46 31 10        CMP    byte ptr [bx + 0x3146], 0x10 ; CMP
02D4F0  75 91                 JNE    0x2d483 ; CJUMP
02D4F2  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; ARITH
02D4F6  8B C3                 MOV    ax, bx ; MOV
