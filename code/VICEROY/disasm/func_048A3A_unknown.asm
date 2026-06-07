; ============================================================================
; func_048A3A_unknown
; Region   : overlay
; Bytes    : file 0x048A3A..0x048A89  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048A3A  C8 38 00 00           ENTER  0x38, 0 ; PROLOGUE
048A3E  A1 52 8D              MOV    ax, word ptr [0x8d52] ; GLOBAL_LOAD
048A41  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
048A44  A1 4C 8D              MOV    ax, word ptr [0x8d4c] ; GLOBAL_LOAD
048A47  89 46 CC              MOV    word ptr [bp - 0x34], ax ; LOCAL_STORE
048A4A  2B C0                 SUB    ax, ax ; ARITH
048A4C  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
048A4F  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
048A52  89 46 D0              MOV    word ptr [bp - 0x30], ax ; LOCAL_STORE
048A55  EB 2A                 JMP    0x48a81 ; JUMP
048A57  90                    NOP ; NOP
048A58  FF 76 D0              PUSH   word ptr [bp - 0x30] ; PUSH_GLOBAL
048A5B  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
048A60  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
048A63  8B 46 D6              MOV    ax, word ptr [bp - 0x2a] ; LOCAL_LOAD
048A66  39 06 52 8D           CMP    word ptr [0x8d52], ax ; CMP
048A6A  75 12                 JNE    0x48a7e ; CJUMP
048A6C  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048A70  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
048A73  25 0F 00              AND    ax, 0xf ; LOGIC
048A76  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
048A79  75 03                 JNE    0x48a7e ; CJUMP
048A7B  FF 46 D4              INC    word ptr [bp - 0x2c] ; ARITH
048A7E  FF 46 D0              INC    word ptr [bp - 0x30] ; ARITH
048A81  A1 9A 53              MOV    ax, word ptr [0x539a] ; GLOBAL_LOAD
048A84  39 46 D0              CMP    word ptr [bp - 0x30], ax ; CMP
048A87  7C CF                 JL     0x48a58 ; CJUMP
