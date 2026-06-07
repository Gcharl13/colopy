; ============================================================================
; func_042DFA_unknown
; Region   : overlay
; Bytes    : file 0x042DFA..0x042F1F  (293 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042DFA  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
042DFE  56                    PUSH   si ; STACK_PUSH
042DFF  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
042E03  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
042E07  2A E4                 SUB    ah, ah ; ARITH
042E09  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
042E0C  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
042E11  EB 72                 JMP    0x42e85 ; JUMP
042E13  90                    NOP ; NOP
042E14  8B F0                 MOV    si, ax ; MOV
042E16  88 42 FA              MOV    byte ptr [bp + si - 6], al ; LOCAL_STORE
042E19  56                    PUSH   si ; STACK_PUSH
042E1A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042E1D  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
042E22  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042E25  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
042E28  56                    PUSH   si ; STACK_PUSH
042E29  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042E2C  9A 68 0C 1F 18        LCALL  0x181f, 0xc68 ; THUNK -> 0x05EB:0x3040 (thunk @file 0x01B258 type B) overlay @file 0x02A030
042E31  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042E34  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
042E37  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
042E3B  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
042E3F  25 0F 00              AND    ax, 0xf ; LOGIC
042E42  8B F0                 MOV    si, ax ; MOV
042E44  C1 E6 04              SHL    si, 4 ; LOGIC
042E47  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
042E4A  8A 80 BC 84           MOV    al, byte ptr [bx + si - 0x7b44] ; MOV
042E4E  2A E4                 SUB    ah, ah ; ARITH
042E50  C1 E0 04              SHL    ax, 4 ; LOGIC
042E53  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
042E56  83 FB 0F              CMP    bx, 0xf ; CMP
042E59  75 05                 JNE    0x42e60 ; CJUMP
042E5B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
042E60  83 FB 0E              CMP    bx, 0xe ; CMP
042E63  75 05                 JNE    0x42e6a ; CJUMP
042E65  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
042E6A  83 FB 08              CMP    bx, 8 ; CMP
042E6D  75 05                 JNE    0x42e74 ; CJUMP
042E6F  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
042E74  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
042E77  F7 6E F8              IMUL   word ptr [bp - 8] ; ARITH
042E7A  8B 76 F2              MOV    si, word ptr [bp - 0xe] ; LOCAL_LOAD
042E7D  D1 E6                 SHL    si, 1 ; LOGIC
042E7F  89 42 E2              MOV    word ptr [bp + si - 0x1e], ax ; LOCAL_STORE
042E82  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
042E85  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
042E88  39 46 E0              CMP    word ptr [bp - 0x20], ax ; CMP
042E8B  7F 87                 JG     0x42e14 ; CJUMP
042E8D  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
042E90  16                    PUSH   ss ; STACK_PUSH
042E91  50                    PUSH   ax ; STACK_PUSH
042E92  8D 46 E2              LEA    ax, [bp - 0x1e] ; ADDR
042E95  16                    PUSH   ss ; STACK_PUSH
042E96  50                    PUSH   ax ; STACK_PUSH
042E97  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
042E9A  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
042E9F  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
042EA4  EB 3A                 JMP    0x42ee0 ; JUMP
042EA6  B8 27 00              MOV    ax, 0x27 ; CONST_LOAD
042EA9  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
042EAC  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
042EB0  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
042EB4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
042EB7  03 46 EE              ADD    ax, word ptr [bp - 0x12] ; ARITH
042EBA  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
042EBE  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
042EC1  8B F0                 MOV    si, ax ; MOV
042EC3  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
042EC8  8B C6                 MOV    ax, si ; MOV
042ECA  D1 E6                 SHL    si, 1 ; LOGIC
042ECC  03 F0                 ADD    si, ax ; ARITH
042ECE  C1 E6 02              SHL    si, 2 ; LOGIC
042ED1  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
042ED5  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
042ED9  40                    INC    ax ; ARITH
042EDA  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
042EDD  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
042EE0  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
042EE3  39 46 E0              CMP    word ptr [bp - 0x20], ax ; CMP
042EE6  7E 34                 JLE    0x42f1c ; CJUMP
042EE8  8B F0                 MOV    si, ax ; MOV
042EEA  8A 42 FA              MOV    al, byte ptr [bp + si - 6] ; LOCAL_LOAD
042EED  2A E4                 SUB    ah, ah ; ARITH
042EEF  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
042EF2  50                    PUSH   ax ; STACK_PUSH
042EF3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042EF6  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
042EFB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042EFE  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
042F01  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
042F04  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042F07  9A 68 0C 1F 18        LCALL  0x181f, 0xc68 ; THUNK -> 0x05EB:0x3040 (thunk @file 0x01B258 type B) overlay @file 0x02A030
042F0C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042F0F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
042F12  3D 64 00              CMP    ax, 0x64 ; CMP
042F15  7C 8F                 JL     0x42ea6 ; CJUMP
042F17  B8 17 00              MOV    ax, 0x17 ; CONST_LOAD
042F1A  EB 8D                 JMP    0x42ea9 ; JUMP
042F1C  5E                    POP    si ; STACK_POP
042F1D  C9                    LEAVE ; EPILOGUE
042F1E  CB                    RETF ; RETURN
