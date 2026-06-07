; ============================================================================
; func_04598A_unknown
; Region   : overlay
; Bytes    : file 0x04598A..0x045A1D  (147 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04598A  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
04598E  57                    PUSH   di ; STACK_PUSH
04598F  56                    PUSH   si ; STACK_PUSH
045990  8B F8                 MOV    di, ax ; MOV
045992  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
045995  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
045998  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38] ; MOV
04599C  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a] ; MOV
0459A0  8B F0                 MOV    si, ax ; MOV
0459A2  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
0459A5  2B C0                 SUB    ax, ax ; ARITH
0459A7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0459AA  26 89 07              MOV    word ptr es:[bx], ax ; MOV
0459AD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0459B0  8B C7                 MOV    ax, di ; MOV
0459B2  9A 80 03 1F 1A        LCALL  0x1a1f, 0x380 ; THUNK -> 0x0AEA:0x000C (thunk @file 0x01C970 type B)
0459B7  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0459BA  3B C7                 CMP    ax, di ; CMP
0459BC  74 26                 JE     0x459e4 ; CJUMP
0459BE  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0459C1  0B C6                 OR     ax, si ; LOGIC
0459C3  74 1F                 JE     0x459e4 ; CJUMP
0459C5  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
0459C8  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0459CB  0B C9                 OR     cx, cx ; LOGIC
0459CD  75 2F                 JNE    0x459fe ; CJUMP
0459CF  8E 46 F8              MOV    es, word ptr [bp - 8] ; LOCAL_LOAD
0459D2  26 39 5C 08           CMP    word ptr es:[si + 8], bx ; CMP
0459D6  75 12                 JNE    0x459ea ; CJUMP
0459D8  26 F6 44 0C 01        TEST   byte ptr es:[si + 0xc], 1 ; LOGIC
0459DD  75 0B                 JNE    0x459ea ; CJUMP
0459DF  B9 01 00              MOV    cx, 1 ; MOV
0459E2  EB 13                 JMP    0x459f7 ; JUMP
0459E4  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
0459E7  EB 15                 JMP    0x459fe ; JUMP
0459E9  90                    NOP ; NOP
0459EA  26 8B 44 16           MOV    ax, word ptr es:[si + 0x16] ; MOV
0459EE  26 8B 54 18           MOV    dx, word ptr es:[si + 0x18] ; MOV
0459F2  8B F0                 MOV    si, ax ; MOV
0459F4  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
0459F7  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0459FA  0B C6                 OR     ax, si ; LOGIC
0459FC  75 CD                 JNE    0x459cb ; CJUMP
0459FE  8B 7E FA              MOV    di, word ptr [bp - 6] ; LOCAL_LOAD
045A01  0B C9                 OR     cx, cx ; LOGIC
045A03  74 0B                 JE     0x45a10 ; CJUMP
045A05  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
045A08  56                    PUSH   si ; STACK_PUSH
045A09  0E                    PUSH   cs ; STACK_PUSH
045A0A  E8 E0 01              CALL   0x45bed ; CALL_NEAR
045A0D  BF 01 00              MOV    di, 1 ; MOV
045A10  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
045A15  8B C7                 MOV    ax, di ; MOV
045A17  5E                    POP    si ; STACK_POP
045A18  5F                    POP    di ; STACK_POP
045A19  C9                    LEAVE ; EPILOGUE
045A1A  CA 04 00              RETF   4 ; RETURN
