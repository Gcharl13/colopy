; ============================================================================
; func_008D20_unknown
; Region   : load_image
; Bytes    : file 0x008D20..0x008DDF  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008D20  55                    PUSH   bp ; STACK_PUSH
008D21  8B EC                 MOV    bp, sp ; MOV
008D23  52                    PUSH   dx ; STACK_PUSH
008D24  50                    PUSH   ax ; STACK_PUSH
008D25  57                    PUSH   di ; STACK_PUSH
008D26  56                    PUSH   si ; STACK_PUSH
008D27  C7 06 28 4C 00 00     MOV    word ptr [0x4c28], 0 ; GLOBAL_LOAD
008D2D  C7 06 78 48 00 01     MOV    word ptr [0x4878], 0x100 ; GLOBAL_LOAD
008D33  2B C0                 SUB    ax, ax ; ARITH
008D35  BB 52 54              MOV    bx, 0x5452 ; CONST_LOAD
008D38  B9 00 02              MOV    cx, 0x200 ; CONST_LOAD
008D3B  8B FB                 MOV    di, bx ; MOV
008D3D  1E                    PUSH   ds ; STACK_PUSH
008D3E  07                    POP    es ; STACK_POP
008D3F  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
008D41  39 06 EC 3E           CMP    word ptr [0x3eec], ax ; CMP
008D45  75 0F                 JNE    0x8d56 ; CJUMP
008D47  8D 1E 74 50           LEA    bx, [0x5074] ; ADDR
008D4B  9A 0C 00 A7 09        LCALL  0x9a7, 0xc ; LCALL
008D50  C7 06 EC 3E FF FF     MOV    word ptr [0x3eec], 0xffff ; GLOBAL_LOAD
008D56  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
008D5A  7E 1E                 JLE    0x8d7a ; CJUMP
008D5C  C7 06 52 54 01 00     MOV    word ptr [0x5452], 1 ; GLOBAL_LOAD
008D62  C7 06 54 54 00 00     MOV    word ptr [0x5454], 0 ; GLOBAL_LOAD
008D68  B8 56 54              MOV    ax, 0x5456 ; CONST_LOAD
008D6B  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
008D6E  49                    DEC    cx ; ARITH
008D6F  D1 E1                 SHL    cx, 1 ; LOGIC
008D71  8B F8                 MOV    di, ax ; MOV
008D73  BE 52 54              MOV    si, 0x5452 ; CONST_LOAD
008D76  1E                    PUSH   ds ; STACK_PUSH
008D77  07                    POP    es ; STACK_POP
008D78  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
008D7A  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
008D7E  7E 20                 JLE    0x8da0 ; CJUMP
008D80  C7 06 4E 58 01 00     MOV    word ptr [0x584e], 1 ; GLOBAL_LOAD
008D86  C7 06 50 58 00 00     MOV    word ptr [0x5850], 0 ; GLOBAL_LOAD
008D8C  B8 4C 58              MOV    ax, 0x584c ; CONST_LOAD
008D8F  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
008D92  49                    DEC    cx ; ARITH
008D93  D1 E1                 SHL    cx, 1 ; LOGIC
008D95  FD                    STD ; FLAG
008D96  8B F8                 MOV    di, ax ; MOV
008D98  BE 50 58              MOV    si, 0x5850 ; CONST_LOAD
008D9B  1E                    PUSH   ds ; STACK_PUSH
008D9C  07                    POP    es ; STACK_POP
008D9D  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
008D9F  FC                    CLD ; FLAG
008DA0  2B C0                 SUB    ax, ax ; ARITH
008DA2  BB F8 4F              MOV    bx, 0x4ff8 ; CONST_LOAD
008DA5  B9 20 00              MOV    cx, 0x20 ; CONST_LOAD
008DA8  8B FB                 MOV    di, bx ; MOV
008DAA  1E                    PUSH   ds ; STACK_PUSH
008DAB  07                    POP    es ; STACK_POP
008DAC  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
008DAE  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
008DB1  A3 F8 4F              MOV    word ptr [0x4ff8], ax ; GLOBAL_LOAD
008DB4  A3 FA 4F              MOV    word ptr [0x4ffa], ax ; GLOBAL_LOAD
008DB7  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
008DBA  A3 74 53              MOV    word ptr [0x5374], ax ; GLOBAL_LOAD
008DBD  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008DC0  A3 38 50              MOV    word ptr [0x5038], ax ; GLOBAL_LOAD
008DC3  2B C0                 SUB    ax, ax ; ARITH
008DC5  A3 EA 3E              MOV    word ptr [0x3eea], ax ; GLOBAL_LOAD
008DC8  A3 F4 3E              MOV    word ptr [0x3ef4], ax ; GLOBAL_LOAD
008DCB  6A 01                 PUSH   1 ; STACK_PUSH
008DCD  FF 36 F0 3E           PUSH   word ptr [0x3ef0] ; PUSH_GLOBAL
008DD1  FF 36 EE 3E           PUSH   word ptr [0x3eee] ; PUSH_GLOBAL
008DD5  E8 2A FF              CALL   0x8d02 ; CALL_NEAR
008DD8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
008DDB  5E                    POP    si ; STACK_POP
008DDC  5F                    POP    di ; STACK_POP
008DDD  C9                    LEAVE ; EPILOGUE
008DDE  CB                    RETF ; RETURN
