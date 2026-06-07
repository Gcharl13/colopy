; ============================================================================
; func_070302_unknown
; Region   : overlay
; Bytes    : file 0x070302..0x0703A7  (165 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070302  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
070306  57                    PUSH   di ; STACK_PUSH
070307  56                    PUSH   si ; STACK_PUSH
070308  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
07030B  50                    PUSH   ax ; STACK_PUSH
07030C  8D 4E AC              LEA    cx, [bp - 0x54] ; ADDR
07030F  51                    PUSH   cx ; STACK_PUSH
070310  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
070313  0E                    PUSH   cs ; STACK_PUSH
070314  E8 2F 09              CALL   0x70c46 ; CALL_NEAR
070317  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
07031A  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
07031E  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
070322  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
070326  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
07032A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
07032E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
070332  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
070336  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
07033A  6A 5A                 PUSH   0x5a ; PUSH_CONST
07033C  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
07033F  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
070342  BB 44 00              MOV    bx, 0x44 ; CONST_LOAD
070345  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
07034A  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07034D  0B C0                 OR     ax, ax ; LOGIC
07034F  74 0B                 JE     0x7035c ; CJUMP
070351  48                    DEC    ax ; ARITH
070352  74 0E                 JE     0x70362 ; CJUMP
070354  48                    DEC    ax ; ARITH
070355  74 11                 JE     0x70368 ; CJUMP
070357  48                    DEC    ax ; ARITH
070358  74 14                 JE     0x7036e ; CJUMP
07035A  EB 18                 JMP    0x70374 ; JUMP
07035C  C6 46 A8 0A           MOV    byte ptr [bp - 0x58], 0xa ; LOCAL_STORE
070360  EB 16                 JMP    0x70378 ; JUMP
070362  C6 46 A8 09           MOV    byte ptr [bp - 0x58], 9 ; LOCAL_STORE
070366  EB 10                 JMP    0x70378 ; JUMP
070368  C6 46 A8 0E           MOV    byte ptr [bp - 0x58], 0xe ; LOCAL_STORE
07036C  EB 0A                 JMP    0x70378 ; JUMP
07036E  C6 46 A8 0D           MOV    byte ptr [bp - 0x58], 0xd ; LOCAL_STORE
070372  EB 04                 JMP    0x70378 ; JUMP
070374  C6 46 A8 0C           MOV    byte ptr [bp - 0x58], 0xc ; LOCAL_STORE
070378  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
07037B  2A E4                 SUB    ah, ah ; ARITH
07037D  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
070380  74 03                 JE     0x70385 ; CJUMP
070382  E9 F7 00              JMP    0x7047c ; JUMP
070385  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
070389  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
07038D  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
070391  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
070395  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
070398  05 59 00              ADD    ax, 0x59 ; ARITH
07039B  50                    PUSH   ax ; STACK_PUSH
07039C  8A 46 A8              MOV    al, byte ptr [bp - 0x58] ; LOCAL_LOAD
07039F  50                    PUSH   ax ; STACK_PUSH
0703A0  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
0703A3  8B D8                 MOV    bx, ax ; MOV
0703A5  83                    DB     0x83 ; DATA_BYTE
0703A6  C3                    DB     0xC3 ; DATA_BYTE
