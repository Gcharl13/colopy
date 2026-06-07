; ============================================================================
; func_0789FA_unknown
; Region   : overlay
; Bytes    : file 0x0789FA..0x078A4A  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0789FA  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0789FE  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
078A01  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
078A04  81 7E FC 00 A0        CMP    word ptr [bp - 4], 0xa000 ; CMP
078A09  72 05                 JB     0x78a10 ; CJUMP
078A0B  B8 01 00              MOV    ax, 1 ; MOV
078A0E  EB 02                 JMP    0x78a12 ; JUMP
078A10  2B C0                 SUB    ax, ax ; ARITH
078A12  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
078A15  48                    DEC    ax ; ARITH
078A16  75 10                 JNE    0x78a28 ; CJUMP
078A18  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
078A1B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
078A1E  9A D4 0F 1F 1A        LCALL  0x1a1f, 0xfd4 ; THUNK -> 0x1103:0x004C (thunk @file 0x01D5C4 type B) overlay @file 0x0305A8
078A23  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
078A26  EB 0C                 JMP    0x78a34 ; JUMP
078A28  C4 46 06              LES    ax, ptr [bp + 6] ; MOV_FAR
078A2B  B4 49                 MOV    ah, 0x49 ; CONST_LOAD
078A2D  CD 21                 INT    0x21 ; SYS
078A2F  D0 D8                 RCR    al, 1 ; LOGIC
078A31  98                    CWDE ; ARITH
078A32  8A C4                 MOV    al, ah ; MOV
078A34  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
078A37  FF 36 70 26           PUSH   word ptr [0x2670] ; PUSH_GLOBAL
078A3B  FF 36 6E 26           PUSH   word ptr [0x266e] ; PUSH_GLOBAL
078A3F  0E                    PUSH   cs ; STACK_PUSH
078A40  E8 AA 00              CALL   0x78aed ; CALL_NEAR
078A43  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
078A46  C9                    LEAVE ; EPILOGUE
078A47  CA 04 00              RETF   4 ; RETURN
