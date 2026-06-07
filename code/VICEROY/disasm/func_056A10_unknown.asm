; ============================================================================
; func_056A10_unknown
; Region   : overlay
; Bytes    : file 0x056A10..0x056B07  (247 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

056A10  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
056A14  56                    PUSH   si ; STACK_PUSH
056A15  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
056A19  8A 07                 MOV    al, byte ptr [bx] ; MOV
056A1B  2A E4                 SUB    ah, ah ; ARITH
056A1D  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
056A20  2A F6                 SUB    dh, dh ; ARITH
056A22  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
056A27  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
056A2A  0B C0                 OR     ax, ax ; LOGIC
056A2C  7C 10                 JL     0x56a3e ; CJUMP
056A2E  6A 0A                 PUSH   0xa ; PUSH_CONST
056A30  50                    PUSH   ax ; STACK_PUSH
056A31  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
056A36  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056A39  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
056A3C  EB 05                 JMP    0x56a43 ; JUMP
056A3E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
056A43  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
056A48  2B C0                 SUB    ax, ax ; ARITH
056A4A  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
056A4D  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
056A50  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
056A53  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
056A56  EB 79                 JMP    0x56ad1 ; JUMP
056A58  90                    NOP ; NOP
056A59  90                    NOP ; NOP
056A5A  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
056A5D  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
056A61  98                    CWDE ; ARITH
056A62  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
056A66  8A 4C 01              MOV    cl, byte ptr [si + 1] ; MOV
056A69  2A ED                 SUB    ch, ch ; ARITH
056A6B  03 C1                 ADD    ax, cx ; ARITH
056A6D  8B D0                 MOV    dx, ax ; MOV
056A6F  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
056A73  98                    CWDE ; ARITH
056A74  8A 0C                 MOV    cl, byte ptr [si] ; MOV
056A76  03 C1                 ADD    ax, cx ; ARITH
056A78  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
056A7D  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
056A80  0B C0                 OR     ax, ax ; LOGIC
056A82  7C 4A                 JL     0x56ace ; CJUMP
056A84  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
056A87  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
056A8B  83 E1 0F              AND    cx, 0xf ; LOGIC
056A8E  89 4E EE              MOV    word ptr [bp - 0x12], cx ; LOCAL_STORE
056A91  6A 0A                 PUSH   0xa ; PUSH_CONST
056A93  50                    PUSH   ax ; STACK_PUSH
056A94  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
056A99  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056A9C  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
056A9F  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
056AA2  39 46 0C              CMP    word ptr [bp + 0xc], ax ; CMP
056AA5  75 27                 JNE    0x56ace ; CJUMP
056AA7  6A 0B                 PUSH   0xb ; PUSH_CONST
056AA9  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
056AAC  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
056AB1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
056AB4  C1 F8 03              SAR    ax, 3 ; LOGIC
056AB7  01 46 F8              ADD    word ptr [bp - 8], ax ; ARITH
056ABA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
056ABD  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
056AC0  39 46 EA              CMP    word ptr [bp - 0x16], ax ; CMP
056AC3  7F 09                 JG     0x56ace ; CJUMP
056AC5  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
056AC8  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
056ACB  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
056ACE  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
056AD1  83 7E FA 08           CMP    word ptr [bp - 6], 8 ; CMP
056AD5  7C 83                 JL     0x56a5a ; CJUMP
056AD7  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
056ADB  74 08                 JE     0x56ae5 ; CJUMP
056ADD  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
056AE0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
056AE3  89 07                 MOV    word ptr [bx], ax ; MOV
056AE5  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
056AE9  74 08                 JE     0x56af3 ; CJUMP
056AEB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
056AEE  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
056AF1  89 07                 MOV    word ptr [bx], ax ; MOV
056AF3  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
056AF7  74 08                 JE     0x56b01 ; CJUMP
056AF9  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
056AFC  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
056AFF  89 07                 MOV    word ptr [bx], ax ; MOV
056B01  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
056B04  5E                    POP    si ; STACK_POP
056B05  C9                    LEAVE ; EPILOGUE
056B06  CB                    RETF ; RETURN
