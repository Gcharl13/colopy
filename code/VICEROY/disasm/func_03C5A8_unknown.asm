; ============================================================================
; func_03C5A8_unknown
; Region   : overlay
; Bytes    : file 0x03C5A8..0x03C5FB  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C5A8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03C5AC  56                    PUSH   si ; STACK_PUSH
03C5AD  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
03C5B0  48                    DEC    ax ; ARITH
03C5B1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03C5B4  EB 78                 JMP    0x3c62e ; JUMP
03C5B6  90                    NOP ; NOP
03C5B7  90                    NOP ; NOP
03C5B8  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C5BC  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03C5C0  24 0F                 AND    al, 0xf ; LOGIC
03C5C2  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
03C5C5  75 64                 JNE    0x3c62b ; CJUMP
03C5C7  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C5CB  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
03C5CF  2A E4                 SUB    ah, ah ; ARITH
03C5D1  50                    PUSH   ax ; STACK_PUSH
03C5D2  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
03C5D6  50                    PUSH   ax ; STACK_PUSH
03C5D7  8B F3                 MOV    si, bx ; MOV
03C5D9  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
03C5DE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03C5E1  0B C0                 OR     ax, ax ; LOGIC
03C5E3  75 46                 JNE    0x3c62b ; CJUMP
03C5E5  80 BC 46 31 0D        CMP    byte ptr [si + 0x3146], 0xd ; CMP
03C5EA  72 34                 JB     0x3c620 ; CJUMP
03C5EC  80 BC 46 31 12        CMP    byte ptr [si + 0x3146], 0x12 ; CMP
03C5F1  77 2D                 JA     0x3c620 ; CJUMP
03C5F3  8A 9C 46 31           MOV    bl, byte ptr [si + 0x3146] ; MOV
03C5F7  2A FF                 SUB    bh, bh ; ARITH
03C5F9  8B C3                 MOV    ax, bx ; MOV
