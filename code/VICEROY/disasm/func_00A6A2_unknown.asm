; ============================================================================
; func_00A6A2_unknown
; Region   : load_image
; Bytes    : file 0x00A6A2..0x00A724  (130 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A6A2  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
00A6A6  56                    PUSH   si ; STACK_PUSH
00A6A7  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
00A6AC  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00A6B0  8A 07                 MOV    al, byte ptr [bx] ; MOV
00A6B2  2A E4                 SUB    ah, ah ; ARITH
00A6B4  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
00A6B7  48                    DEC    ax ; ARITH
00A6B8  48                    DEC    ax ; ARITH
00A6B9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00A6BC  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
00A6BF  2A E4                 SUB    ah, ah ; ARITH
00A6C1  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
00A6C4  48                    DEC    ax ; ARITH
00A6C5  48                    DEC    ax ; ARITH
00A6C6  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00A6C9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00A6CC  48                    DEC    ax ; ARITH
00A6CD  48                    DEC    ax ; ARITH
00A6CE  0B C0                 OR     ax, ax ; LOGIC
00A6D0  7F 08                 JG     0xa6da ; CJUMP
00A6D2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00A6D5  48                    DEC    ax ; ARITH
00A6D6  48                    DEC    ax ; ARITH
00A6D7  F7 D0                 NOT    ax ; LOGIC
00A6D9  40                    INC    ax ; ARITH
00A6DA  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
00A6DD  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00A6E0  48                    DEC    ax ; ARITH
00A6E1  48                    DEC    ax ; ARITH
00A6E2  0B C0                 OR     ax, ax ; LOGIC
00A6E4  7F 08                 JG     0xa6ee ; CJUMP
00A6E6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00A6E9  48                    DEC    ax ; ARITH
00A6EA  48                    DEC    ax ; ARITH
00A6EB  F7 D0                 NOT    ax ; LOGIC
00A6ED  40                    INC    ax ; ARITH
00A6EE  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
00A6F1  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00A6F4  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00A6F7  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00A6FC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A6FF  0B C0                 OR     ax, ax ; LOGIC
00A701  74 17                 JE     0xa71a ; CJUMP
00A703  0E                    PUSH   cs ; STACK_PUSH
00A704  E8 19 E0              CALL   0x8720 ; CALL_NEAR
00A707  50                    PUSH   ax ; STACK_PUSH
00A708  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
00A70B  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
00A70E  9A 3C 00 7F 03        LCALL  0x37f, 0x3c ; LCALL
00A713  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00A716  0B C0                 OR     ax, ax ; LOGIC
00A718  75 0A                 JNE    0xa724 ; CJUMP
00A71A  80 4E FA 10           OR     byte ptr [bp - 6], 0x10 ; LOGIC
00A71E  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00A721  5E                    POP    si ; STACK_POP
00A722  C9                    LEAVE ; EPILOGUE
00A723  CB                    RETF ; RETURN
