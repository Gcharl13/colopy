; ============================================================================
; func_076642_unknown
; Region   : overlay
; Bytes    : file 0x076642..0x076AEC  (1194 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076642  C8 0E 02 00           ENTER  0x20e, 0 ; PROLOGUE
076646  50                    PUSH   ax ; STACK_PUSH
076647  53                    PUSH   bx ; STACK_PUSH
076648  57                    PUSH   di ; STACK_PUSH
076649  56                    PUSH   si ; STACK_PUSH
07664A  2B C0                 SUB    ax, ax ; ARITH
07664C  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
07664F  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
076652  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
076655  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
076658  89 86 FA FD           MOV    word ptr [bp - 0x206], ax ; LOCAL_STORE
07665C  89 86 F8 FD           MOV    word ptr [bp - 0x208], ax ; LOCAL_STORE
076660  89 86 E6 FE           MOV    word ptr [bp - 0x11a], ax ; LOCAL_STORE
076664  89 86 E4 FE           MOV    word ptr [bp - 0x11c], ax ; LOCAL_STORE
076668  C7 06 50 26 0D 00     MOV    word ptr [0x2650], 0xd ; GLOBAL_LOAD
07666E  89 86 1A FE           MOV    word ptr [bp - 0x1e6], ax ; LOCAL_STORE
076672  53                    PUSH   bx ; STACK_PUSH
076673  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
076676  50                    PUSH   ax ; STACK_PUSH
076677  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
07667C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07667F  6A 2E                 PUSH   0x2e ; PUSH_CONST
076681  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
076684  50                    PUSH   ax ; STACK_PUSH
076685  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
07668A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07668D  0B C0                 OR     ax, ax ; LOGIC
07668F  75 0F                 JNE    0x766a0 ; CJUMP
076691  68 E6 23              PUSH   0x23e6 ; PUSH_CONST
076694  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
076697  50                    PUSH   ax ; STACK_PUSH
076698  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
07669D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0766A0  68 EA 23              PUSH   0x23ea ; PUSH_CONST
0766A3  8D 86 04 FE           LEA    ax, [bp - 0x1fc] ; ADDR
0766A7  50                    PUSH   ax ; STACK_PUSH
0766A8  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0766AD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0766B0  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0766B3  89 86 18 FE           MOV    word ptr [bp - 0x1e8], ax ; LOCAL_STORE
0766B7  50                    PUSH   ax ; STACK_PUSH
0766B8  9A 64 0D 1D 0D        LCALL  0xd1d, 0xd64 ; LCALL
0766BD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0766C0  80 7E AE 2A           CMP    byte ptr [bp - 0x52], 0x2a ; CMP
0766C4  75 07                 JNE    0x766cd ; CJUMP
0766C6  8D 46 AF              LEA    ax, [bp - 0x51] ; ADDR
0766C9  89 86 18 FE           MOV    word ptr [bp - 0x1e8], ax ; LOCAL_STORE
0766CD  8B 9E 18 FE           MOV    bx, word ptr [bp - 0x1e8] ; LOCAL_LOAD
0766D1  80 3F 52              CMP    byte ptr [bx], 0x52 ; CMP
0766D4  75 0B                 JNE    0x766e1 ; CJUMP
0766D6  80 7F 01 4D           CMP    byte ptr [bx + 1], 0x4d ; CMP
0766DA  75 05                 JNE    0x766e1 ; CJUMP
0766DC  83 86 18 FE 02        ADD    word ptr [bp - 0x1e8], 2 ; ARITH
0766E1  6A 06                 PUSH   6 ; STACK_PUSH
0766E3  FF B6 18 FE           PUSH   word ptr [bp - 0x1e8] ; PUSH_GLOBAL
0766E7  8D 86 04 FE           LEA    ax, [bp - 0x1fc] ; ADDR
0766EB  50                    PUSH   ax ; STACK_PUSH
0766EC  9A 5E 08 1D 0D        LCALL  0xd1d, 0x85e ; LCALL
0766F1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0766F4  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
0766F8  16                    PUSH   ss ; STACK_PUSH
0766F9  50                    PUSH   ax ; STACK_PUSH
0766FA  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0766FD  16                    PUSH   ss ; STACK_PUSH
0766FE  50                    PUSH   ax ; STACK_PUSH
0766FF  8D 1E ED 23           LEA    bx, [0x23ed] ; ADDR
076703  B8 01 00              MOV    ax, 1 ; MOV
076706  9A 9E 0E 1F 1A        LCALL  0x1a1f, 0xe9e ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D48E type A) overlay @file 0x025900
07670B  0B C0                 OR     ax, ax ; LOGIC
07670D  74 09                 JE     0x76718 ; CJUMP
07670F  C7 06 F0 23 FF FF     MOV    word ptr [0x23f0], 0xffff ; GLOBAL_LOAD
076715  E9 61 03              JMP    0x76a79 ; JUMP
076718  C7 06 F0 23 FE FF     MOV    word ptr [0x23f0], 0xfffe ; GLOBAL_LOAD
07671E  C7 86 F2 FD 98 00     MOV    word ptr [bp - 0x20e], 0x98 ; LOCAL_STORE
076724  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
076728  16                    PUSH   ss ; STACK_PUSH
076729  50                    PUSH   ax ; STACK_PUSH
07672A  6A 00                 PUSH   0 ; STACK_PUSH
07672C  6A 01                 PUSH   1 ; STACK_PUSH
07672E  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
076732  16                    PUSH   ss ; STACK_PUSH
076733  50                    PUSH   ax ; STACK_PUSH
076734  B8 98 00              MOV    ax, 0x98 ; CONST_LOAD
076737  99                    CDQ ; ARITH
076738  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
07673D  0B D0                 OR     dx, ax ; LOGIC
07673F  75 03                 JNE    0x76744 ; CJUMP
076741  E9 35 03              JMP    0x76a79 ; JUMP
076744  8B 86 12 FF           MOV    ax, word ptr [bp - 0xee] ; LOCAL_LOAD
076748  C1 E0 04              SHL    ax, 4 ; LOGIC
07674B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
07674E  8B 86 12 FF           MOV    ax, word ptr [bp - 0xee] ; LOCAL_LOAD
076752  8B C8                 MOV    cx, ax ; MOV
076754  D1 E0                 SHL    ax, 1 ; LOGIC
076756  03 C1                 ADD    ax, cx ; ARITH
076758  C1 E0 02              SHL    ax, 2 ; LOGIC
07675B  05 42 00              ADD    ax, 0x42 ; ARITH
07675E  99                    CDQ ; ARITH
07675F  89 86 E8 FE           MOV    word ptr [bp - 0x118], ax ; LOCAL_STORE
076763  89 96 EA FE           MOV    word ptr [bp - 0x116], dx ; LOCAL_STORE
076767  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
07676A  89 56 9A              MOV    word ptr [bp - 0x66], dx ; LOCAL_STORE
07676D  89 86 F4 FD           MOV    word ptr [bp - 0x20c], ax ; LOCAL_STORE
076771  89 96 F6 FD           MOV    word ptr [bp - 0x20a], dx ; LOCAL_STORE
076775  F6 86 F0 FD 02        TEST   byte ptr [bp - 0x210], 2 ; LOGIC
07677A  75 15                 JNE    0x76791 ; CJUMP
07677C  80 BE EC FE 00        CMP    byte ptr [bp - 0x114], 0 ; CMP
076781  75 0E                 JNE    0x76791 ; CJUMP
076783  03 46 80              ADD    ax, word ptr [bp - 0x80] ; ARITH
076786  13 56 82              ADC    dx, word ptr [bp - 0x7e] ; ARITH
076789  89 86 F4 FD           MOV    word ptr [bp - 0x20c], ax ; LOCAL_STORE
07678D  89 96 F6 FD           MOV    word ptr [bp - 0x20a], dx ; LOCAL_STORE
076791  A1 F8 23              MOV    ax, word ptr [0x23f8] ; GLOBAL_LOAD
076794  0B 06 F6 23           OR     ax, word ptr [0x23f6] ; LOGIC
076798  74 22                 JE     0x767bc ; CJUMP
07679A  A1 1E A6              MOV    ax, word ptr [0xa61e] ; GLOBAL_LOAD
07679D  8B 16 20 A6           MOV    dx, word ptr [0xa620] ; GLOBAL_LOAD
0767A1  39 96 F6 FD           CMP    word ptr [bp - 0x20a], dx ; CMP
0767A5  7F 15                 JG     0x767bc ; CJUMP
0767A7  7C 06                 JL     0x767af ; CJUMP
0767A9  39 86 F4 FD           CMP    word ptr [bp - 0x20c], ax ; CMP
0767AD  77 0D                 JA     0x767bc ; CJUMP
0767AF  A1 F6 23              MOV    ax, word ptr [0x23f6] ; GLOBAL_LOAD
0767B2  8B 16 F8 23           MOV    dx, word ptr [0x23f8] ; GLOBAL_LOAD
0767B6  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
0767B9  89 56 A2              MOV    word ptr [bp - 0x5e], dx ; LOCAL_STORE
0767BC  8B 86 F4 FD           MOV    ax, word ptr [bp - 0x20c] ; LOCAL_LOAD
0767C0  8B 96 F6 FD           MOV    dx, word ptr [bp - 0x20a] ; LOCAL_LOAD
0767C4  A3 1A A6              MOV    word ptr [0xa61a], ax ; GLOBAL_LOAD
0767C7  89 16 1C A6           MOV    word ptr [0xa61c], dx ; GLOBAL_LOAD
0767CB  8B 4E A2              MOV    cx, word ptr [bp - 0x5e] ; LOCAL_LOAD
0767CE  0B 4E A0              OR     cx, word ptr [bp - 0x60] ; LOGIC
0767D1  75 11                 JNE    0x767e4 ; CJUMP
0767D3  8D 8E 04 FE           LEA    cx, [bp - 0x1fc] ; ADDR
0767D7  16                    PUSH   ss ; STACK_PUSH
0767D8  51                    PUSH   cx ; STACK_PUSH
0767D9  9A 90 0E 1F 1A        LCALL  0x1a1f, 0xe90 ; THUNK -> 0x0000:0x0022 (thunk @file 0x01D480 type A) overlay @file 0x025922
0767DE  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
0767E1  89 56 A2              MOV    word ptr [bp - 0x5e], dx ; LOCAL_STORE
0767E4  8B 46 A2              MOV    ax, word ptr [bp - 0x5e] ; LOCAL_LOAD
0767E7  0B 46 A0              OR     ax, word ptr [bp - 0x60] ; LOGIC
0767EA  75 0A                 JNE    0x767f6 ; CJUMP
0767EC  C7 06 F0 23 FC FF     MOV    word ptr [0x23f0], 0xfffc ; GLOBAL_LOAD
0767F2  E9 84 02              JMP    0x76a79 ; JUMP
0767F5  90                    NOP ; NOP
0767F6  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0767F9  99                    CDQ ; ARITH
0767FA  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
0767FF  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
076802  89 56 9E              MOV    word ptr [bp - 0x62], dx ; LOCAL_STORE
076805  0B D0                 OR     dx, ax ; LOGIC
076807  74 E3                 JE     0x767ec ; CJUMP
076809  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
07680C  2B C0                 SUB    ax, ax ; ARITH
07680E  26 89 47 40           MOV    word ptr es:[bx + 0x40], ax ; MOV
076812  26 89 47 3E           MOV    word ptr es:[bx + 0x3e], ax ; MOV
076816  26 89 47 38           MOV    word ptr es:[bx + 0x38], ax ; MOV
07681A  26 89 47 36           MOV    word ptr es:[bx + 0x36], ax ; MOV
07681E  26 89 47 30           MOV    word ptr es:[bx + 0x30], ax ; MOV
076822  26 89 47 2E           MOV    word ptr es:[bx + 0x2e], ax ; MOV
076826  26 89 47 34           MOV    word ptr es:[bx + 0x34], ax ; MOV
07682A  26 89 47 32           MOV    word ptr es:[bx + 0x32], ax ; MOV
07682E  26 89 47 3C           MOV    word ptr es:[bx + 0x3c], ax ; MOV
076832  26 89 47 3A           MOV    word ptr es:[bx + 0x3a], ax ; MOV
076836  FF 76 9E              PUSH   word ptr [bp - 0x62] ; PUSH_GLOBAL
076839  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
07683C  50                    PUSH   ax ; STACK_PUSH
07683D  6A 01                 PUSH   1 ; STACK_PUSH
07683F  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
076843  16                    PUSH   ss ; STACK_PUSH
076844  50                    PUSH   ax ; STACK_PUSH
076845  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
076848  99                    CDQ ; ARITH
076849  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
07684E  0B D0                 OR     dx, ax ; LOGIC
076850  75 0A                 JNE    0x7685c ; CJUMP
076852  C7 06 F0 23 FE FF     MOV    word ptr [0x23f0], 0xfffe ; GLOBAL_LOAD
076858  E9 1E 02              JMP    0x76a79 ; JUMP
07685B  90                    NOP ; NOP
07685C  83 BE F8 FE 00        CMP    word ptr [bp - 0x108], 0 ; CMP
076861  75 19                 JNE    0x7687c ; CJUMP
076863  6A 00                 PUSH   0 ; STACK_PUSH
076865  6A 00                 PUSH   0 ; STACK_PUSH
076867  6A 00                 PUSH   0 ; STACK_PUSH
076869  6A 00                 PUSH   0 ; STACK_PUSH
07686B  B8 F9 FF              MOV    ax, 0xfff9 ; CONST_LOAD
07686E  BA 02 00              MOV    dx, 2 ; MOV
076871  BB 0D 00              MOV    bx, 0xd ; CONST_LOAD
076874  9A 72 07 1F 18        LCALL  0x181f, 0x772 ; THUNK -> 0x0000:0x03CE (thunk @file 0x01AD62 type A) overlay @file 0x025CCE
076879  E9 FD 01              JMP    0x76a79 ; JUMP
07687C  8B BE 32 FE           MOV    di, word ptr [bp - 0x1ce] ; LOCAL_LOAD
076880  8B C7                 MOV    ax, di ; MOV
076882  C1 E7 02              SHL    di, 2 ; LOGIC
076885  03 F8                 ADD    di, ax ; ARITH
076887  D1 E7                 SHL    di, 1 ; LOGIC
076889  8B 83 46 FE           MOV    ax, word ptr [bp + di - 0x1ba] ; LOCAL_LOAD
07688D  8B 93 48 FE           MOV    dx, word ptr [bp + di - 0x1b8] ; LOCAL_LOAD
076891  89 86 FC FD           MOV    word ptr [bp - 0x204], ax ; LOCAL_STORE
076895  89 96 FE FD           MOV    word ptr [bp - 0x202], dx ; LOCAL_STORE
076899  A1 F4 23              MOV    ax, word ptr [0x23f4] ; GLOBAL_LOAD
07689C  0B 06 F2 23           OR     ax, word ptr [0x23f2] ; LOGIC
0768A0  74 32                 JE     0x768d4 ; CJUMP
0768A2  A1 F2 23              MOV    ax, word ptr [0x23f2] ; GLOBAL_LOAD
0768A5  8B 16 F4 23           MOV    dx, word ptr [0x23f4] ; GLOBAL_LOAD
0768A9  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
0768AC  89 56 A6              MOV    word ptr [bp - 0x5a], dx ; LOCAL_STORE
0768AF  2B C9                 SUB    cx, cx ; ARITH
0768B1  89 8E E6 FE           MOV    word ptr [bp - 0x11a], cx ; LOCAL_STORE
0768B5  89 8E E4 FE           MOV    word ptr [bp - 0x11c], cx ; LOCAL_STORE
0768B9  52                    PUSH   dx ; STACK_PUSH
0768BA  50                    PUSH   ax ; STACK_PUSH
0768BB  51                    PUSH   cx ; STACK_PUSH
0768BC  6A 01                 PUSH   1 ; STACK_PUSH
0768BE  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
0768C2  16                    PUSH   ss ; STACK_PUSH
0768C3  50                    PUSH   ax ; STACK_PUSH
0768C4  B8 00 03              MOV    ax, 0x300 ; CONST_LOAD
0768C7  99                    CDQ ; ARITH
0768C8  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
0768CD  0B D0                 OR     dx, ax ; LOGIC
0768CF  75 45                 JNE    0x76916 ; CJUMP
0768D1  E9 A5 01              JMP    0x76a79 ; JUMP
0768D4  8D 46 A8              LEA    ax, [bp - 0x58] ; ADDR
0768D7  50                    PUSH   ax ; STACK_PUSH
0768D8  FF B6 20 FE           PUSH   word ptr [bp - 0x1e0] ; PUSH_GLOBAL
0768DC  9A A2 09 1D 0D        LCALL  0xd1d, 0x9a2 ; LCALL
0768E1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0768E4  6A 00                 PUSH   0 ; STACK_PUSH
0768E6  8B BE 32 FE           MOV    di, word ptr [bp - 0x1ce] ; LOCAL_LOAD
0768EA  FF 86 32 FE           INC    word ptr [bp - 0x1ce] ; ARITH
0768EE  89 7E AC              MOV    word ptr [bp - 0x54], di ; LOCAL_STORE
0768F1  8B C7                 MOV    ax, di ; MOV
0768F3  C1 E7 02              SHL    di, 2 ; LOGIC
0768F6  03 F8                 ADD    di, ax ; ARITH
0768F8  D1 E7                 SHL    di, 1 ; LOGIC
0768FA  8B 83 4A FE           MOV    ax, word ptr [bp + di - 0x1b6] ; LOCAL_LOAD
0768FE  8B 93 4C FE           MOV    dx, word ptr [bp + di - 0x1b4] ; LOCAL_LOAD
076902  03 46 A8              ADD    ax, word ptr [bp - 0x58] ; ARITH
076905  13 56 AA              ADC    dx, word ptr [bp - 0x56] ; ARITH
076908  52                    PUSH   dx ; STACK_PUSH
076909  50                    PUSH   ax ; STACK_PUSH
07690A  FF B6 20 FE           PUSH   word ptr [bp - 0x1e0] ; PUSH_GLOBAL
07690E  9A 3E 0A 1D 0D        LCALL  0xd1d, 0xa3e ; LCALL
076913  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
076916  8A 86 EC FE           MOV    al, byte ptr [bp - 0x114] ; LOCAL_LOAD
07691A  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
07691D  26 88 47 2C           MOV    byte ptr es:[bx + 0x2c], al ; MOV
076921  83 BE EE FE 00        CMP    word ptr [bp - 0x112], 0 ; CMP
076926  74 0E                 JE     0x76936 ; CJUMP
076928  83 BE F0 FE 04        CMP    word ptr [bp - 0x110], 4 ; CMP
07692D  7D 07                 JGE    0x76936 ; CJUMP
07692F  26 C7 07 01 00        MOV    word ptr es:[bx], 1 ; MOV
076934  EB 08                 JMP    0x7693e ; JUMP
076936  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
076939  26 C7 07 00 00        MOV    word ptr es:[bx], 0 ; MOV
07693E  8B 86 F0 FE           MOV    ax, word ptr [bp - 0x110] ; LOCAL_LOAD
076942  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
076945  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
076949  8B 86 12 FF           MOV    ax, word ptr [bp - 0xee] ; LOCAL_LOAD
07694D  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
076951  8B 86 7C FF           MOV    ax, word ptr [bp - 0x84] ; LOCAL_LOAD
076955  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax ; MOV
076959  8B 86 7E FF           MOV    ax, word ptr [bp - 0x82] ; LOCAL_LOAD
07695D  26 89 47 2A           MOV    word ptr es:[bx + 0x2a], ax ; MOV
076961  2B F6                 SUB    si, si ; ARITH
076963  8E 46 A2              MOV    es, word ptr [bp - 0x5e] ; LOCAL_LOAD
076966  8B FE                 MOV    di, si ; MOV
076968  D1 E7                 SHL    di, 1 ; LOGIC
07696A  8B 83 F2 FE           MOV    ax, word ptr [bp + di - 0x10e] ; LOCAL_LOAD
07696E  8B 5E A0              MOV    bx, word ptr [bp - 0x60] ; LOCAL_LOAD
076971  26 89 41 08           MOV    word ptr es:[bx + di + 8], ax ; MOV
076975  46                    INC    si ; ARITH
076976  83 FE 10              CMP    si, 0x10 ; CMP
076979  7C EB                 JL     0x76966 ; CJUMP
07697B  8B 86 E8 FE           MOV    ax, word ptr [bp - 0x118] ; LOCAL_LOAD
07697F  03 46 A0              ADD    ax, word ptr [bp - 0x60] ; ARITH
076982  8B 56 A2              MOV    dx, word ptr [bp - 0x5e] ; LOCAL_LOAD
076985  52                    PUSH   dx ; STACK_PUSH
076986  50                    PUSH   ax ; STACK_PUSH
076987  9A 78 0E 1F 1A        LCALL  0x1a1f, 0xe78 ; THUNK -> 0x0C05:0x0004 (thunk @file 0x01D468 type B)
07698C  89 86 00 FE           MOV    word ptr [bp - 0x200], ax ; LOCAL_STORE
076990  89 96 02 FE           MOV    word ptr [bp - 0x1fe], dx ; LOCAL_STORE
076994  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
076997  89 56 96              MOV    word ptr [bp - 0x6a], dx ; LOCAL_STORE
07699A  2B F6                 SUB    si, si ; ARITH
07699C  EB 17                 JMP    0x769b5 ; JUMP
07699E  8B FE                 MOV    di, si ; MOV
0769A0  D1 E7                 SHL    di, 1 ; LOGIC
0769A2  03 FE                 ADD    di, si ; ARITH
0769A4  C1 E7 02              SHL    di, 2 ; LOGIC
0769A7  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
0769AA  2B C0                 SUB    ax, ax ; ARITH
0769AC  26 89 41 44           MOV    word ptr es:[bx + di + 0x44], ax ; MOV
0769B0  26 89 41 42           MOV    word ptr es:[bx + di + 0x42], ax ; MOV
0769B4  46                    INC    si ; ARITH
0769B5  C4 5E A0              LES    bx, ptr [bp - 0x60] ; MOV_FAR
0769B8  26 39 77 04           CMP    word ptr es:[bx + 4], si ; CMP
0769BC  7E 7E                 JLE    0x76a3c ; CJUMP
0769BE  8B FE                 MOV    di, si ; MOV
0769C0  C1 E7 04              SHL    di, 4 ; LOGIC
0769C3  03 7E 9C              ADD    di, word ptr [bp - 0x64] ; ARITH
0769C6  8E 46 9E              MOV    es, word ptr [bp - 0x62] ; LOCAL_LOAD
0769C9  26 8B 45 08           MOV    ax, word ptr es:[di + 8] ; MOV
0769CD  8B DE                 MOV    bx, si ; MOV
0769CF  D1 E3                 SHL    bx, 1 ; LOGIC
0769D1  03 DE                 ADD    bx, si ; ARITH
0769D3  C1 E3 02              SHL    bx, 2 ; LOGIC
0769D6  8C C1                 MOV    cx, es ; MOV
0769D8  03 5E A0              ADD    bx, word ptr [bp - 0x60] ; ARITH
0769DB  8E 46 A2              MOV    es, word ptr [bp - 0x5e] ; LOCAL_LOAD
0769DE  26 89 47 46           MOV    word ptr es:[bx + 0x46], ax ; MOV
0769E2  8C C0                 MOV    ax, es ; MOV
0769E4  8E C1                 MOV    es, cx ; MOV
0769E6  26 8B 55 0A           MOV    dx, word ptr es:[di + 0xa] ; MOV
0769EA  8E C0                 MOV    es, ax ; MOV
0769EC  26 89 57 48           MOV    word ptr es:[bx + 0x48], dx ; MOV
0769F0  8E C1                 MOV    es, cx ; MOV
0769F2  26 8B 55 0C           MOV    dx, word ptr es:[di + 0xc] ; MOV
0769F6  8E C0                 MOV    es, ax ; MOV
0769F8  26 89 57 4A           MOV    word ptr es:[bx + 0x4a], dx ; MOV
0769FC  8E C1                 MOV    es, cx ; MOV
0769FE  26 8B 55 0E           MOV    dx, word ptr es:[di + 0xe] ; MOV
076A02  8E C0                 MOV    es, ax ; MOV
076A04  26 89 57 4C           MOV    word ptr es:[bx + 0x4c], dx ; MOV
076A08  F6 86 F0 FD 02        TEST   byte ptr [bp - 0x210], 2 ; LOGIC
076A0D  75 8F                 JNE    0x7699e ; CJUMP
076A0F  80 BE EC FE 00        CMP    byte ptr [bp - 0x114], 0 ; CMP
076A14  75 88                 JNE    0x7699e ; CJUMP
076A16  8B 46 94              MOV    ax, word ptr [bp - 0x6c] ; LOCAL_LOAD
076A19  8B 56 96              MOV    dx, word ptr [bp - 0x6a] ; LOCAL_LOAD
076A1C  26 89 47 42           MOV    word ptr es:[bx + 0x42], ax ; MOV
076A20  26 89 57 44           MOV    word ptr es:[bx + 0x44], dx ; MOV
076A24  8E C1                 MOV    es, cx ; MOV
076A26  26 03 45 04           ADD    ax, word ptr es:[di + 4] ; ARITH
076A2A  52                    PUSH   dx ; STACK_PUSH
076A2B  50                    PUSH   ax ; STACK_PUSH
076A2C  9A 78 0E 1F 1A        LCALL  0x1a1f, 0xe78 ; THUNK -> 0x0C05:0x0004 (thunk @file 0x01D468 type B)
076A31  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
076A34  89 56 96              MOV    word ptr [bp - 0x6a], dx ; LOCAL_STORE
076A37  E9 7A FF              JMP    0x769b4 ; JUMP
076A3A  90                    NOP ; NOP
076A3B  90                    NOP ; NOP
076A3C  F6 86 F0 FD 02        TEST   byte ptr [bp - 0x210], 2 ; LOGIC
076A41  75 28                 JNE    0x76a6b ; CJUMP
076A43  80 BE EC FE 00        CMP    byte ptr [bp - 0x114], 0 ; CMP
076A48  75 21                 JNE    0x76a6b ; CJUMP
076A4A  FF B6 02 FE           PUSH   word ptr [bp - 0x1fe] ; PUSH_GLOBAL
076A4E  FF B6 00 FE           PUSH   word ptr [bp - 0x200] ; PUSH_GLOBAL
076A52  6A 00                 PUSH   0 ; STACK_PUSH
076A54  6A 01                 PUSH   1 ; STACK_PUSH
076A56  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
076A5A  16                    PUSH   ss ; STACK_PUSH
076A5B  50                    PUSH   ax ; STACK_PUSH
076A5C  8B 46 80              MOV    ax, word ptr [bp - 0x80] ; LOCAL_LOAD
076A5F  8B 56 82              MOV    dx, word ptr [bp - 0x7e] ; LOCAL_LOAD
076A62  9A 82 0E 1F 1A        LCALL  0x1a1f, 0xe82 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D472 type A) overlay @file 0x025900
076A67  0B D0                 OR     dx, ax ; LOGIC
076A69  74 0E                 JE     0x76a79 ; CJUMP
076A6B  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
076A6E  8B 56 A2              MOV    dx, word ptr [bp - 0x5e] ; LOCAL_LOAD
076A71  89 86 F8 FD           MOV    word ptr [bp - 0x208], ax ; LOCAL_STORE
076A75  89 96 FA FD           MOV    word ptr [bp - 0x206], dx ; LOCAL_STORE
076A79  83 BE 1A FE 00        CMP    word ptr [bp - 0x1e6], 0 ; CMP
076A7E  74 0B                 JE     0x76a8b ; CJUMP
076A80  8D 86 1A FE           LEA    ax, [bp - 0x1e6] ; ADDR
076A84  16                    PUSH   ss ; STACK_PUSH
076A85  50                    PUSH   ax ; STACK_PUSH
076A86  9A AC 0E 1F 1A        LCALL  0x1a1f, 0xeac ; THUNK -> 0x0000:0x021C (thunk @file 0x01D49C type A) overlay @file 0x025B1C
076A8B  8B 86 E6 FE           MOV    ax, word ptr [bp - 0x11a] ; LOCAL_LOAD
076A8F  0B 86 E4 FE           OR     ax, word ptr [bp - 0x11c] ; LOGIC
076A93  74 0D                 JE     0x76aa2 ; CJUMP
076A95  FF B6 E6 FE           PUSH   word ptr [bp - 0x11a] ; PUSH_GLOBAL
076A99  FF B6 E4 FE           PUSH   word ptr [bp - 0x11c] ; PUSH_GLOBAL
076A9D  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
076AA2  8B 46 9E              MOV    ax, word ptr [bp - 0x62] ; LOCAL_LOAD
076AA5  0B 46 9C              OR     ax, word ptr [bp - 0x64] ; LOGIC
076AA8  74 0B                 JE     0x76ab5 ; CJUMP
076AAA  FF 76 9E              PUSH   word ptr [bp - 0x62] ; PUSH_GLOBAL
076AAD  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
076AB0  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
076AB5  8B 46 A2              MOV    ax, word ptr [bp - 0x5e] ; LOCAL_LOAD
076AB8  0B 46 A0              OR     ax, word ptr [bp - 0x60] ; LOGIC
076ABB  74 23                 JE     0x76ae0 ; CJUMP
076ABD  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
076AC0  8B 56 A2              MOV    dx, word ptr [bp - 0x5e] ; LOCAL_LOAD
076AC3  39 06 F6 23           CMP    word ptr [0x23f6], ax ; CMP
076AC7  75 06                 JNE    0x76acf ; CJUMP
076AC9  39 16 F8 23           CMP    word ptr [0x23f8], dx ; CMP
076ACD  74 11                 JE     0x76ae0 ; CJUMP
076ACF  8B 8E FA FD           MOV    cx, word ptr [bp - 0x206] ; LOCAL_LOAD
076AD3  0B 8E F8 FD           OR     cx, word ptr [bp - 0x208] ; LOGIC
076AD7  75 07                 JNE    0x76ae0 ; CJUMP
076AD9  52                    PUSH   dx ; STACK_PUSH
076ADA  50                    PUSH   ax ; STACK_PUSH
076ADB  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
076AE0  8B 86 F8 FD           MOV    ax, word ptr [bp - 0x208] ; LOCAL_LOAD
076AE4  8B 96 FA FD           MOV    dx, word ptr [bp - 0x206] ; LOCAL_LOAD
076AE8  5E                    POP    si ; STACK_POP
076AE9  5F                    POP    di ; STACK_POP
076AEA  C9                    LEAVE ; EPILOGUE
076AEB  CB                    RETF ; RETURN
