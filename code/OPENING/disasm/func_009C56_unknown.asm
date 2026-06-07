; ============================================================================
; func_009C56_unknown
; Region   : load_image
; Bytes    : file 0x009C56..0x009D15  (191 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009C56  55                    PUSH   bp ; STACK_PUSH
009C57  8B EC                 MOV    bp, sp ; MOV
009C59  52                    PUSH   dx ; STACK_PUSH
009C5A  50                    PUSH   ax ; STACK_PUSH
009C5B  57                    PUSH   di ; STACK_PUSH
009C5C  56                    PUSH   si ; STACK_PUSH
009C5D  C7 06 A2 4E 00 00     MOV    word ptr [0x4ea2], 0 ; GLOBAL_LOAD
009C63  C7 06 C8 4A 00 01     MOV    word ptr [0x4ac8], 0x100 ; GLOBAL_LOAD
009C69  2B C0                 SUB    ax, ax ; ARITH
009C6B  BB 8C 62              MOV    bx, 0x628c ; CONST_LOAD
009C6E  B9 00 02              MOV    cx, 0x200 ; CONST_LOAD
009C71  8B FB                 MOV    di, bx ; MOV
009C73  1E                    PUSH   ds ; STACK_PUSH
009C74  07                    POP    es ; STACK_POP
009C75  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
009C77  39 06 42 41           CMP    word ptr [0x4142], ax ; CMP
009C7B  75 0F                 JNE    0x9c8c ; CJUMP
009C7D  8D 1E AE 5E           LEA    bx, [0x5eae] ; ADDR
009C81  9A 02 00 7B 0A        LCALL  0xa7b, 2 ; LCALL
009C86  C7 06 42 41 FF FF     MOV    word ptr [0x4142], 0xffff ; GLOBAL_LOAD
009C8C  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
009C90  7E 1E                 JLE    0x9cb0 ; CJUMP
009C92  C7 06 8C 62 01 00     MOV    word ptr [0x628c], 1 ; GLOBAL_LOAD
009C98  C7 06 8E 62 00 00     MOV    word ptr [0x628e], 0 ; GLOBAL_LOAD
009C9E  B8 90 62              MOV    ax, 0x6290 ; CONST_LOAD
009CA1  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
009CA4  49                    DEC    cx ; ARITH
009CA5  D1 E1                 SHL    cx, 1 ; LOGIC
009CA7  8B F8                 MOV    di, ax ; MOV
009CA9  BE 8C 62              MOV    si, 0x628c ; CONST_LOAD
009CAC  1E                    PUSH   ds ; STACK_PUSH
009CAD  07                    POP    es ; STACK_POP
009CAE  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
009CB0  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
009CB4  7E 20                 JLE    0x9cd6 ; CJUMP
009CB6  C7 06 88 66 01 00     MOV    word ptr [0x6688], 1 ; GLOBAL_LOAD
009CBC  C7 06 8A 66 00 00     MOV    word ptr [0x668a], 0 ; GLOBAL_LOAD
009CC2  B8 86 66              MOV    ax, 0x6686 ; CONST_LOAD
009CC5  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
009CC8  49                    DEC    cx ; ARITH
009CC9  D1 E1                 SHL    cx, 1 ; LOGIC
009CCB  FD                    STD ; FLAG
009CCC  8B F8                 MOV    di, ax ; MOV
009CCE  BE 8A 66              MOV    si, 0x668a ; CONST_LOAD
009CD1  1E                    PUSH   ds ; STACK_PUSH
009CD2  07                    POP    es ; STACK_POP
009CD3  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
009CD5  FC                    CLD ; FLAG
009CD6  2B C0                 SUB    ax, ax ; ARITH
009CD8  BB 2A 5E              MOV    bx, 0x5e2a ; CONST_LOAD
009CDB  B9 20 00              MOV    cx, 0x20 ; CONST_LOAD
009CDE  8B FB                 MOV    di, bx ; MOV
009CE0  1E                    PUSH   ds ; STACK_PUSH
009CE1  07                    POP    es ; STACK_POP
009CE2  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
009CE4  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
009CE7  A3 2A 5E              MOV    word ptr [0x5e2a], ax ; GLOBAL_LOAD
009CEA  A3 2C 5E              MOV    word ptr [0x5e2c], ax ; GLOBAL_LOAD
009CED  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
009CF0  A3 AE 61              MOV    word ptr [0x61ae], ax ; GLOBAL_LOAD
009CF3  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009CF6  A3 6A 5E              MOV    word ptr [0x5e6a], ax ; GLOBAL_LOAD
009CF9  2B C0                 SUB    ax, ax ; ARITH
009CFB  A3 40 41              MOV    word ptr [0x4140], ax ; GLOBAL_LOAD
009CFE  A3 4A 41              MOV    word ptr [0x414a], ax ; GLOBAL_LOAD
009D01  6A 01                 PUSH   1 ; STACK_PUSH
009D03  FF 36 46 41           PUSH   word ptr [0x4146] ; PUSH_GLOBAL
009D07  FF 36 44 41           PUSH   word ptr [0x4144] ; PUSH_GLOBAL
009D0B  E8 2A FF              CALL   0x9c38 ; CALL_NEAR
009D0E  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
009D11  5E                    POP    si ; STACK_POP
009D12  5F                    POP    di ; STACK_POP
009D13  C9                    LEAVE ; EPILOGUE
009D14  CB                    RETF ; RETURN
