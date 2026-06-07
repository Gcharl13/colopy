; ============================================================================
; func_06B398_unknown
; Region   : overlay
; Bytes    : file 0x06B398..0x06B65F  (711 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B398  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
06B39C  56                    PUSH   si ; STACK_PUSH
06B39D  0E                    PUSH   cs ; STACK_PUSH
06B39E  E8 19 03              CALL   0x6b6ba ; CALL_NEAR
06B3A1  0B C0                 OR     ax, ax ; LOGIC
06B3A3  74 03                 JE     0x6b3a8 ; CJUMP
06B3A5  E9 B0 02              JMP    0x6b658 ; JUMP
06B3A8  83 7E 06 07           CMP    word ptr [bp + 6], 7 ; CMP
06B3AC  75 1C                 JNE    0x6b3ca ; CJUMP
06B3AE  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06B3B1  EB 04                 JMP    0x6b3b7 ; JUMP
06B3B3  90                    NOP ; NOP
06B3B4  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
06B3B7  83 7E F4 07           CMP    word ptr [bp - 0xc], 7 ; CMP
06B3BB  7D 17                 JGE    0x6b3d4 ; CJUMP
06B3BD  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
06B3C0  0E                    PUSH   cs ; STACK_PUSH
06B3C1  E8 E2 02              CALL   0x6b6a6 ; CALL_NEAR
06B3C4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06B3C7  EB EB                 JMP    0x6b3b4 ; JUMP
06B3C9  90                    NOP ; NOP
06B3CA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06B3CD  0E                    PUSH   cs ; STACK_PUSH
06B3CE  E8 D5 02              CALL   0x6b6a6 ; CALL_NEAR
06B3D1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06B3D4  83 3E AA A5 00        CMP    word ptr [0xa5aa], 0 ; CMP
06B3D9  75 03                 JNE    0x6b3de ; CJUMP
06B3DB  E9 7A 02              JMP    0x6b658 ; JUMP
06B3DE  2B C0                 SUB    ax, ax ; ARITH
06B3E0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B3E3  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06B3E6  A3 AC A5              MOV    word ptr [0xa5ac], ax ; GLOBAL_LOAD
06B3E9  0E                    PUSH   cs ; STACK_PUSH
06B3EA  E8 AA 02              CALL   0x6b697 ; CALL_NEAR
06B3ED  0E                    PUSH   cs ; STACK_PUSH
06B3EE  E8 A1 02              CALL   0x6b692 ; CALL_NEAR
06B3F1  6A 0F                 PUSH   0xf ; PUSH_CONST
06B3F3  6A 05                 PUSH   5 ; STACK_PUSH
06B3F5  68 40 01              PUSH   0x140 ; PUSH_CONST
06B3F8  6A 00                 PUSH   0 ; STACK_PUSH
06B3FA  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
06B3FE  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06B403  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06B406  52                    PUSH   dx ; STACK_PUSH
06B407  50                    PUSH   ax ; STACK_PUSH
06B408  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06B40D  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06B410  B8 01 00              MOV    ax, 1 ; MOV
06B413  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06B416  50                    PUSH   ax ; STACK_PUSH
06B417  6A 00                 PUSH   0 ; STACK_PUSH
06B419  0E                    PUSH   cs ; STACK_PUSH
06B41A  E8 7F 02              CALL   0x6b69c ; CALL_NEAR
06B41D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B420  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
06B425  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
06B42A  2B C0                 SUB    ax, ax ; ARITH
06B42C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06B42F  9A 66 04 1F 18        LCALL  0x181f, 0x466 ; THUNK -> 0x0ACB:0x0056 (thunk @file 0x01AA56 type B) overlay @file 0x0318F8
06B434  9A F6 00 1F 18        LCALL  0x181f, 0xf6 ; THUNK -> 0x0AE7:0x0002 (thunk @file 0x01A6E6 type B) overlay @file 0x026FF2
06B439  0B C0                 OR     ax, ax ; LOGIC
06B43B  74 33                 JE     0x6b470 ; CJUMP
06B43D  9A E0 03 1F 18        LCALL  0x181f, 0x3e0 ; THUNK -> 0x0AE7:0x0016 (thunk @file 0x01A9D0 type B) overlay @file 0x027006
06B442  3D 34 00              CMP    ax, 0x34 ; CMP
06B445  74 5D                 JE     0x6b4a4 ; CJUMP
06B447  7E 03                 JLE    0x6b44c ; CJUMP
06B449  E9 96 00              JMP    0x6b4e2 ; JUMP
06B44C  3D 32 00              CMP    ax, 0x32 ; CMP
06B44F  74 45                 JE     0x6b496 ; CJUMP
06B451  77 1D                 JA     0x6b470 ; CJUMP
06B453  2C 09                 SUB    al, 9 ; ARITH
06B455  74 67                 JE     0x6b4be ; CJUMP
06B457  2C 04                 SUB    al, 4 ; ARITH
06B459  74 7F                 JE     0x6b4da ; CJUMP
06B45B  2C 0E                 SUB    al, 0xe ; ARITH
06B45D  74 09                 JE     0x6b468 ; CJUMP
06B45F  2C 05                 SUB    al, 5 ; ARITH
06B461  74 77                 JE     0x6b4da ; CJUMP
06B463  EB 0B                 JMP    0x6b470 ; JUMP
06B465  90                    NOP ; NOP
06B466  90                    NOP ; NOP
06B467  90                    NOP ; NOP
06B468  2B C0                 SUB    ax, ax ; ARITH
06B46A  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06B46D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06B470  6B 06 AC A5 18        IMUL   ax, word ptr [0xa5ac], 0x18 ; ARITH
06B475  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
06B478  7F 03                 JG     0x6b47d ; CJUMP
06B47A  E9 94 00              JMP    0x6b511 ; JUMP
06B47D  FF 0E AC A5           DEC    word ptr [0xa5ac] ; ARITH
06B481  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
06B486  EB E8                 JMP    0x6b470 ; JUMP
06B488  FF 4E FC              DEC    word ptr [bp - 4] ; ARITH
06B48B  79 F4                 JNS    0x6b481 ; CJUMP
06B48D  A1 AA A5              MOV    ax, word ptr [0xa5aa] ; GLOBAL_LOAD
06B490  48                    DEC    ax ; ARITH
06B491  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B494  EB EB                 JMP    0x6b481 ; JUMP
06B496  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06B499  40                    INC    ax ; ARITH
06B49A  99                    CDQ ; ARITH
06B49B  F7 3E AA A5           IDIV   word ptr [0xa5aa] ; ARITH
06B49F  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06B4A2  EB DD                 JMP    0x6b481 ; JUMP
06B4A4  83 6E FC 18           SUB    word ptr [bp - 4], 0x18 ; ARITH
06B4A8  79 D7                 JNS    0x6b481 ; CJUMP
06B4AA  EB 03                 JMP    0x6b4af ; JUMP
06B4AC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B4AF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06B4B2  05 18 00              ADD    ax, 0x18 ; ARITH
06B4B5  3B 06 AA A5           CMP    ax, word ptr [0xa5aa] ; CMP
06B4B9  7C F1                 JL     0x6b4ac ; CJUMP
06B4BB  EB C4                 JMP    0x6b481 ; JUMP
06B4BD  90                    NOP ; NOP
06B4BE  A1 AA A5              MOV    ax, word ptr [0xa5aa] ; GLOBAL_LOAD
06B4C1  83 46 FC 18           ADD    word ptr [bp - 4], 0x18 ; ARITH
06B4C5  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
06B4C8  7E B7                 JLE    0x6b481 ; CJUMP
06B4CA  EB 03                 JMP    0x6b4cf ; JUMP
06B4CC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B4CF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06B4D2  2D 18 00              SUB    ax, 0x18 ; ARITH
06B4D5  79 F5                 JNS    0x6b4cc ; CJUMP
06B4D7  EB A8                 JMP    0x6b481 ; JUMP
06B4D9  90                    NOP ; NOP
06B4DA  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
06B4DF  EB 8F                 JMP    0x6b470 ; JUMP
06B4E1  90                    NOP ; NOP
06B4E2  3D 48 01              CMP    ax, 0x148 ; CMP
06B4E5  74 A1                 JE     0x6b488 ; CJUMP
06B4E7  7F 0D                 JG     0x6b4f6 ; CJUMP
06B4E9  2D 36 00              SUB    ax, 0x36 ; ARITH
06B4EC  74 D0                 JE     0x6b4be ; CJUMP
06B4EE  48                    DEC    ax ; ARITH
06B4EF  48                    DEC    ax ; ARITH
06B4F0  74 96                 JE     0x6b488 ; CJUMP
06B4F2  E9 7B FF              JMP    0x6b470 ; JUMP
06B4F5  90                    NOP ; NOP
06B4F6  2D 4B 01              SUB    ax, 0x14b ; ARITH
06B4F9  74 A9                 JE     0x6b4a4 ; CJUMP
06B4FB  48                    DEC    ax ; ARITH
06B4FC  48                    DEC    ax ; ARITH
06B4FD  74 BF                 JE     0x6b4be ; CJUMP
06B4FF  2D 03 00              SUB    ax, 3 ; ARITH
06B502  74 92                 JE     0x6b496 ; CJUMP
06B504  E9 69 FF              JMP    0x6b470 ; JUMP
06B507  90                    NOP ; NOP
06B508  FF 06 AC A5           INC    word ptr [0xa5ac] ; ARITH
06B50C  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
06B511  A1 AC A5              MOV    ax, word ptr [0xa5ac] ; GLOBAL_LOAD
06B514  05 03 00              ADD    ax, 3 ; ARITH
06B517  6B C0 18              IMUL   ax, ax, 0x18 ; ARITH
06B51A  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
06B51D  7E E9                 JLE    0x6b508 ; CJUMP
06B51F  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
06B524  74 7C                 JE     0x6b5a2 ; CJUMP
06B526  0E                    PUSH   cs ; STACK_PUSH
06B527  E8 86 01              CALL   0x6b6b0 ; CALL_NEAR
06B52A  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
06B52D  40                    INC    ax ; ARITH
06B52E  74 13                 JE     0x6b543 ; CJUMP
06B530  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06B533  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
06B536  74 0B                 JE     0x6b543 ; CJUMP
06B538  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
06B53B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06B53E  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
06B543  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
06B548  74 4A                 JE     0x6b594 ; CJUMP
06B54A  83 7E F2 FE           CMP    word ptr [bp - 0xe], -2 ; CMP
06B54E  75 34                 JNE    0x6b584 ; CJUMP
06B550  83 3E AA A5 48        CMP    word ptr [0xa5aa], 0x48 ; CMP
06B555  7E 3D                 JLE    0x6b594 ; CJUMP
06B557  A1 AC A5              MOV    ax, word ptr [0xa5ac] ; GLOBAL_LOAD
06B55A  05 03 00              ADD    ax, 3 ; ARITH
06B55D  6B C8 18              IMUL   cx, ax, 0x18 ; ARITH
06B560  3B 0E AA A5           CMP    cx, word ptr [0xa5aa] ; CMP
06B564  7D 06                 JGE    0x6b56c ; CJUMP
06B566  A3 AC A5              MOV    word ptr [0xa5ac], ax ; GLOBAL_LOAD
06B569  EB 07                 JMP    0x6b572 ; JUMP
06B56B  90                    NOP ; NOP
06B56C  C7 06 AC A5 00 00     MOV    word ptr [0xa5ac], 0 ; GLOBAL_LOAD
06B572  6B 06 AC A5 18        IMUL   ax, word ptr [0xa5ac], 0x18 ; ARITH
06B577  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06B57A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B57D  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
06B582  EB 10                 JMP    0x6b594 ; JUMP
06B584  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
06B589  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
06B58D  7D 05                 JGE    0x6b594 ; CJUMP
06B58F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
06B594  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
06B598  7C 0E                 JL     0x6b5a8 ; CJUMP
06B59A  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
06B59D  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06B5A0  EB 06                 JMP    0x6b5a8 ; JUMP
06B5A2  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06B5A5  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06B5A8  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
06B5AC  74 0C                 JE     0x6b5ba ; CJUMP
06B5AE  6A 01                 PUSH   1 ; STACK_PUSH
06B5B0  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
06B5B3  0E                    PUSH   cs ; STACK_PUSH
06B5B4  E8 E5 00              CALL   0x6b69c ; CALL_NEAR
06B5B7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B5BA  2B C0                 SUB    ax, ax ; ARITH
06B5BC  8B 56 F8              MOV    dx, word ptr [bp - 8] ; LOCAL_LOAD
06B5BF  9A 5C 04 1F 18        LCALL  0x181f, 0x45c ; THUNK -> 0x0ACB:0x011A (thunk @file 0x01AA4C type B) overlay @file 0x0319BC
06B5C4  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
06B5C8  74 03                 JE     0x6b5cd ; CJUMP
06B5CA  E9 5D FE              JMP    0x6b42a ; JUMP
06B5CD  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
06B5D1  75 03                 JNE    0x6b5d6 ; CJUMP
06B5D3  E9 82 00              JMP    0x6b658 ; JUMP
06B5D6  C4 1E AE 1E           LES    bx, ptr [0x1eae] ; MOV_FAR
06B5DA  8B 76 FC              MOV    si, word ptr [bp - 4] ; LOCAL_LOAD
06B5DD  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
06B5E0  2A E4                 SUB    ah, ah ; ARITH
06B5E2  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
06B5E5  C4 1E AA 1E           LES    bx, ptr [0x1eaa] ; MOV_FAR
06B5E9  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
06B5EC  EB 4C                 JMP    0x6b63a ; JUMP
06B5EE  90                    NOP ; NOP
06B5EF  90                    NOP ; NOP
06B5F0  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B5F3  0E                    PUSH   cs ; STACK_PUSH
06B5F4  E8 78 00              CALL   0x6b66f ; CALL_NEAR
06B5F7  EB 3A                 JMP    0x6b633 ; JUMP
06B5F9  90                    NOP ; NOP
06B5FA  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B5FD  0E                    PUSH   cs ; STACK_PUSH
06B5FE  E8 73 00              CALL   0x6b674 ; CALL_NEAR
06B601  EB 30                 JMP    0x6b633 ; JUMP
06B603  90                    NOP ; NOP
06B604  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B607  0E                    PUSH   cs ; STACK_PUSH
06B608  E8 55 00              CALL   0x6b660 ; CALL_NEAR
06B60B  EB 26                 JMP    0x6b633 ; JUMP
06B60D  90                    NOP ; NOP
06B60E  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B611  0E                    PUSH   cs ; STACK_PUSH
06B612  E8 50 00              CALL   0x6b665 ; CALL_NEAR
06B615  EB 1C                 JMP    0x6b633 ; JUMP
06B617  90                    NOP ; NOP
06B618  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B61B  0E                    PUSH   cs ; STACK_PUSH
06B61C  E8 4B 00              CALL   0x6b66a ; CALL_NEAR
06B61F  EB 12                 JMP    0x6b633 ; JUMP
06B621  90                    NOP ; NOP
06B622  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B625  0E                    PUSH   cs ; STACK_PUSH
06B626  E8 50 00              CALL   0x6b679 ; CALL_NEAR
06B629  EB 08                 JMP    0x6b633 ; JUMP
06B62B  90                    NOP ; NOP
06B62C  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06B62F  0E                    PUSH   cs ; STACK_PUSH
06B630  E8 55 00              CALL   0x6b688 ; CALL_NEAR
06B633  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06B636  E9 A5 FD              JMP    0x6b3de ; JUMP
06B639  90                    NOP ; NOP
06B63A  3D 06 00              CMP    ax, 6 ; CMP
06B63D  76 03                 JBE    0x6b642 ; CJUMP
06B63F  E9 9C FD              JMP    0x6b3de ; JUMP
06B642  D1 E0                 SHL    ax, 1 ; LOGIC
06B644  93                    XCHG   bx, ax ; MOV
06B645  2E FF A7 6A 27        JMP    word ptr cs:[bx + 0x276a] ; JUMP
06B64A  10 27                 ADC    byte ptr [bx], ah ; ARITH
06B64C  1A 27                 SBB    ah, byte ptr [bx] ; ARITH
06B64E  24 27                 AND    al, 0x27 ; LOGIC
06B650  2E 27                 DAA ; ARITH
06B652  38 27                 CMP    byte ptr [bx], ah ; CMP
06B654  42                    INC    dx ; ARITH
06B655  27                    DAA ; ARITH
06B656  4C                    DEC    sp ; ARITH
06B657  27                    DAA ; ARITH
06B658  0E                    PUSH   cs ; STACK_PUSH
06B659  E8 59 00              CALL   0x6b6b5 ; CALL_NEAR
06B65C  5E                    POP    si ; STACK_POP
06B65D  C9                    LEAVE ; EPILOGUE
06B65E  CB                    RETF ; RETURN
