; ============================================================================
; func_029DD4_unknown
; Region   : overlay
; Bytes    : file 0x029DD4..0x029EF7  (291 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029DD4  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
029DD8  57                    PUSH   di ; STACK_PUSH
029DD9  56                    PUSH   si ; STACK_PUSH
029DDA  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
029DDD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
029DE0  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
029DE3  0E                    PUSH   cs ; STACK_PUSH
029DE4  E8 64 2C              CALL   0x2ca4b ; CALL_NEAR
029DE7  3D 02 00              CMP    ax, 2 ; CMP
029DEA  74 03                 JE     0x29def ; CJUMP
029DEC  E9 C9 02              JMP    0x2a0b8 ; JUMP
029DEF  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
029DF4  E9 B5 00              JMP    0x29eac ; JUMP
029DF7  90                    NOP ; NOP
029DF8  0B C0                 OR     ax, ax ; LOGIC
029DFA  7D 03                 JGE    0x29dff ; CJUMP
029DFC  E9 AA 00              JMP    0x29ea9 ; JUMP
029DFF  50                    PUSH   ax ; STACK_PUSH
029E00  9A CE 0A 1F 18        LCALL  0x181f, 0xace ; THUNK -> 0x05EB:0x14D6 (thunk @file 0x01B0BE type B) overlay @file 0x0284C6
029E05  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029E08  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
029E0B  0B C0                 OR     ax, ax ; LOGIC
029E0D  7D 03                 JGE    0x29e12 ; CJUMP
029E0F  E9 97 00              JMP    0x29ea9 ; JUMP
029E12  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029E15  9A AA 0B 1F 18        LCALL  0x181f, 0xbaa ; THUNK -> 0x05EB:0x1568 (thunk @file 0x01B19A type B) overlay @file 0x028558
029E1A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029E1D  0B C0                 OR     ax, ax ; LOGIC
029E1F  7E 0D                 JLE    0x29e2e ; CJUMP
029E21  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029E24  9A AA 0B 1F 18        LCALL  0x181f, 0xbaa ; THUNK -> 0x05EB:0x1568 (thunk @file 0x01B19A type B) overlay @file 0x028558
029E29  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029E2C  EB 0E                 JMP    0x29e3c ; JUMP
029E2E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029E31  9A AA 0B 1F 18        LCALL  0x181f, 0xbaa ; THUNK -> 0x05EB:0x1568 (thunk @file 0x01B19A type B) overlay @file 0x028558
029E36  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029E39  F7 D0                 NOT    ax ; LOGIC
029E3B  40                    INC    ax ; ARITH
029E3C  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
029E3F  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
029E42  8A 87 3C 02           MOV    al, byte ptr [bx + 0x23c] ; MOV
029E46  98                    CWDE ; ARITH
029E47  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
029E4A  50                    PUSH   ax ; STACK_PUSH
029E4B  8A 87 42 02           MOV    al, byte ptr [bx + 0x242] ; MOV
029E4F  98                    CWDE ; ARITH
029E50  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
029E53  50                    PUSH   ax ; STACK_PUSH
029E54  8A 87 48 02           MOV    al, byte ptr [bx + 0x248] ; MOV
029E58  98                    CWDE ; ARITH
029E59  50                    PUSH   ax ; STACK_PUSH
029E5A  50                    PUSH   ax ; STACK_PUSH
029E5B  6A 02                 PUSH   2 ; STACK_PUSH
029E5D  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
029E60  05 52 00              ADD    ax, 0x52 ; ARITH
029E63  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
029E66  8B DA                 MOV    bx, dx ; MOV
029E68  9A 0E 02 1F 18        LCALL  0x181f, 0x20e ; THUNK -> 0x0097:0x02DA (thunk @file 0x01A7FE type B) overlay @file 0x0273A6
029E6D  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
029E70  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
029E73  9A 88 0A 1F 18        LCALL  0x181f, 0xa88 ; THUNK -> 0x05EB:0x14AA (thunk @file 0x01B078 type B) overlay @file 0x02849A
029E78  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029E7B  0B C0                 OR     ax, ax ; LOGIC
029E7D  75 13                 JNE    0x29e92 ; CJUMP
029E7F  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
029E82  7C 25                 JL     0x29ea9 ; CJUMP
029E84  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
029E88  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
029E8B  98                    CWDE ; ARITH
029E8C  03 46 F2              ADD    ax, word ptr [bp - 0xe] ; ARITH
029E8F  EB 15                 JMP    0x29ea6 ; JUMP
029E91  90                    NOP ; NOP
029E92  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
029E96  7C 11                 JL     0x29ea9 ; CJUMP
029E98  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
029E9B  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
029E9E  9A F4 0C 1F 18        LCALL  0x181f, 0xcf4 ; THUNK -> 0x05EB:0x142A (thunk @file 0x01B2E4 type B) overlay @file 0x02841A
029EA3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
029EA6  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
029EA9  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
029EAC  83 7E F4 0F           CMP    word ptr [bp - 0xc], 0xf ; CMP
029EB0  7C 03                 JL     0x29eb5 ; CJUMP
029EB2  E9 A3 00              JMP    0x29f58 ; JUMP
029EB5  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
029EB9  7C 03                 JL     0x29ebe ; CJUMP
029EBB  E9 9A 00              JMP    0x29f58 ; JUMP
029EBE  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
029EC1  C1 E3 02              SHL    bx, 2 ; LOGIC
029EC4  8B 87 66 02           MOV    ax, word ptr [bx + 0x266] ; MOV
029EC8  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
029ECB  8B 8F 68 02           MOV    cx, word ptr [bx + 0x268] ; MOV
029ECF  83 C1 08              ADD    cx, 8 ; ARITH
029ED2  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
029ED5  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
029ED8  8A 97 62 8D           MOV    dl, byte ptr [bx - 0x729e] ; MOV
029EDC  2A F6                 SUB    dh, dh ; ARITH
029EDE  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
029EE1  8B F2                 MOV    si, dx ; MOV
029EE3  8B F8                 MOV    di, ax ; MOV
029EE5  8A 84 36 02           MOV    al, byte ptr [si + 0x236] ; MOV
029EE9  98                    CWDE ; ARITH
029EEA  50                    PUSH   ax ; STACK_PUSH
029EEB  8A 84 30 02           MOV    al, byte ptr [si + 0x230] ; MOV
029EEF  98                    CWDE ; ARITH
029EF0  50                    PUSH   ax ; STACK_PUSH
029EF1  51                    PUSH   cx ; STACK_PUSH
029EF2  57                    PUSH   di ; STACK_PUSH
029EF3  9A                    DB     0x9A ; DATA_BYTE
029EF4  CA                    DB     0xCA ; DATA_BYTE
029EF5  03                    DB     0x03 ; DATA_BYTE
029EF6  1F                    DB     0x1F ; DATA_BYTE
