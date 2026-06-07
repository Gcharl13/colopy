; ============================================================================
; func_03DE46_unknown
; Region   : overlay
; Bytes    : file 0x03DE46..0x03DED0  (138 bytes)
; Purpose  : Independence event handler  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

03DE46  C8 24 03 00           ENTER  0x324, 0 ; PROLOGUE
03DE4A  57                    PUSH   di ; STACK_PUSH
03DE4B  56                    PUSH   si ; STACK_PUSH
03DE4C  A1 98 53              MOV    ax, word ptr [0x5398] ; GLOBAL_LOAD
03DE4F  89 86 DC FC           MOV    word ptr [bp - 0x324], ax ; LOCAL_STORE
03DE53  50                    PUSH   ax ; STACK_PUSH
03DE54  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03DE59  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03DE5C  A1 8A 53              MOV    ax, word ptr [0x538a] ; GLOBAL_LOAD
03DE5F  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
03DE62  99                    CDQ ; ARITH
03DE63  F7 F9                 IDIV   cx ; ARITH
03DE65  88 16 A8 53           MOV    byte ptr [0x53a8], dl ; GLOBAL_LOAD
03DE69  A1 8A 53              MOV    ax, word ptr [0x538a] ; GLOBAL_LOAD
03DE6C  99                    CDQ ; ARITH
03DE6D  F7 F9                 IDIV   cx ; ARITH
03DE6F  A2 A7 53              MOV    byte ptr [0x53a7], al ; GLOBAL_LOAD
03DE72  2B C0                 SUB    ax, ax ; ARITH
03DE74  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03DE77  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03DE7B  89 47 0C              MOV    word ptr [bx + 0xc], ax ; MOV
03DE7E  39 06 D2 53           CMP    word ptr [0x53d2], ax ; CMP
03DE82  7D 04                 JGE    0x3de88 ; CJUMP
03DE84  0E                    PUSH   cs ; STACK_PUSH
03DE85  E8 83 0B              CALL   0x3ea0b ; CALL_NEAR
03DE88  6A 03                 PUSH   3 ; STACK_PUSH
03DE8A  9A AC 04 1F 18        LCALL  0x181f, 0x4ac ; THUNK -> 0x029F:0x0318 (thunk @file 0x01AA9C type B) overlay @file 0x022340
03DE8F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03DE92  0E                    PUSH   cs ; STACK_PUSH
03DE93  E8 89 0B              CALL   0x3ea1f ; CALL_NEAR
03DE96  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
03DE9B  8A 46 F2              MOV    al, byte ptr [bp - 0xe] ; LOCAL_LOAD
03DE9E  8B 76 F2              MOV    si, word ptr [bp - 0xe] ; LOCAL_LOAD
03DEA1  88 42 EE              MOV    byte ptr [bp + si - 0x12], al ; LOCAL_STORE
03DEA4  8A 84 18 94           MOV    al, byte ptr [si - 0x6be8] ; MOV
03DEA8  2A E4                 SUB    ah, ah ; ARITH
03DEAA  8B C8                 MOV    cx, ax ; MOV
03DEAC  D1 E0                 SHL    ax, 1 ; LOGIC
03DEAE  03 C1                 ADD    ax, cx ; ARITH
03DEB0  8A 8C 98 92           MOV    cl, byte ptr [si - 0x6d68] ; MOV
03DEB4  2A ED                 SUB    ch, ch ; ARITH
03DEB6  D1 E1                 SHL    cx, 1 ; LOGIC
03DEB8  03 C1                 ADD    ax, cx ; ARITH
03DEBA  8A 8C 10 94           MOV    cl, byte ptr [si - 0x6bf0] ; MOV
03DEBE  2A ED                 SUB    ch, ch ; ARITH
03DEC0  03 C1                 ADD    ax, cx ; ARITH
03DEC2  D1 E6                 SHL    si, 1 ; LOGIC
03DEC4  89 42 E6              MOV    word ptr [bp + si - 0x1a], ax ; LOCAL_STORE
03DEC7  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
03DECA  83 7E F2 04           CMP    word ptr [bp - 0xe], 4 ; CMP
03DECE  7C CB                 JL     0x3de9b ; CJUMP
