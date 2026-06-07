; ============================================================================
; func_0776F4_unknown
; Region   : overlay
; Bytes    : file 0x0776F4..0x077771  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0776F4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0776F8  57                    PUSH   di ; STACK_PUSH
0776F9  56                    PUSH   si ; STACK_PUSH
0776FA  2B F6                 SUB    si, si ; ARITH
0776FC  39 36 32 A6           CMP    word ptr [0xa632], si ; CMP
077700  7C 69                 JL     0x7776b ; CJUMP
077702  7F 06                 JG     0x7770a ; CJUMP
077704  39 36 30 A6           CMP    word ptr [0xa630], si ; CMP
077708  74 61                 JE     0x7776b ; CJUMP
07770A  0B F6                 OR     si, si ; LOGIC
07770C  75 5D                 JNE    0x7776b ; CJUMP
07770E  A1 26 A6              MOV    ax, word ptr [0xa626] ; GLOBAL_LOAD
077711  2B D2                 SUB    dx, dx ; ARITH
077713  3B 16 32 A6           CMP    dx, word ptr [0xa632] ; CMP
077717  7C 0F                 JL     0x77728 ; CJUMP
077719  7F 06                 JG     0x77721 ; CJUMP
07771B  3B 06 30 A6           CMP    ax, word ptr [0xa630] ; CMP
07771F  76 07                 JBE    0x77728 ; CJUMP
077721  8B 16 32 A6           MOV    dx, word ptr [0xa632] ; GLOBAL_LOAD
077725  A1 30 A6              MOV    ax, word ptr [0xa630] ; GLOBAL_LOAD
077728  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
07772B  FF 36 24 A6           PUSH   word ptr [0xa624] ; PUSH_GLOBAL
07772F  FF 36 22 A6           PUSH   word ptr [0xa622] ; PUSH_GLOBAL
077733  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
077736  16                    PUSH   ss ; STACK_PUSH
077737  50                    PUSH   ax ; STACK_PUSH
077738  FF 1E 44 A6           LCALL  [0xa644] ; LCALL
07773C  8B F8                 MOV    di, ax ; MOV
07773E  3B 7E FE              CMP    di, word ptr [bp - 2] ; CMP
077741  74 07                 JE     0x7774a ; CJUMP
077743  BE 04 00              MOV    si, 4 ; MOV
077746  EB 13                 JMP    0x7775b ; JUMP
077748  90                    NOP ; NOP
077749  90                    NOP ; NOP
07774A  FF 36 24 A6           PUSH   word ptr [0xa624] ; PUSH_GLOBAL
07774E  FF 36 22 A6           PUSH   word ptr [0xa622] ; PUSH_GLOBAL
077752  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
077755  16                    PUSH   ss ; STACK_PUSH
077756  50                    PUSH   ax ; STACK_PUSH
077757  FF 1E 3A A6           LCALL  [0xa63a] ; LCALL
07775B  83 3E 32 A6 00        CMP    word ptr [0xa632], 0 ; CMP
077760  7F A8                 JG     0x7770a ; CJUMP
077762  7C 07                 JL     0x7776b ; CJUMP
077764  83 3E 30 A6 00        CMP    word ptr [0xa630], 0 ; CMP
077769  75 9F                 JNE    0x7770a ; CJUMP
07776B  8B C6                 MOV    ax, si ; MOV
07776D  5E                    POP    si ; STACK_POP
07776E  5F                    POP    di ; STACK_POP
07776F  C9                    LEAVE ; EPILOGUE
077770  CB                    RETF ; RETURN
