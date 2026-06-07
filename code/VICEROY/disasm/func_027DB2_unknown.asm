; ============================================================================
; func_027DB2_unknown
; Region   : overlay
; Bytes    : file 0x027DB2..0x027E70  (190 bytes)
; Purpose  : random_int (overlay 0x09EF:0x0032 — BYTE_VERIFIED helper)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED (2026-05-04)
; Tagged: "BUILD"  (auto-named via string xrefs)
; ============================================================================

027DB2  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
027DB6  56                    PUSH   si ; STACK_PUSH
027DB7  6A 30                 PUSH   0x30 ; PUSH_CONST
027DB9  6A 54                 PUSH   0x54 ; PUSH_CONST
027DBB  68 82 00              PUSH   0x82 ; PUSH_CONST
027DBE  6A 79                 PUSH   0x79 ; PUSH_CONST
027DC0  0E                    PUSH   cs ; STACK_PUSH
027DC1  E8 FF 4C              CALL   0x2cac3 ; CALL_NEAR
027DC4  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
027DC7  83 3E 3C 03 00        CMP    word ptr [0x33c], 0 ; CMP
027DCC  75 68                 JNE    0x27e36 ; CJUMP
027DCE  6A 39                 PUSH   0x39 ; PUSH_CONST
027DD0  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
027DD3  6A 54                 PUSH   0x54 ; PUSH_CONST
027DD5  6A 79                 PUSH   0x79 ; PUSH_CONST
027DD7  FF 36 D0 2D           PUSH   word ptr [0x2dd0] ; PUSH_GLOBAL
027DDB  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
027DE0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027DE3  52                    PUSH   dx ; STACK_PUSH
027DE4  50                    PUSH   ax ; STACK_PUSH
027DE5  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
027DEA  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
027DED  C7 46 9E 00 00        MOV    word ptr [bp - 0x62], 0 ; LOCAL_STORE
027DF2  EB 03                 JMP    0x27df7 ; JUMP
027DF4  FF 46 9E              INC    word ptr [bp - 0x62] ; ARITH
027DF7  83 7E 9E 06           CMP    word ptr [bp - 0x62], 6 ; CMP
027DFB  7C 03                 JL     0x27e00 ; CJUMP
027DFD  E9 2E 03              JMP    0x2812e ; JUMP
027E00  8D 46 98              LEA    ax, [bp - 0x68] ; ADDR
027E03  50                    PUSH   ax ; STACK_PUSH
027E04  8D 46 9A              LEA    ax, [bp - 0x66] ; ADDR
027E07  50                    PUSH   ax ; STACK_PUSH
027E08  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
027E0B  50                    PUSH   ax ; STACK_PUSH
027E0C  8D 4E A6              LEA    cx, [bp - 0x5a] ; ADDR
027E0F  51                    PUSH   cx ; STACK_PUSH
027E10  FF 76 9E              PUSH   word ptr [bp - 0x62] ; PUSH_GLOBAL
027E13  0E                    PUSH   cs ; STACK_PUSH
027E14  E8 C1 4B              CALL   0x2c9d8 ; CALL_NEAR
027E17  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
027E1A  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
027E1E  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
027E22  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
027E25  B8 7B 00              MOV    ax, 0x7b ; CONST_LOAD
027E28  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
027E2C  8B 56 A6              MOV    dx, word ptr [bp - 0x5a] ; LOCAL_LOAD
027E2F  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
027E34  EB BE                 JMP    0x27df4 ; JUMP
027E36  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
027E3A  FF 36 E8 2D           PUSH   word ptr [0x2de8] ; PUSH_GLOBAL
027E3E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
027E41  50                    PUSH   ax ; STACK_PUSH
027E42  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
027E47  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
027E4A  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
027E4D  50                    PUSH   ax ; STACK_PUSH
027E4E  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
027E53  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027E56  FF 36 3E 03           PUSH   word ptr [0x33e] ; PUSH_GLOBAL
027E5A  9A 32 0B 1F 18        LCALL  0x181f, 0xb32 ; THUNK -> 0x05EB:0x2F8E (thunk @file 0x01B122 type B) overlay @file 0x029F7E
027E5F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027E62  89 46 90              MOV    word ptr [bp - 0x70], ax ; LOCAL_STORE
027E65  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
027E68  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
027E6C  2A FF                 SUB    bh, bh ; ARITH
027E6E  8B C3                 MOV    ax, bx ; MOV
