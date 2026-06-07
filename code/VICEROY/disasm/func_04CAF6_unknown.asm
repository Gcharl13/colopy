; ============================================================================
; func_04CAF6_unknown
; Region   : overlay
; Bytes    : file 0x04CAF6..0x04CB6D  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CAF6  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
04CAFA  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04CAFD  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04CB00  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
04CB05  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CB08  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
04CB0B  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
04CB0E  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04CB11  A3 A8 9E              MOV    word ptr [0x9ea8], ax ; GLOBAL_LOAD
04CB14  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
04CB19  E9 C0 00              JMP    0x4cbdc ; JUMP
04CB1C  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
04CB21  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
04CB24  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
04CB27  FF 76 F4              PUSH   word ptr [bp - 0xc] ; PUSH_GLOBAL
04CB2A  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04CB2D  0E                    PUSH   cs ; STACK_PUSH
04CB2E  E8 F9 69              CALL   0x5352a ; CALL_NEAR
04CB31  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04CB34  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04CB37  0B C0                 OR     ax, ax ; LOGIC
04CB39  7C 62                 JL     0x4cb9d ; CJUMP
04CB3B  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
04CB3F  74 5C                 JE     0x4cb9d ; CJUMP
04CB41  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
04CB46  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04CB49  8B 56 FC              MOV    dx, word ptr [bp - 4] ; LOCAL_LOAD
04CB4C  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
04CB51  EB 38                 JMP    0x4cb8b ; JUMP
04CB53  90                    NOP ; NOP
04CB54  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
04CB57  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
04CB5C  72 25                 JB     0x4cb83 ; CJUMP
04CB5E  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
04CB63  77 1E                 JA     0x4cb83 ; CJUMP
04CB65  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
04CB69  2A FF                 SUB    bh, bh ; ARITH
04CB6B  8B C3                 MOV    ax, bx ; MOV
