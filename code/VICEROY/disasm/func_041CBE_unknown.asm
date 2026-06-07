; ============================================================================
; func_041CBE_unknown
; Region   : overlay
; Bytes    : file 0x041CBE..0x041E7E  (448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041CBE  C8 1A 00 00           ENTER  0x1a, 0 ; PROLOGUE
041CC2  2B C0                 SUB    ax, ax ; ARITH
041CC4  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
041CC7  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
041CCA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041CCE  8A 87 4D 31           MOV    al, byte ptr [bx + 0x314d] ; MOV
041CD2  2A E4                 SUB    ah, ah ; ARITH
041CD4  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
041CD7  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
041CDA  8A 87 4E 31           MOV    al, byte ptr [bx + 0x314e] ; MOV
041CDE  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
041CE1  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
041CE4  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
041CE7  2B 46 F4              SUB    ax, word ptr [bp - 0xc] ; ARITH
041CEA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
041CED  EB 4E                 JMP    0x41d3d ; JUMP
041CEF  90                    NOP ; NOP
041CF0  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041CF3  F7 D0                 NOT    ax ; LOGIC
041CF5  40                    INC    ax ; ARITH
041CF6  EB 02                 JMP    0x41cfa ; JUMP
041CF8  2B C0                 SUB    ax, ax ; ARITH
041CFA  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
041CFD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041D00  50                    PUSH   ax ; STACK_PUSH
041D01  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
041D04  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041D07  0E                    PUSH   cs ; STACK_PUSH
041D08  E8 10 04              CALL   0x4211b ; CALL_NEAR
041D0B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041D0E  0B C0                 OR     ax, ax ; LOGIC
041D10  74 11                 JE     0x41d23 ; CJUMP
041D12  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1 ; LOCAL_STORE
041D17  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041D1A  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
041D1D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041D20  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
041D23  83 46 F0 02           ADD    word ptr [bp - 0x10], 2 ; ARITH
041D27  83 7E F0 01           CMP    word ptr [bp - 0x10], 1 ; CMP
041D2B  7F 0D                 JG     0x41d3a ; CJUMP
041D2D  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
041D31  74 C5                 JE     0x41cf8 ; CJUMP
041D33  7C BB                 JL     0x41cf0 ; CJUMP
041D35  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041D38  EB C0                 JMP    0x41cfa ; JUMP
041D3A  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
041D3D  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
041D41  75 13                 JNE    0x41d56 ; CJUMP
041D43  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041D46  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
041D49  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
041D4C  7C 08                 JL     0x41d56 ; CJUMP
041D4E  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; LOCAL_STORE
041D53  EB D2                 JMP    0x41d27 ; JUMP
041D55  90                    NOP ; NOP
041D56  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
041D59  2B 46 F4              SUB    ax, word ptr [bp - 0xc] ; ARITH
041D5C  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041D5F  EB 4E                 JMP    0x41daf ; JUMP
041D61  90                    NOP ; NOP
041D62  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041D65  F7 D0                 NOT    ax ; LOGIC
041D67  40                    INC    ax ; ARITH
041D68  EB 02                 JMP    0x41d6c ; JUMP
041D6A  2B C0                 SUB    ax, ax ; ARITH
041D6C  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
041D6F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
041D72  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
041D75  50                    PUSH   ax ; STACK_PUSH
041D76  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041D79  0E                    PUSH   cs ; STACK_PUSH
041D7A  E8 9E 03              CALL   0x4211b ; CALL_NEAR
041D7D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041D80  0B C0                 OR     ax, ax ; LOGIC
041D82  74 11                 JE     0x41d95 ; CJUMP
041D84  C7 46 EC 01 00        MOV    word ptr [bp - 0x14], 1 ; LOCAL_STORE
041D89  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041D8C  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
041D8F  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041D92  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
041D95  83 46 FA 02           ADD    word ptr [bp - 6], 2 ; ARITH
041D99  83 7E FA 01           CMP    word ptr [bp - 6], 1 ; CMP
041D9D  7F 0D                 JG     0x41dac ; CJUMP
041D9F  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
041DA3  74 C5                 JE     0x41d6a ; CJUMP
041DA5  7C BB                 JL     0x41d62 ; CJUMP
041DA7  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041DAA  EB C0                 JMP    0x41d6c ; JUMP
041DAC  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
041DAF  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
041DB3  75 13                 JNE    0x41dc8 ; CJUMP
041DB5  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
041DB8  03 46 F6              ADD    ax, word ptr [bp - 0xa] ; ARITH
041DBB  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
041DBE  7C 08                 JL     0x41dc8 ; CJUMP
041DC0  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
041DC5  EB D2                 JMP    0x41d99 ; JUMP
041DC7  90                    NOP ; NOP
041DC8  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
041DCB  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
041DCF  75 14                 JNE    0x41de5 ; CJUMP
041DD1  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
041DD4  3B 06 3A 85           CMP    ax, word ptr [0x853a] ; CMP
041DD8  7D 03                 JGE    0x41ddd ; CJUMP
041DDA  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
041DDD  3B 46 F4              CMP    ax, word ptr [bp - 0xc] ; CMP
041DE0  7E 03                 JLE    0x41de5 ; CJUMP
041DE2  E9 FF FE              JMP    0x41ce4 ; JUMP
041DE5  83 7E EC 00           CMP    word ptr [bp - 0x14], 0 ; CMP
041DE9  75 14                 JNE    0x41dff ; CJUMP
041DEB  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
041DEE  8B 56 E8              MOV    dx, word ptr [bp - 0x18] ; LOCAL_LOAD
041DF1  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
041DF6  50                    PUSH   ax ; STACK_PUSH
041DF7  9A 3A 08 1F 18        LCALL  0x181f, 0x83a ; THUNK -> 0x0427:0x0F30 (thunk @file 0x01AE2A type B) overlay @file 0x031C44
041DFC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041DFF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041E02  9A DA 08 1F 18        LCALL  0x181f, 0x8da ; THUNK -> 0x0427:0x0968 (thunk @file 0x01AECA type B) overlay @file 0x03167C
041E07  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041E0A  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
041E0D  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
041E10  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041E13  9A 48 09 1F 18        LCALL  0x181f, 0x948 ; THUNK -> 0x0427:0x040C (thunk @file 0x01AF38 type B) overlay @file 0x031120
041E18  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041E1B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041E1E  9A 4E 08 1F 18        LCALL  0x181f, 0x84e ; THUNK -> 0x0427:0x0CE6 (thunk @file 0x01AE3E type B) overlay @file 0x0319FA
041E23  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041E26  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
041E29  9A A0 07 1F 18        LCALL  0x181f, 0x7a0 ; THUNK -> 0x03F1:0x02F8 (thunk @file 0x01AD90 type B) overlay @file 0x022586
041E2E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041E32  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
041E36  24 0F                 AND    al, 0xf ; LOGIC
041E38  3A 06 96 53           CMP    al, byte ptr [0x5396] ; CMP
041E3C  75 3E                 JNE    0x41e7c ; CJUMP
041E3E  6A 00                 PUSH   0 ; STACK_PUSH
041E40  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
041E43  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
041E46  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
041E49  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
041E4C  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
041E51  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
041E54  0B C0                 OR     ax, ax ; LOGIC
041E56  75 1C                 JNE    0x41e74 ; CJUMP
041E58  6A 01                 PUSH   1 ; STACK_PUSH
041E5A  6A 07                 PUSH   7 ; STACK_PUSH
041E5C  6A 07                 PUSH   7 ; STACK_PUSH
041E5E  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
041E61  2D 03 00              SUB    ax, 3 ; ARITH
041E64  50                    PUSH   ax ; STACK_PUSH
041E65  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
041E68  2D 03 00              SUB    ax, 3 ; ARITH
041E6B  50                    PUSH   ax ; STACK_PUSH
041E6C  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
041E71  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
041E74  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041E77  9A 12 0E 1F 18        LCALL  0x181f, 0xe12 ; THUNK -> 0x0984:0x0636 (thunk @file 0x01B402 type B) overlay @file 0x03254C
041E7C  C9                    LEAVE ; EPILOGUE
041E7D  CB                    RETF ; RETURN
