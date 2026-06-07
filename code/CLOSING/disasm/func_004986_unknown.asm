; ============================================================================
; func_004986_unknown
; Region   : load_image
; Bytes    : file 0x004986..0x0049A8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004986  55                    PUSH   bp ; STACK_PUSH
004987  8B EC                 MOV    bp, sp ; MOV
004989  56                    PUSH   si ; STACK_PUSH
00498A  57                    PUSH   di ; STACK_PUSH
00498B  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00498E  0B D2                 OR     dx, dx ; LOGIC
004990  7E 54                 JLE    0x49e6 ; CJUMP
004992  4A                    DEC    dx ; ARITH
004993  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
004996  1E                    PUSH   ds ; STACK_PUSH
004997  07                    POP    es ; STACK_POP
004998  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00499B  0B D2                 OR     dx, dx ; LOGIC
00499D  74 50                 JE     0x49ef ; CJUMP
00499F  8B 4F 02              MOV    cx, word ptr [bx + 2] ; MOV
0049A2  E3 1E                 JCXZ   0x49c2 ; CJUMP
0049A4  3B CA                 CMP    cx, dx ; CMP
0049A6  76 02                 JBE    0x49aa ; CJUMP
