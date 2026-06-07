; ============================================================================
; func_053AA0_unknown
; Region   : overlay
; Bytes    : file 0x053AA0..0x053B0E  (110 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053AA0  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
053AA4  56                    PUSH   si ; STACK_PUSH
053AA5  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
053AAA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
053AAD  C1 E3 02              SHL    bx, 2 ; LOGIC
053AB0  8A 87 66 08           MOV    al, byte ptr [bx + 0x866] ; MOV
053AB4  2A E4                 SUB    ah, ah ; ARITH
053AB6  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
053AB9  8A 87 64 08           MOV    al, byte ptr [bx + 0x864] ; MOV
053ABD  50                    PUSH   ax ; STACK_PUSH
053ABE  9A B0 0A 1F 18        LCALL  0x181f, 0xab0 ; THUNK -> 0x05EB:0x039E (thunk @file 0x01B0A0 type B) overlay @file 0x02738E
053AC3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
053AC6  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
053AC9  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
053ACC  D1 E3                 SHL    bx, 1 ; LOGIC
053ACE  83 BF C8 8D 03        CMP    word ptr [bx - 0x7238], 3 ; CMP
053AD3  72 05                 JB     0x53ada ; CJUMP
053AD5  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2 ; LOCAL_STORE
053ADA  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
053ADD  D1 E3                 SHL    bx, 1 ; LOGIC
053ADF  83 BF C8 8D 08        CMP    word ptr [bx - 0x7238], 8 ; CMP
053AE4  72 05                 JB     0x53aeb ; CJUMP
053AE6  C7 46 F8 03 00        MOV    word ptr [bp - 8], 3 ; LOCAL_STORE
053AEB  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
053AEE  D1 E6                 SHL    si, 1 ; LOGIC
053AF0  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053AF4  83 B8 9A 00 64        CMP    word ptr [bx + si + 0x9a], 0x64 ; CMP
053AF9  7C 05                 JL     0x53b00 ; CJUMP
053AFB  C7 46 F8 03 00        MOV    word ptr [bp - 8], 3 ; LOCAL_STORE
053B00  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
053B03  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
053B06  7D 06                 JGE    0x53b0e ; CJUMP
053B08  B8 01 00              MOV    ax, 1 ; MOV
053B0B  5E                    POP    si ; STACK_POP
053B0C  C9                    LEAVE ; EPILOGUE
053B0D  CB                    RETF ; RETURN
