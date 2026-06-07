; ============================================================================
; func_0681A8_unknown
; Region   : overlay
; Bytes    : file 0x0681A8..0x06824D  (165 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0681A8  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
0681AC  50                    PUSH   ax ; STACK_PUSH
0681AD  56                    PUSH   si ; STACK_PUSH
0681AE  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0 ; LOCAL_STORE
0681B3  C4 1E 94 A5           LES    bx, ptr [0xa594] ; MOV_FAR
0681B7  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
0681BA  A2 9F A8              MOV    byte ptr [0xa89f], al ; GLOBAL_LOAD
0681BD  C4 1E 98 A5           LES    bx, ptr [0xa598] ; MOV_FAR
0681C1  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
0681C4  A2 A1 A8              MOV    byte ptr [0xa8a1], al ; GLOBAL_LOAD
0681C7  C4 1E 9C A5           LES    bx, ptr [0xa59c] ; MOV_FAR
0681CB  26 8A 0F              MOV    cl, byte ptr es:[bx] ; MOV
0681CE  88 0E A0 A8           MOV    byte ptr [0xa8a0], cl ; GLOBAL_LOAD
0681D2  2A E4                 SUB    ah, ah ; ARITH
0681D4  50                    PUSH   ax ; STACK_PUSH
0681D5  9A AA 06 1F 18        LCALL  0x181f, 0x6aa ; THUNK -> 0x037F:0x0614 (thunk @file 0x01AC9A type B) overlay @file 0x02F150
0681DA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0681DD  A2 A2 A8              MOV    byte ptr [0xa8a2], al ; GLOBAL_LOAD
0681E0  80 3E 9E A8 00        CMP    byte ptr [0xa89e], 0 ; CMP
0681E5  74 09                 JE     0x681f0 ; CJUMP
0681E7  A0 9E A8              MOV    al, byte ptr [0xa89e] ; GLOBAL_LOAD
0681EA  84 06 A0 A8           TEST   byte ptr [0xa8a0], al ; LOGIC
0681EE  74 06                 JE     0x681f6 ; CJUMP
0681F0  83 7E DA 00           CMP    word ptr [bp - 0x26], 0 ; CMP
0681F4  74 08                 JE     0x681fe ; CJUMP
0681F6  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
0681FB  EB 06                 JMP    0x68203 ; JUMP
0681FD  90                    NOP ; NOP
0681FE  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
068203  A0 A1 A8              MOV    al, byte ptr [0xa8a1] ; GLOBAL_LOAD
068206  25 C0 00              AND    ax, 0xc0 ; LOGIC
068209  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
06820C  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
068210  74 3C                 JE     0x6824e ; CJUMP
068212  B8 95 00              MOV    ax, 0x95 ; CONST_LOAD
068215  E8 B0 FB              CALL   0x67dc8 ; CALL_NEAR
068218  83 3E 84 01 00        CMP    word ptr [0x184], 0 ; CMP
06821D  74 03                 JE     0x68222 ; CJUMP
06821F  E9 B7 03              JMP    0x685d9 ; JUMP
068222  80 3E A2 A8 19        CMP    byte ptr [0xa8a2], 0x19 ; CMP
068227  74 07                 JE     0x68230 ; CJUMP
068229  80 3E A2 A8 1A        CMP    byte ptr [0xa8a2], 0x1a ; CMP
06822E  75 08                 JNE    0x68238 ; CJUMP
068230  C7 46 DE 01 00        MOV    word ptr [bp - 0x22], 1 ; LOCAL_STORE
068235  EB 06                 JMP    0x6823d ; JUMP
068237  90                    NOP ; NOP
068238  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0 ; LOCAL_STORE
06823D  6A 00                 PUSH   0 ; STACK_PUSH
06823F  FF 76 DE              PUSH   word ptr [bp - 0x22] ; PUSH_GLOBAL
068242  6A 01                 PUSH   1 ; STACK_PUSH
068244  E8 09 FD              CALL   0x67f50 ; CALL_NEAR
068247  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06824A  5E                    POP    si ; STACK_POP
06824B  C9                    LEAVE ; EPILOGUE
06824C  C3                    RET ; RETURN
