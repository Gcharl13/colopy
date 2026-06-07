; ============================================================================
; func_06B722_unknown
; Region   : overlay
; Bytes    : file 0x06B722..0x06BAEC  (970 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "WDCUT", "WOODCUT"  (auto-named via string xrefs)
; ============================================================================

06B722  C8 C8 03 00           ENTER  0x3c8, 0 ; PROLOGUE
06B726  56                    PUSH   si ; STACK_PUSH
06B727  C7 86 5C FF 01 00     MOV    word ptr [bp - 0xa4], 1 ; LOCAL_STORE
06B72D  C7 86 38 FC 00 00     MOV    word ptr [bp - 0x3c8], 0 ; LOCAL_STORE
06B733  2B C0                 SUB    ax, ax ; ARITH
06B735  89 86 56 FC           MOV    word ptr [bp - 0x3aa], ax ; LOCAL_STORE
06B739  89 86 54 FC           MOV    word ptr [bp - 0x3ac], ax ; LOCAL_STORE
06B73D  89 86 44 FC           MOV    word ptr [bp - 0x3bc], ax ; LOCAL_STORE
06B741  89 86 42 FC           MOV    word ptr [bp - 0x3be], ax ; LOCAL_STORE
06B745  89 86 3C FC           MOV    word ptr [bp - 0x3c4], ax ; LOCAL_STORE
06B749  89 86 3A FC           MOV    word ptr [bp - 0x3c6], ax ; LOCAL_STORE
06B74D  89 86 5A FC           MOV    word ptr [bp - 0x3a6], ax ; LOCAL_STORE
06B751  89 86 58 FC           MOV    word ptr [bp - 0x3a8], ax ; LOCAL_STORE
06B755  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
06B758  7D 11                 JGE    0x6b76b ; CJUMP
06B75A  7F 09                 JG     0x6b765 ; CJUMP
06B75C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06B75F  F7 D0                 NOT    ax ; LOGIC
06B761  40                    INC    ax ; ARITH
06B762  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
06B765  C7 86 38 FC 01 00     MOV    word ptr [bp - 0x3c8], 1 ; LOCAL_STORE
06B76B  68 06 1F              PUSH   0x1f06                       ; STRING: "WDCUT"
06B76E  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B772  50                    PUSH   ax ; STACK_PUSH
06B773  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06B778  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B77B  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B77F  16                    PUSH   ss ; STACK_PUSH
06B780  50                    PUSH   ax ; STACK_PUSH
06B781  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06B784  BA 02 00              MOV    dx, 2 ; MOV
06B787  9A 9A 0E 1F 18        LCALL  0x181f, 0xe9a ; THUNK -> 0x09F6:0x0002 (thunk @file 0x01B48A type B) overlay @file 0x030C68
06B78C  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B790  16                    PUSH   ss ; STACK_PUSH
06B791  50                    PUSH   ax ; STACK_PUSH
06B792  1E                    PUSH   ds ; STACK_PUSH
06B793  68 0C 1F              PUSH   0x1f0c ; PUSH_CONST
06B796  9A 94 0A 1F 1A        LCALL  0x1a1f, 0xa94 ; THUNK -> 0x0B32:0x000E (thunk @file 0x01D084 type B) overlay @file 0x040608
06B79B  8D 9E 5E FF           LEA    bx, [bp - 0xa2] ; ADDR
06B79F  9A 90 0E 1F 18        LCALL  0x181f, 0xe90 ; THUNK -> 0x09F6:0x0138 (thunk @file 0x01B480 type B) overlay @file 0x030D9E
06B7A4  0B C0                 OR     ax, ax ; LOGIC
06B7A6  75 03                 JNE    0x6b7ab ; CJUMP
06B7A8  E9 3A 03              JMP    0x6bae5 ; JUMP
06B7AB  8D 1E 0F 1F           LEA    bx, [0x1f0f] ; ADDR
06B7AF  9A 86 0A 1F 1A        LCALL  0x1a1f, 0xa86 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D076 type A) overlay @file 0x025900
06B7B4  89 86 54 FC           MOV    word ptr [bp - 0x3ac], ax ; LOCAL_STORE
06B7B8  89 96 56 FC           MOV    word ptr [bp - 0x3aa], dx ; LOCAL_STORE
06B7BC  0B D0                 OR     dx, ax ; LOGIC
06B7BE  75 03                 JNE    0x6b7c3 ; CJUMP
06B7C0  E9 22 03              JMP    0x6bae5 ; JUMP
06B7C3  9A DE 0F 1F 19        LCALL  0x191f, 0xfde ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5CE type A) overlay @file 0x025900
06B7C8  8D 1E 17 1F           LEA    bx, [0x1f17] ; ADDR
06B7CC  2B C0                 SUB    ax, ax ; ARITH
06B7CE  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
06B7D3  89 86 42 FC           MOV    word ptr [bp - 0x3be], ax ; LOCAL_STORE
06B7D7  89 96 44 FC           MOV    word ptr [bp - 0x3bc], dx ; LOCAL_STORE
06B7DB  0B D0                 OR     dx, ax ; LOGIC
06B7DD  75 03                 JNE    0x6b7e2 ; CJUMP
06B7DF  E9 B0 02              JMP    0x6ba92 ; JUMP
06B7E2  8D 1E 20 1F           LEA    bx, [0x1f20] ; ADDR
06B7E6  2B C0                 SUB    ax, ax ; ARITH
06B7E8  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
06B7ED  89 86 58 FC           MOV    word ptr [bp - 0x3a8], ax ; LOCAL_STORE
06B7F1  89 96 5A FC           MOV    word ptr [bp - 0x3a6], dx ; LOCAL_STORE
06B7F5  0B D0                 OR     dx, ax ; LOGIC
06B7F7  75 03                 JNE    0x6b7fc ; CJUMP
06B7F9  E9 96 02              JMP    0x6ba92 ; JUMP
06B7FC  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06B801  74 19                 JE     0x6b81c ; CJUMP
06B803  8D 86 5C FC           LEA    ax, [bp - 0x3a4] ; ADDR
06B807  16                    PUSH   ss ; STACK_PUSH
06B808  50                    PUSH   ax ; STACK_PUSH
06B809  9A 78 0A 1F 1A        LCALL  0x1a1f, 0xa78 ; THUNK -> 0x0000:0x0008 (thunk @file 0x01D068 type A) overlay @file 0x025908
06B80E  8D 86 5C FC           LEA    ax, [bp - 0x3a4] ; ADDR
06B812  16                    PUSH   ss ; STACK_PUSH
06B813  50                    PUSH   ax ; STACK_PUSH
06B814  B8 01 00              MOV    ax, 1 ; MOV
06B817  9A 6A 0A 1F 1A        LCALL  0x1a1f, 0xa6a ; THUNK -> 0x0000:0x002A (thunk @file 0x01D05A type A) overlay @file 0x02592A
06B81C  8D 86 5C FC           LEA    ax, [bp - 0x3a4] ; ADDR
06B820  A3 F2 23              MOV    word ptr [0x23f2], ax ; GLOBAL_LOAD
06B823  8C 16 F4 23           MOV    word ptr [0x23f4], ss ; GLOBAL_LOAD
06B827  8D 9E 5E FF           LEA    bx, [bp - 0xa2] ; ADDR
06B82B  2B C0                 SUB    ax, ax ; ARITH
06B82D  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
06B832  89 86 3A FC           MOV    word ptr [bp - 0x3c6], ax ; LOCAL_STORE
06B836  89 96 3C FC           MOV    word ptr [bp - 0x3c4], dx ; LOCAL_STORE
06B83A  0B D0                 OR     dx, ax ; LOGIC
06B83C  75 03                 JNE    0x6b841 ; CJUMP
06B83E  E9 51 02              JMP    0x6ba92 ; JUMP
06B841  0E                    PUSH   cs ; STACK_PUSH
06B842  E8 A7 02              CALL   0x6baec ; CALL_NEAR
06B845  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06B84A  75 06                 JNE    0x6b852 ; CJUMP
06B84C  C7 06 72 03 00 00     MOV    word ptr [0x372], 0 ; GLOBAL_LOAD
06B852  8D 86 5C FC           LEA    ax, [bp - 0x3a4] ; ADDR
06B856  16                    PUSH   ss ; STACK_PUSH
06B857  50                    PUSH   ax ; STACK_PUSH
06B858  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
06B85D  FF B6 44 FC           PUSH   word ptr [bp - 0x3bc] ; PUSH_GLOBAL
06B861  FF B6 42 FC           PUSH   word ptr [bp - 0x3be] ; PUSH_GLOBAL
06B865  E8 86 FE              CALL   0x6b6ee ; CALL_NEAR
06B868  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B86B  C4 9E 58 FC           LES    bx, ptr [bp - 0x3a8] ; MOV_FAR
06B86F  26 8B 47 4A           MOV    ax, word ptr es:[bx + 0x4a] ; MOV
06B873  89 86 52 FC           MOV    word ptr [bp - 0x3ae], ax ; LOCAL_STORE
06B877  26 8B 47 56           MOV    ax, word ptr es:[bx + 0x56] ; MOV
06B87B  89 86 4C FC           MOV    word ptr [bp - 0x3b4], ax ; LOCAL_STORE
06B87F  26 8B 47 62           MOV    ax, word ptr es:[bx + 0x62] ; MOV
06B883  89 86 46 FC           MOV    word ptr [bp - 0x3ba], ax ; LOCAL_STORE
06B887  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06B88C  74 0B                 JE     0x6b899 ; CJUMP
06B88E  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
06B892  75 05                 JNE    0x6b899 ; CJUMP
06B894  C7 46 06 00 00        MOV    word ptr [bp + 6], 0 ; LOCAL_STORE
06B899  68 29 1F              PUSH   0x1f29                       ; STRING: "WOODCUT"
06B89C  68 31 1F              PUSH   0x1f31                       ; STRING: "WOODCUT"
06B89F  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
06B8A4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B8A7  C7 86 48 FC 00 00     MOV    word ptr [bp - 0x3b8], 0 ; LOCAL_STORE
06B8AD  EB 0E                 JMP    0x6b8bd ; JUMP
06B8AF  90                    NOP ; NOP
06B8B0  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
06B8B5  89 86 40 FC           MOV    word ptr [bp - 0x3c0], ax ; LOCAL_STORE
06B8B9  FF 86 48 FC           INC    word ptr [bp - 0x3b8] ; ARITH
06B8BD  8B 86 48 FC           MOV    ax, word ptr [bp - 0x3b8] ; LOCAL_LOAD
06B8C1  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
06B8C4  7D EA                 JGE    0x6b8b0 ; CJUMP
06B8C6  9A B8 0F 1F 19        LCALL  0x191f, 0xfb8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5A8 type A) overlay @file 0x025900
06B8CB  FF B6 40 FC           PUSH   word ptr [bp - 0x3c0] ; PUSH_GLOBAL
06B8CF  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B8D3  50                    PUSH   ax ; STACK_PUSH
06B8D4  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06B8D9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B8DC  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06B8E0  6A 0A                 PUSH   0xa ; PUSH_CONST
06B8E2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B8E5  50                    PUSH   ax ; STACK_PUSH
06B8E6  FF 36 8A 53           PUSH   word ptr [0x538a] ; PUSH_GLOBAL
06B8EA  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
06B8EF  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06B8F2  68 39 1F              PUSH   0x1f39 ; PUSH_CONST
06B8F5  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B8F8  50                    PUSH   ax ; STACK_PUSH
06B8F9  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
06B8FE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B901  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B905  50                    PUSH   ax ; STACK_PUSH
06B906  8D 4E B0              LEA    cx, [bp - 0x50] ; ADDR
06B909  51                    PUSH   cx ; STACK_PUSH
06B90A  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
06B90F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B912  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06B916  50                    PUSH   ax ; STACK_PUSH
06B917  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B91A  50                    PUSH   ax ; STACK_PUSH
06B91B  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06B920  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06B923  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa] ; PUSH_GLOBAL
06B927  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac] ; PUSH_GLOBAL
06B92B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B92E  16                    PUSH   ss ; STACK_PUSH
06B92F  50                    PUSH   ax ; STACK_PUSH
06B930  2B C0                 SUB    ax, ax ; ARITH
06B932  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
06B937  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
06B93A  2B C0                 SUB    ax, ax ; ARITH
06B93C  89 86 3E FC           MOV    word ptr [bp - 0x3c2], ax ; LOCAL_STORE
06B940  89 86 4E FC           MOV    word ptr [bp - 0x3b2], ax ; LOCAL_STORE
06B944  EB 0C                 JMP    0x6b952 ; JUMP
06B946  8B 86 4C FC           MOV    ax, word ptr [bp - 0x3b4] ; LOCAL_LOAD
06B94A  01 86 3E FC           ADD    word ptr [bp - 0x3c2], ax ; ARITH
06B94E  FF 86 4E FC           INC    word ptr [bp - 0x3b2] ; ARITH
06B952  8B 46 AE              MOV    ax, word ptr [bp - 0x52] ; LOCAL_LOAD
06B955  39 86 3E FC           CMP    word ptr [bp - 0x3c2], ax ; CMP
06B959  7C EB                 JL     0x6b946 ; CJUMP
06B95B  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6] ; PUSH_GLOBAL
06B95F  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8] ; PUSH_GLOBAL
06B963  B8 A2 00              MOV    ax, 0xa2 ; CONST_LOAD
06B966  89 86 4A FC           MOV    word ptr [bp - 0x3b6], ax ; LOCAL_STORE
06B96A  50                    PUSH   ax ; STACK_PUSH
06B96B  BA A0 00              MOV    dx, 0xa0 ; CONST_LOAD
06B96E  8B 86 3E FC           MOV    ax, word ptr [bp - 0x3c2] ; LOCAL_LOAD
06B972  03 86 46 FC           ADD    ax, word ptr [bp - 0x3ba] ; ARITH
06B976  03 86 52 FC           ADD    ax, word ptr [bp - 0x3ae] ; ARITH
06B97A  D1 F8                 SAR    ax, 1 ; LOGIC
06B97C  2B D0                 SUB    dx, ax ; ARITH
06B97E  B8 01 00              MOV    ax, 1 ; MOV
06B981  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06B985  8B F2                 MOV    si, dx ; MOV
06B987  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06B98C  03 B6 52 FC           ADD    si, word ptr [bp - 0x3ae] ; ARITH
06B990  89 B6 50 FC           MOV    word ptr [bp - 0x3b0], si ; LOCAL_STORE
06B994  C7 86 48 FC 00 00     MOV    word ptr [bp - 0x3b8], 0 ; LOCAL_STORE
06B99A  EB 28                 JMP    0x6b9c4 ; JUMP
06B99C  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6] ; PUSH_GLOBAL
06B9A0  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8] ; PUSH_GLOBAL
06B9A4  FF B6 4A FC           PUSH   word ptr [bp - 0x3b6] ; PUSH_GLOBAL
06B9A8  B8 02 00              MOV    ax, 2 ; MOV
06B9AB  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06B9AF  8B 96 50 FC           MOV    dx, word ptr [bp - 0x3b0] ; LOCAL_LOAD
06B9B3  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06B9B8  8B 86 4C FC           MOV    ax, word ptr [bp - 0x3b4] ; LOCAL_LOAD
06B9BC  01 86 50 FC           ADD    word ptr [bp - 0x3b0], ax ; ARITH
06B9C0  FF 86 48 FC           INC    word ptr [bp - 0x3b8] ; ARITH
06B9C4  8B 86 48 FC           MOV    ax, word ptr [bp - 0x3b8] ; LOCAL_LOAD
06B9C8  39 86 4E FC           CMP    word ptr [bp - 0x3b2], ax ; CMP
06B9CC  7F CE                 JG     0x6b99c ; CJUMP
06B9CE  FF B6 5A FC           PUSH   word ptr [bp - 0x3a6] ; PUSH_GLOBAL
06B9D2  FF B6 58 FC           PUSH   word ptr [bp - 0x3a8] ; PUSH_GLOBAL
06B9D6  FF B6 4A FC           PUSH   word ptr [bp - 0x3b6] ; PUSH_GLOBAL
06B9DA  B8 03 00              MOV    ax, 3 ; MOV
06B9DD  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06B9E1  8B 96 50 FC           MOV    dx, word ptr [bp - 0x3b0] ; LOCAL_LOAD
06B9E5  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06B9EA  8B 46 AE              MOV    ax, word ptr [bp - 0x52] ; LOCAL_LOAD
06B9ED  D1 F8                 SAR    ax, 1 ; LOGIC
06B9EF  2D A0 00              SUB    ax, 0xa0 ; ARITH
06B9F2  F7 D8                 NEG    ax ; ARITH
06B9F4  89 86 50 FC           MOV    word ptr [bp - 0x3b0], ax ; LOCAL_STORE
06B9F8  6A 5D                 PUSH   0x5d ; PUSH_CONST
06B9FA  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06B9FD  BA 5C 00              MOV    dx, 0x5c ; CONST_LOAD
06BA00  BB 5E 00              MOV    bx, 0x5e ; CONST_LOAD
06BA03  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
06BA08  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa] ; PUSH_GLOBAL
06BA0C  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac] ; PUSH_GLOBAL
06BA10  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06BA13  16                    PUSH   ss ; STACK_PUSH
06BA14  50                    PUSH   ax ; STACK_PUSH
06BA15  6A 00                 PUSH   0 ; STACK_PUSH
06BA17  BA A5 00              MOV    dx, 0xa5 ; CONST_LOAD
06BA1A  89 96 4A FC           MOV    word ptr [bp - 0x3b6], dx ; LOCAL_STORE
06BA1E  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06BA22  8B 86 50 FC           MOV    ax, word ptr [bp - 0x3b0] ; LOCAL_LOAD
06BA26  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
06BA2B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06BA2F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06BA33  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06BA37  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06BA3B  6A 70                 PUSH   0x70 ; PUSH_CONST
06BA3D  6A 0A                 PUSH   0xa ; PUSH_CONST
06BA3F  B8 3F 00              MOV    ax, 0x3f ; CONST_LOAD
06BA42  BA 28 00              MOV    dx, 0x28 ; CONST_LOAD
06BA45  BB C0 00              MOV    bx, 0xc0 ; CONST_LOAD
06BA48  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
06BA4D  6A 00                 PUSH   0 ; STACK_PUSH
06BA4F  68 40 01              PUSH   0x140 ; PUSH_CONST
06BA52  68 C8 00              PUSH   0xc8 ; PUSH_CONST
06BA55  2B C0                 SUB    ax, ax ; ARITH
06BA57  99                    CDQ ; ARITH
06BA58  2B DB                 SUB    bx, bx ; ARITH
06BA5A  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
06BA5F  FF B6 3C FC           PUSH   word ptr [bp - 0x3c4] ; PUSH_GLOBAL
06BA63  FF B6 3A FC           PUSH   word ptr [bp - 0x3c6] ; PUSH_GLOBAL
06BA67  E8 84 FC              CALL   0x6b6ee ; CALL_NEAR
06BA6A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BA6D  6A 08                 PUSH   8 ; STACK_PUSH
06BA6F  9A EA 03 1F 18        LCALL  0x181f, 0x3ea ; THUNK -> 0x02D6:0x0000 (thunk @file 0x01A9DA type B)
06BA74  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06BA77  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06BA7C  75 0E                 JNE    0x6ba8c ; CJUMP
06BA7E  9A A2 04 1F 19        LCALL  0x191f, 0x4a2 ; THUNK -> 0x0AE7:0x002C (thunk @file 0x01BA92 type B) overlay @file 0x02701C
06BA83  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
06BA88  0E                    PUSH   cs ; STACK_PUSH
06BA89  E8 60 00              CALL   0x6baec ; CALL_NEAR
06BA8C  C7 86 5C FF 00 00     MOV    word ptr [bp - 0xa4], 0 ; LOCAL_STORE
06BA92  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06BA97  75 1C                 JNE    0x6bab5 ; CJUMP
06BA99  68 00 A0              PUSH   0xa000 ; PUSH_CONST
06BA9C  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
06BA9F  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
06BAA4  8A 26 83 53           MOV    ah, byte ptr [0x5383] ; GLOBAL_LOAD
06BAA8  25 00 01              AND    ax, 0x100 ; LOGIC
06BAAB  3D 01 00              CMP    ax, 1 ; CMP
06BAAE  1B C0                 SBB    ax, ax ; ARITH
06BAB0  F7 D8                 NEG    ax ; ARITH
06BAB2  A3 72 03              MOV    word ptr [0x372], ax ; GLOBAL_LOAD
06BAB5  2B C0                 SUB    ax, ax ; ARITH
06BAB7  A3 F4 23              MOV    word ptr [0x23f4], ax ; GLOBAL_LOAD
06BABA  A3 F2 23              MOV    word ptr [0x23f2], ax ; GLOBAL_LOAD
06BABD  8B 86 56 FC           MOV    ax, word ptr [bp - 0x3aa] ; LOCAL_LOAD
06BAC1  0B 86 54 FC           OR     ax, word ptr [bp - 0x3ac] ; LOGIC
06BAC5  74 0D                 JE     0x6bad4 ; CJUMP
06BAC7  FF B6 56 FC           PUSH   word ptr [bp - 0x3aa] ; PUSH_GLOBAL
06BACB  FF B6 54 FC           PUSH   word ptr [bp - 0x3ac] ; PUSH_GLOBAL
06BACF  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
06BAD4  9A AC 0A 1F 19        LCALL  0x191f, 0xaac ; THUNK -> 0x0000:0x00C4 (thunk @file 0x01C09C type A) overlay @file 0x0259C4
06BAD9  83 BE 38 FC 00        CMP    word ptr [bp - 0x3c8], 0 ; CMP
06BADE  75 05                 JNE    0x6bae5 ; CJUMP
06BAE0  9A 6A 05 1F 18        LCALL  0x181f, 0x56a ; THUNK -> 0x0984:0x04F6 (thunk @file 0x01AB5A type B) overlay @file 0x03240C
06BAE5  8B 86 5C FF           MOV    ax, word ptr [bp - 0xa4] ; LOCAL_LOAD
06BAE9  5E                    POP    si ; STACK_POP
06BAEA  C9                    LEAVE ; EPILOGUE
06BAEB  CB                    RETF ; RETURN
