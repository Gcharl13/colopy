; ============================================================================
; func_0353DE_unknown
; Region   : overlay
; Bytes    : file 0x0353DE..0x03544F  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0353DE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0353E2  83 3E EC 07 00        CMP    word ptr [0x7ec], 0 ; CMP
0353E7  75 07                 JNE    0x353f0 ; CJUMP
0353E9  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
0353EE  75 0A                 JNE    0x353fa ; CJUMP
0353F0  0E                    PUSH   cs ; STACK_PUSH
0353F1  E8 A6 14              CALL   0x3689a ; CALL_NEAR
0353F4  A3 3A 9E              MOV    word ptr [0x9e3a], ax ; GLOBAL_LOAD
0353F7  A3 3C 9E              MOV    word ptr [0x9e3c], ax ; GLOBAL_LOAD
0353FA  A1 3A 9E              MOV    ax, word ptr [0x9e3a] ; GLOBAL_LOAD
0353FD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
035400  3D 0A 00              CMP    ax, 0xa ; CMP
035403  74 0A                 JE     0x3540f ; CJUMP
035405  3D 08 00              CMP    ax, 8 ; CMP
035408  74 05                 JE     0x3540f ; CJUMP
03540A  3D 09 00              CMP    ax, 9 ; CMP
03540D  75 2A                 JNE    0x35439 ; CJUMP
03540F  0E                    PUSH   cs ; STACK_PUSH
035410  E8 87 14              CALL   0x3689a ; CALL_NEAR
035413  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
035416  0B C0                 OR     ax, ax ; LOGIC
035418  74 36                 JE     0x35450 ; CJUMP
03541A  48                    DEC    ax ; ARITH
03541B  74 09                 JE     0x35426 ; CJUMP
03541D  48                    DEC    ax ; ARITH
03541E  7C 14                 JL     0x35434 ; CJUMP
035420  48                    DEC    ax ; ARITH
035421  7E 35                 JLE    0x35458 ; CJUMP
035423  EB 0F                 JMP    0x35434 ; JUMP
035425  90                    NOP ; NOP
035426  83 3E 3A 9E 0A        CMP    word ptr [0x9e3a], 0xa ; CMP
03542B  74 0C                 JE     0x35439 ; CJUMP
03542D  83 3E 3A 9E 08        CMP    word ptr [0x9e3a], 8 ; CMP
035432  74 05                 JE     0x35439 ; CJUMP
035434  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf ; LOCAL_STORE
035439  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
03543E  75 26                 JNE    0x35466 ; CJUMP
035440  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
035444  75 76                 JNE    0x354bc ; CJUMP
035446  F6 06 84 53 01        TEST   byte ptr [0x5384], 1 ; LOGIC
03544B  74 19                 JE     0x35466 ; CJUMP
03544D  C9                    LEAVE ; EPILOGUE
03544E  CB                    RETF ; RETURN
