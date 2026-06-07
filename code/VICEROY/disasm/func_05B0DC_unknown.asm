; ============================================================================
; func_05B0DC_unknown
; Region   : overlay
; Bytes    : file 0x05B0DC..0x05B2C2  (486 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B0DC  C8 72 00 00           ENTER  0x72, 0 ; PROLOGUE
05B0E0  57                    PUSH   di ; STACK_PUSH
05B0E1  56                    PUSH   si ; STACK_PUSH
05B0E2  C7 46 9C FF FF        MOV    word ptr [bp - 0x64], 0xffff ; LOCAL_STORE
05B0E7  2B C0                 SUB    ax, ax ; ARITH
05B0E9  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
05B0EC  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
05B0EF  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
05B0F3  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
05B0F7  25 0F 00              AND    ax, 0xf ; LOGIC
05B0FA  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
05B0FD  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05B101  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
05B105  2A E4                 SUB    ah, ah ; ARITH
05B107  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
05B10A  C7 06 54 A1 00 00     MOV    word ptr [0xa154], 0 ; GLOBAL_LOAD
05B110  0B C0                 OR     ax, ax ; LOGIC
05B112  75 03                 JNE    0x5b117 ; CJUMP
05B114  E9 A4 01              JMP    0x5b2bb ; JUMP
05B117  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0 ; LOCAL_STORE
05B11C  B8 01 00              MOV    ax, 1 ; MOV
05B11F  A3 54 A1              MOV    word ptr [0xa154], ax ; GLOBAL_LOAD
05B122  50                    PUSH   ax ; STACK_PUSH
05B123  50                    PUSH   ax ; STACK_PUSH
05B124  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05B127  9A A0 01 1F 1A        LCALL  0x1a1f, 0x1a0 ; THUNK -> 0x0000:0x0006 (thunk @file 0x01C790 type A) overlay @file 0x025906
05B12C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05B12F  3B 46 98              CMP    ax, word ptr [bp - 0x68] ; CMP
05B132  7C 03                 JL     0x5b137 ; CJUMP
05B134  E9 84 01              JMP    0x5b2bb ; JUMP
05B137  83 7E 96 04           CMP    word ptr [bp - 0x6a], 4 ; CMP
05B13B  7C 03                 JL     0x5b140 ; CJUMP
05B13D  E9 0A 01              JMP    0x5b24a ; JUMP
05B140  6B 5E 96 34           IMUL   bx, word ptr [bp - 0x6a], 0x34 ; ARITH
05B144  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
05B149  74 03                 JE     0x5b14e ; CJUMP
05B14B  E9 FC 00              JMP    0x5b24a ; JUMP
05B14E  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
05B152  8D 06 08 1B           LEA    ax, [0x1b08] ; ADDR
05B156  2B D2                 SUB    dx, dx ; ARITH
05B158  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
05B15D  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
05B160  89 56 A2              MOV    word ptr [bp - 0x5e], dx ; LOCAL_STORE
05B163  0B D0                 OR     dx, ax ; LOGIC
05B165  75 03                 JNE    0x5b16a ; CJUMP
05B167  E9 51 01              JMP    0x5b2bb ; JUMP
05B16A  6A 63                 PUSH   0x63 ; PUSH_CONST
05B16C  FF 36 FA 2D           PUSH   word ptr [0x2dfa] ; PUSH_GLOBAL
05B170  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
05B175  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05B178  52                    PUSH   dx ; STACK_PUSH
05B179  50                    PUSH   ax ; STACK_PUSH
05B17A  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
05B17D  FF 76 A0              PUSH   word ptr [bp - 0x60] ; PUSH_GLOBAL
05B180  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
05B185  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
05B188  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
05B18D  EB 71                 JMP    0x5b200 ; JUMP
05B18F  90                    NOP ; NOP
05B190  FF 76 9A              PUSH   word ptr [bp - 0x66] ; PUSH_GLOBAL
05B193  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05B196  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
05B19B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05B19E  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
05B1A1  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
05B1A5  FF 76 9A              PUSH   word ptr [bp - 0x66] ; PUSH_GLOBAL
05B1A8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05B1AB  9A 68 0C 1F 18        LCALL  0x181f, 0xc68 ; THUNK -> 0x05EB:0x3040 (thunk @file 0x01B258 type B) overlay @file 0x02A030
05B1B0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05B1B3  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
05B1B6  50                    PUSH   ax ; STACK_PUSH
05B1B7  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05B1BA  16                    PUSH   ss ; STACK_PUSH
05B1BB  50                    PUSH   ax ; STACK_PUSH
05B1BC  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
05B1C1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05B1C4  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05B1C7  50                    PUSH   ax ; STACK_PUSH
05B1C8  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
05B1CD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05B1D0  8B 5E 94              MOV    bx, word ptr [bp - 0x6c] ; LOCAL_LOAD
05B1D3  D1 E3                 SHL    bx, 1 ; LOGIC
05B1D5  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
05B1D9  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05B1DC  50                    PUSH   ax ; STACK_PUSH
05B1DD  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
05B1E2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05B1E5  8B 46 9A              MOV    ax, word ptr [bp - 0x66] ; LOCAL_LOAD
05B1E8  40                    INC    ax ; ARITH
05B1E9  50                    PUSH   ax ; STACK_PUSH
05B1EA  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
05B1ED  16                    PUSH   ss ; STACK_PUSH
05B1EE  50                    PUSH   ax ; STACK_PUSH
05B1EF  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
05B1F2  FF 76 A0              PUSH   word ptr [bp - 0x60] ; PUSH_GLOBAL
05B1F5  9A 76 01 1F 19        LCALL  0x191f, 0x176 ; THUNK -> 0x0000:0x0A00 (thunk @file 0x01B766 type A) overlay @file 0x026300
05B1FA  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
05B1FD  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
05B200  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
05B203  39 46 9A              CMP    word ptr [bp - 0x66], ax ; CMP
05B206  7C 88                 JL     0x5b190 ; CJUMP
05B208  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
05B20B  FF 76 A0              PUSH   word ptr [bp - 0x60] ; PUSH_GLOBAL
05B20E  9A 6A 01 1F 19        LCALL  0x191f, 0x16a ; THUNK -> 0x0000:0x2580 (thunk @file 0x01B75A type A) overlay @file 0x027E80
05B213  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
05B216  FF 76 A2              PUSH   word ptr [bp - 0x5e] ; PUSH_GLOBAL
05B219  FF 76 A0              PUSH   word ptr [bp - 0x60] ; PUSH_GLOBAL
05B21C  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
05B221  83 7E 9C 63           CMP    word ptr [bp - 0x64], 0x63 ; CMP
05B225  75 09                 JNE    0x5b230 ; CJUMP
05B227  C7 46 9C FF FF        MOV    word ptr [bp - 0x64], 0xffff ; LOCAL_STORE
05B22C  E9 8C 00              JMP    0x5b2bb ; JUMP
05B22F  90                    NOP ; NOP
05B230  83 7E 9C 00           CMP    word ptr [bp - 0x64], 0 ; CMP
05B234  7E 0C                 JLE    0x5b242 ; CJUMP
05B236  C7 06 54 A1 00 00     MOV    word ptr [0xa154], 0 ; GLOBAL_LOAD
05B23C  FF 4E 9C              DEC    word ptr [bp - 0x64] ; ARITH
05B23F  EB 7A                 JMP    0x5b2bb ; JUMP
05B241  90                    NOP ; NOP
05B242  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0 ; LOCAL_STORE
05B247  EB 72                 JMP    0x5b2bb ; JUMP
05B249  90                    NOP ; NOP
05B24A  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0 ; LOCAL_STORE
05B24F  EB 46                 JMP    0x5b297 ; JUMP
05B251  90                    NOP ; NOP
05B252  FF 76 9A              PUSH   word ptr [bp - 0x66] ; PUSH_GLOBAL
05B255  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05B258  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
05B25D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05B260  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
05B263  FF 76 9A              PUSH   word ptr [bp - 0x66] ; PUSH_GLOBAL
05B266  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05B269  9A 68 0C 1F 18        LCALL  0x181f, 0xc68 ; THUNK -> 0x05EB:0x3040 (thunk @file 0x01B258 type B) overlay @file 0x02A030
05B26E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05B271  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
05B274  8A 46 9A              MOV    al, byte ptr [bp - 0x66] ; LOCAL_LOAD
05B277  8B 76 9A              MOV    si, word ptr [bp - 0x66] ; LOCAL_LOAD
05B27A  88 42 8E              MOV    byte ptr [bp + si - 0x72], al ; LOCAL_STORE
05B27D  8B 7E 96              MOV    di, word ptr [bp - 0x6a] ; LOCAL_LOAD
05B280  C1 E7 04              SHL    di, 4 ; LOGIC
05B283  8B 5E 94              MOV    bx, word ptr [bp - 0x6c] ; LOCAL_LOAD
05B286  8A 81 BC 84           MOV    al, byte ptr [bx + di - 0x7b44] ; MOV
05B28A  2A E4                 SUB    ah, ah ; ARITH
05B28C  F7 6E 9E              IMUL   word ptr [bp - 0x62] ; ARITH
05B28F  D1 E6                 SHL    si, 1 ; LOGIC
05B291  89 42 A4              MOV    word ptr [bp + si - 0x5c], ax ; LOCAL_STORE
05B294  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
05B297  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
05B29A  39 46 9A              CMP    word ptr [bp - 0x66], ax ; CMP
05B29D  7C B3                 JL     0x5b252 ; CJUMP
05B29F  8D 46 8E              LEA    ax, [bp - 0x72] ; ADDR
05B2A2  16                    PUSH   ss ; STACK_PUSH
05B2A3  50                    PUSH   ax ; STACK_PUSH
05B2A4  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
05B2A7  16                    PUSH   ss ; STACK_PUSH
05B2A8  50                    PUSH   ax ; STACK_PUSH
05B2A9  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
05B2AC  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
05B2B1  8B 76 98              MOV    si, word ptr [bp - 0x68] ; LOCAL_LOAD
05B2B4  8A 42 8D              MOV    al, byte ptr [bp + si - 0x73] ; LOCAL_LOAD
05B2B7  98                    CWDE ; ARITH
05B2B8  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
05B2BB  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
05B2BE  5E                    POP    si ; STACK_POP
05B2BF  5F                    POP    di ; STACK_POP
05B2C0  C9                    LEAVE ; EPILOGUE
05B2C1  CB                    RETF ; RETURN
