; ============================================================================
; func_0235D6_unknown
; Region   : overlay
; Bytes    : file 0x0235D6..0x023641  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0235D6  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
0235DA  2B C0                 SUB    ax, ax ; ARITH
0235DC  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0235DF  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0235E2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0235E5  3D 1A 00              CMP    ax, 0x1a ; CMP
0235E8  74 34                 JE     0x2361e ; CJUMP
0235EA  7E 03                 JLE    0x235ef ; CJUMP
0235EC  E9 D9 07              JMP    0x23dc8 ; JUMP
0235EF  48                    DEC    ax ; ARITH
0235F0  74 0C                 JE     0x235fe ; CJUMP
0235F2  48                    DEC    ax ; ARITH
0235F3  74 11                 JE     0x23606 ; CJUMP
0235F5  48                    DEC    ax ; ARITH
0235F6  74 16                 JE     0x2360e ; CJUMP
0235F8  48                    DEC    ax ; ARITH
0235F9  74 1B                 JE     0x23616 ; CJUMP
0235FB  E9 18 09              JMP    0x23f16 ; JUMP
0235FE  0E                    PUSH   cs ; STACK_PUSH
0235FF  E8 B2 15              CALL   0x24bb4 ; CALL_NEAR
023602  E9 11 09              JMP    0x23f16 ; JUMP
023605  90                    NOP ; NOP
023606  0E                    PUSH   cs ; STACK_PUSH
023607  E8 DC 15              CALL   0x24be6 ; CALL_NEAR
02360A  E9 09 09              JMP    0x23f16 ; JUMP
02360D  90                    NOP ; NOP
02360E  0E                    PUSH   cs ; STACK_PUSH
02360F  E8 16 15              CALL   0x24b28 ; CALL_NEAR
023612  E9 01 09              JMP    0x23f16 ; JUMP
023615  90                    NOP ; NOP
023616  0E                    PUSH   cs ; STACK_PUSH
023617  E8 1D 15              CALL   0x24b37 ; CALL_NEAR
02361A  E9 F9 08              JMP    0x23f16 ; JUMP
02361D  90                    NOP ; NOP
02361E  9A 2E 03 1F 19        LCALL  0x191f, 0x32e ; THUNK -> 0x0000:0x030A (thunk @file 0x01B91E type A) overlay @file 0x025C0A
023623  E9 F0 08              JMP    0x23f16 ; JUMP
023626  9A 20 03 1F 19        LCALL  0x191f, 0x320 ; THUNK -> 0x0000:0x04E8 (thunk @file 0x01B910 type A) overlay @file 0x025DE8
02362B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02362E  0B C0                 OR     ax, ax ; LOGIC
023630  75 03                 JNE    0x23635 ; CJUMP
023632  E9 DE 02              JMP    0x23913 ; JUMP
023635  48                    DEC    ax ; ARITH
023636  48                    DEC    ax ; ARITH
023637  74 03                 JE     0x2363c ; CJUMP
023639  E9 DA 08              JMP    0x23f16 ; JUMP
02363C  C7                    DB     0xC7 ; DATA_BYTE
02363D  06                    DB     0x06 ; DATA_BYTE
02363E  C2                    DB     0xC2 ; DATA_BYTE
02363F  53                    DB     0x53 ; DATA_BYTE
023640  00                    DB     0x00 ; DATA_BYTE
