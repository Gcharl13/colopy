; ============================================================================
; func_040656_unknown
; Region   : overlay
; Bytes    : file 0x040656..0x040701  (171 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040656  C8 2A 00 00           ENTER  0x2a, 0 ; PROLOGUE
04065A  56                    PUSH   si ; STACK_PUSH
04065B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04065F  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
040663  2A E4                 SUB    ah, ah ; ARITH
040665  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
040668  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
04066C  2A ED                 SUB    ch, ch ; ARITH
04066E  89 4E E6              MOV    word ptr [bp - 0x1a], cx ; LOCAL_STORE
040671  51                    PUSH   cx ; STACK_PUSH
040672  50                    PUSH   ax ; STACK_PUSH
040673  8B F3                 MOV    si, bx ; MOV
040675  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04067A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04067D  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
040680  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
040683  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
040686  9A 0E 07 1F 18        LCALL  0x181f, 0x70e ; THUNK -> 0x037F:0x00F6 (thunk @file 0x01ACFE type B) overlay @file 0x02EC32
04068B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04068E  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
040691  89 56 DE              MOV    word ptr [bp - 0x22], dx ; LOCAL_STORE
040694  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
040697  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
04069A  9A 40 07 1F 18        LCALL  0x181f, 0x740 ; THUNK -> 0x037F:0x012A (thunk @file 0x01AD30 type B) overlay @file 0x02EC66
04069F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0406A2  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0406A5  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
0406A8  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
0406AB  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
0406AE  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
0406B3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0406B6  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0406B9  8A 84 47 31           MOV    al, byte ptr [si + 0x3147] ; MOV
0406BD  25 0F 00              AND    ax, 0xf ; LOGIC
0406C0  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
0406C3  83 7E F2 08           CMP    word ptr [bp - 0xe], 8 ; CMP
0406C7  7C 06                 JL     0x406cf ; CJUMP
0406C9  83 7E F2 10           CMP    word ptr [bp - 0xe], 0x10 ; CMP
0406CD  7C 0C                 JL     0x406db ; CJUMP
0406CF  83 7E F2 10           CMP    word ptr [bp - 0xe], 0x10 ; CMP
0406D3  7C 0D                 JL     0x406e2 ; CJUMP
0406D5  83 7E F2 18           CMP    word ptr [bp - 0xe], 0x18 ; CMP
0406D9  7D 07                 JGE    0x406e2 ; CJUMP
0406DB  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
0406E0  EB 2C                 JMP    0x4070e ; JUMP
0406E2  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
0406E5  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
0406E8  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
0406ED  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0406F0  A8 40                 TEST   al, 0x40 ; LOGIC
0406F2  74 03                 JE     0x406f7 ; CJUMP
0406F4  E9 D3 02              JMP    0x409ca ; JUMP
0406F7  83 7E F2 19           CMP    word ptr [bp - 0xe], 0x19 ; CMP
0406FB  75 03                 JNE    0x40700 ; CJUMP
0406FD  E9 CA 02              JMP    0x409ca ; JUMP
040700  83                    DB     0x83 ; DATA_BYTE
