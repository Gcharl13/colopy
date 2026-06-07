; ============================================================================
; func_00A994_unknown
; Region   : load_image
; Bytes    : file 0x00A994..0x00AAB9  (293 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A994  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
00A998  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A99C  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
00A99F  2A E4                 SUB    ah, ah ; ARITH
00A9A1  50                    PUSH   ax ; STACK_PUSH
00A9A2  8A 07                 MOV    al, byte ptr [bx] ; MOV
00A9A4  50                    PUSH   ax ; STACK_PUSH
00A9A5  9A A0 02 7F 03        LCALL  0x37f, 0x2a0 ; LCALL
00A9AA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A9AD  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00A9B0  0E                    PUSH   cs ; STACK_PUSH
00A9B1  E8 8A FF              CALL   0xa93e ; CALL_NEAR
00A9B4  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
00A9B9  E9 61 01              JMP    0xab1d ; JUMP
00A9BC  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
00A9BF  83 7E F4 05           CMP    word ptr [bp - 0xc], 5 ; CMP
00A9C3  7C 03                 JL     0xa9c8 ; CJUMP
00A9C5  E9 52 01              JMP    0xab1a ; JUMP
00A9C8  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00A9CD  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A9D1  8A 07                 MOV    al, byte ptr [bx] ; MOV
00A9D3  2A E4                 SUB    ah, ah ; ARITH
00A9D5  03 46 F4              ADD    ax, word ptr [bp - 0xc] ; ARITH
00A9D8  48                    DEC    ax ; ARITH
00A9D9  48                    DEC    ax ; ARITH
00A9DA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00A9DD  8A 4F 01              MOV    cl, byte ptr [bx + 1] ; MOV
00A9E0  2A ED                 SUB    ch, ch ; ARITH
00A9E2  03 4E F2              ADD    cx, word ptr [bp - 0xe] ; ARITH
00A9E5  49                    DEC    cx ; ARITH
00A9E6  49                    DEC    cx ; ARITH
00A9E7  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
00A9EA  51                    PUSH   cx ; STACK_PUSH
00A9EB  50                    PUSH   ax ; STACK_PUSH
00A9EC  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00A9F1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A9F4  0B C0                 OR     ax, ax ; LOGIC
00A9F6  74 35                 JE     0xaa2d ; CJUMP
00A9F8  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00A9FB  6A FF                 PUSH   -1 ; STACK_PUSH
00A9FD  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00AA00  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00AA03  9A 84 0D 1F 18        LCALL  0x181f, 0xd84 ; THUNK -> 0x0000:0x0356 (thunk @file 0x01B374 type A) overlay @file 0x025C56
00AA08  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00AA0B  0B C0                 OR     ax, ax ; LOGIC
00AA0D  7C 1E                 JL     0xaa2d ; CJUMP
00AA0F  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
00AA13  9A 6A 00 DC 05        LCALL  0x5dc, 0x6a ; LCALL
00AA18  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00AA1B  39 06 B8 8D           CMP    word ptr [0x8db8], ax ; CMP
00AA1F  7F 0C                 JG     0xaa2d ; CJUMP
00AA21  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
00AA25  8A 47 02              MOV    al, byte ptr [bx + 2] ; MOV
00AA28  2A E4                 SUB    ah, ah ; ARITH
00AA2A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00AA2D  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
00AA30  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
00AA33  0E                    PUSH   cs ; STACK_PUSH
00AA34  E8 1F DF              CALL   0x8956 ; CALL_NEAR
00AA37  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00AA3A  0A C0                 OR     al, al ; LOGIC
00AA3C  7C 05                 JL     0xaa43 ; CJUMP
00AA3E  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00AA43  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00AA46  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00AA49  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
00AA4E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00AA51  0B C0                 OR     ax, ax ; LOGIC
00AA53  74 05                 JE     0xaa5a ; CJUMP
00AA55  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00AA5A  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
00AA5D  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
00AA60  0E                    PUSH   cs ; STACK_PUSH
00AA61  E8 6C DE              CALL   0x88d0 ; CALL_NEAR
00AA64  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00AA67  0B C0                 OR     ax, ax ; LOGIC
00AA69  74 05                 JE     0xaa70 ; CJUMP
00AA6B  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00AA70  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
00AA74  7C 1E                 JL     0xaa94 ; CJUMP
00AA76  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00AA79  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00AA7D  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00AA80  2A E4                 SUB    ah, ah ; ARITH
00AA82  50                    PUSH   ax ; STACK_PUSH
00AA83  9A 04 00 B3 05        LCALL  0x5b3, 4 ; LCALL
00AA88  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00AA8B  A8 20                 TEST   al, 0x20 ; LOGIC
00AA8D  75 05                 JNE    0xaa94 ; CJUMP
00AA8F  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00AA94  6A 02                 PUSH   2 ; STACK_PUSH
00AA96  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00AA9A  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00AA9D  2A E4                 SUB    ah, ah ; ARITH
00AA9F  50                    PUSH   ax ; STACK_PUSH
00AAA0  9A 00 00 81 09        LCALL  0x981, 0 ; LCALL
00AAA5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00AAA8  0B C0                 OR     ax, ax ; LOGIC
00AAAA  74 05                 JE     0xaab1 ; CJUMP
00AAAC  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
00AAB1  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
00AAB4  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
00AAB7  8B CB                 MOV    cx, bx ; MOV
