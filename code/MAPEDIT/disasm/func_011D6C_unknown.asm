; ============================================================================
; func_011D6C_unknown
; Region   : load_image
; Bytes    : file 0x011D6C..0x011E2B  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D6C  55                    PUSH   bp ; STACK_PUSH
011D6D  8B EC                 MOV    bp, sp ; MOV
011D6F  52                    PUSH   dx ; STACK_PUSH
011D70  50                    PUSH   ax ; STACK_PUSH
011D71  57                    PUSH   di ; STACK_PUSH
011D72  56                    PUSH   si ; STACK_PUSH
011D73  C7 06 88 4A 00 00     MOV    word ptr [0x4a88], 0 ; GLOBAL_LOAD
011D79  C7 06 CC 49 00 01     MOV    word ptr [0x49cc], 0x100 ; GLOBAL_LOAD
011D7F  2B C0                 SUB    ax, ax ; ARITH
011D81  BB 72 65              MOV    bx, 0x6572 ; CONST_LOAD
011D84  B9 00 02              MOV    cx, 0x200 ; CONST_LOAD
011D87  8B FB                 MOV    di, bx ; MOV
011D89  1E                    PUSH   ds ; STACK_PUSH
011D8A  07                    POP    es ; STACK_POP
011D8B  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
011D8D  39 06 0A 44           CMP    word ptr [0x440a], ax ; CMP
011D91  75 0F                 JNE    0x11da2 ; CJUMP
011D93  8D 1E 20 5B           LEA    bx, [0x5b20] ; ADDR
011D97  9A 00 00 B0 12        LCALL  0x12b0, 0 ; LCALL
011D9C  C7 06 0A 44 FF FF     MOV    word ptr [0x440a], 0xffff ; GLOBAL_LOAD
011DA2  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
011DA6  7E 1E                 JLE    0x11dc6 ; CJUMP
011DA8  C7 06 72 65 01 00     MOV    word ptr [0x6572], 1 ; GLOBAL_LOAD
011DAE  C7 06 74 65 00 00     MOV    word ptr [0x6574], 0 ; GLOBAL_LOAD
011DB4  B8 76 65              MOV    ax, 0x6576 ; CONST_LOAD
011DB7  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
011DBA  49                    DEC    cx ; ARITH
011DBB  D1 E1                 SHL    cx, 1 ; LOGIC
011DBD  8B F8                 MOV    di, ax ; MOV
011DBF  BE 72 65              MOV    si, 0x6572 ; CONST_LOAD
011DC2  1E                    PUSH   ds ; STACK_PUSH
011DC3  07                    POP    es ; STACK_POP
011DC4  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
011DC6  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
011DCA  7E 20                 JLE    0x11dec ; CJUMP
011DCC  C7 06 6E 69 01 00     MOV    word ptr [0x696e], 1 ; GLOBAL_LOAD
011DD2  C7 06 70 69 00 00     MOV    word ptr [0x6970], 0 ; GLOBAL_LOAD
011DD8  B8 6C 69              MOV    ax, 0x696c ; CONST_LOAD
011DDB  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
011DDE  49                    DEC    cx ; ARITH
011DDF  D1 E1                 SHL    cx, 1 ; LOGIC
011DE1  FD                    STD ; FLAG
011DE2  8B F8                 MOV    di, ax ; MOV
011DE4  BE 70 69              MOV    si, 0x6970 ; CONST_LOAD
011DE7  1E                    PUSH   ds ; STACK_PUSH
011DE8  07                    POP    es ; STACK_POP
011DE9  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
011DEB  FC                    CLD ; FLAG
011DEC  2B C0                 SUB    ax, ax ; ARITH
011DEE  BB 94 52              MOV    bx, 0x5294 ; CONST_LOAD
011DF1  B9 20 00              MOV    cx, 0x20 ; CONST_LOAD
011DF4  8B FB                 MOV    di, bx ; MOV
011DF6  1E                    PUSH   ds ; STACK_PUSH
011DF7  07                    POP    es ; STACK_POP
011DF8  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
011DFA  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
011DFD  A3 94 52              MOV    word ptr [0x5294], ax ; GLOBAL_LOAD
011E00  A3 96 52              MOV    word ptr [0x5296], ax ; GLOBAL_LOAD
011E03  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
011E06  A3 20 5E              MOV    word ptr [0x5e20], ax ; GLOBAL_LOAD
011E09  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
011E0C  A3 D6 52              MOV    word ptr [0x52d6], ax ; GLOBAL_LOAD
011E0F  2B C0                 SUB    ax, ax ; ARITH
011E11  A3 08 44              MOV    word ptr [0x4408], ax ; GLOBAL_LOAD
011E14  A3 12 44              MOV    word ptr [0x4412], ax ; GLOBAL_LOAD
011E17  6A 01                 PUSH   1 ; STACK_PUSH
011E19  FF 36 0E 44           PUSH   word ptr [0x440e] ; PUSH_GLOBAL
011E1D  FF 36 0C 44           PUSH   word ptr [0x440c] ; PUSH_GLOBAL
011E21  E8 2A FF              CALL   0x11d4e ; CALL_NEAR
011E24  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
011E27  5E                    POP    si ; STACK_POP
011E28  5F                    POP    di ; STACK_POP
011E29  C9                    LEAVE ; EPILOGUE
011E2A  CB                    RETF ; RETURN
