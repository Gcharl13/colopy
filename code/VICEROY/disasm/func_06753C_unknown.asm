; ============================================================================
; func_06753C_unknown
; Region   : overlay
; Bytes    : file 0x06753C..0x06760E  (210 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06753C  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
067540  57                    PUSH   di ; STACK_PUSH
067541  56                    PUSH   si ; STACK_PUSH
067542  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
067545  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
067548  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06754B  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
06754E  48                    DEC    ax ; ARITH
06754F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
067552  89 76 F4              MOV    word ptr [bp - 0xc], si ; LOCAL_STORE
067555  03 76 0C              ADD    si, word ptr [bp + 0xc] ; ARITH
067558  4E                    DEC    si ; ARITH
067559  89 76 F2              MOV    word ptr [bp - 0xe], si ; LOCAL_STORE
06755C  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
06755F  50                    PUSH   ax ; STACK_PUSH
067560  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
067563  50                    PUSH   ax ; STACK_PUSH
067564  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
067567  50                    PUSH   ax ; STACK_PUSH
067568  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
06756B  50                    PUSH   ax ; STACK_PUSH
06756C  9A 06 09 1F 1A        LCALL  0x1a1f, 0x906 ; THUNK -> 0x0000:0x000C (thunk @file 0x01CEF6 type A) overlay @file 0x02590C
067571  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
067574  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
067578  80 C1 04              ADD    cl, 4 ; ARITH
06757B  B0 01                 MOV    al, 1 ; MOV
06757D  D2 E0                 SHL    al, cl ; LOGIC
06757F  88 46 FD              MOV    byte ptr [bp - 3], al ; LOCAL_STORE
067582  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
067587  83 3E 9C 53 00        CMP    word ptr [0x539c], 0 ; CMP
06758C  7E 7C                 JLE    0x6760a ; CJUMP
06758E  BE 44 31              MOV    si, 0x3144 ; CONST_LOAD
067591  83 7C 18 00           CMP    word ptr [si + 0x18], 0 ; CMP
067595  7D 65                 JGE    0x675fc ; CJUMP
067597  8A 04                 MOV    al, byte ptr [si] ; MOV
067599  2A E4                 SUB    ah, ah ; ARITH
06759B  8B F8                 MOV    di, ax ; MOV
06759D  8A 4C 01              MOV    cl, byte ptr [si + 1] ; MOV
0675A0  2A ED                 SUB    ch, ch ; ARITH
0675A2  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
0675A5  7C 55                 JL     0x675fc ; CJUMP
0675A7  39 7E F8              CMP    word ptr [bp - 8], di ; CMP
0675AA  7C 50                 JL     0x675fc ; CJUMP
0675AC  39 4E F4              CMP    word ptr [bp - 0xc], cx ; CMP
0675AF  7F 4B                 JG     0x675fc ; CJUMP
0675B1  39 4E F2              CMP    word ptr [bp - 0xe], cx ; CMP
0675B4  7C 46                 JL     0x675fc ; CJUMP
0675B6  8A 44 03              MOV    al, byte ptr [si + 3] ; MOV
0675B9  24 0F                 AND    al, 0xf ; LOGIC
0675BB  3A 06 96 53           CMP    al, byte ptr [0x5396] ; CMP
0675BF  75 17                 JNE    0x675d8 ; CJUMP
0675C1  51                    PUSH   cx ; STACK_PUSH
0675C2  57                    PUSH   di ; STACK_PUSH
0675C3  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
0675C8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0675CB  22 46 FD              AND    al, byte ptr [bp - 3] ; LOGIC
0675CE  2A E4                 SUB    ah, ah ; ARITH
0675D0  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0675D3  8B D0                 MOV    dx, ax ; MOV
0675D5  EB 11                 JMP    0x675e8 ; JUMP
0675D7  90                    NOP ; NOP
0675D8  8A 54 03              MOV    dl, byte ptr [si + 3] ; MOV
0675DB  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
0675DF  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0675E2  D3 E0                 SHL    ax, cl ; LOGIC
0675E4  22 D0                 AND    dl, al ; LOGIC
0675E6  2A F6                 SUB    dh, dh ; ARITH
0675E8  0B D2                 OR     dx, dx ; LOGIC
0675EA  75 06                 JNE    0x675f2 ; CJUMP
0675EC  39 16 A2 53           CMP    word ptr [0x53a2], dx ; CMP
0675F0  74 0A                 JE     0x675fc ; CJUMP
0675F2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0675F5  0E                    PUSH   cs ; STACK_PUSH
0675F6  E8 3C 00              CALL   0x67635 ; CALL_NEAR
0675F9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0675FC  83 C6 1C              ADD    si, 0x1c ; ARITH
0675FF  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
067602  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
067605  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
067608  7C 87                 JL     0x67591 ; CJUMP
06760A  5E                    POP    si ; STACK_POP
06760B  5F                    POP    di ; STACK_POP
06760C  C9                    LEAVE ; EPILOGUE
06760D  CB                    RETF ; RETURN
