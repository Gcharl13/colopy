; ============================================================================
; func_077990_unknown
; Region   : overlay
; Bytes    : file 0x077990..0x0779D5  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077990  C8 2E 00 00           ENTER  0x2e, 0 ; PROLOGUE
077994  52                    PUSH   dx ; STACK_PUSH
077995  50                    PUSH   ax ; STACK_PUSH
077996  53                    PUSH   bx ; STACK_PUSH
077997  56                    PUSH   si ; STACK_PUSH
077998  C7 46 D6 01 00        MOV    word ptr [bp - 0x2a], 1 ; LOCAL_STORE
07799D  1E                    PUSH   ds ; STACK_PUSH
07799E  50                    PUSH   ax ; STACK_PUSH
07799F  8D 1E 6A 24           LEA    bx, [0x246a] ; ADDR
0779A3  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
0779A8  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
0779AB  0B C0                 OR     ax, ax ; LOGIC
0779AD  74 6E                 JE     0x77a1d ; CJUMP
0779AF  C7 46 D4 01 00        MOV    word ptr [bp - 0x2c], 1 ; LOCAL_STORE
0779B4  EB 03                 JMP    0x779b9 ; JUMP
0779B6  FF 46 D4              INC    word ptr [bp - 0x2c] ; ARITH
0779B9  8B 46 D0              MOV    ax, word ptr [bp - 0x30] ; LOCAL_LOAD
0779BC  39 46 D4              CMP    word ptr [bp - 0x2c], ax ; CMP
0779BF  7F 1F                 JG     0x779e0 ; CJUMP
0779C1  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
0779C4  F6 47 06 10           TEST   byte ptr [bx + 6], 0x10 ; LOGIC
0779C8  75 53                 JNE    0x77a1d ; CJUMP
0779CA  53                    PUSH   bx ; STACK_PUSH
0779CB  6A 24                 PUSH   0x24 ; PUSH_CONST
0779CD  8D 46 D8              LEA    ax, [bp - 0x28] ; ADDR
0779D0  50                    PUSH   ax ; STACK_PUSH
0779D1  9A                    DB     0x9A ; DATA_BYTE
0779D2  CA                    DB     0xCA ; DATA_BYTE
0779D3  09                    DB     0x09 ; DATA_BYTE
0779D4  1D                    DB     0x1D ; DATA_BYTE
