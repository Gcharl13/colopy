; ============================================================================
; func_0073A8_unknown
; Region   : load_image
; Bytes    : file 0x0073A8..0x00740B  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0073A8  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0073AC  57                    PUSH   di ; STACK_PUSH
0073AD  56                    PUSH   si ; STACK_PUSH
0073AE  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0073B1  2B FF                 SUB    di, di ; ARITH
0073B3  8B C6                 MOV    ax, si ; MOV
0073B5  0E                    PUSH   cs ; STACK_PUSH
0073B6  E8 B9 F2              CALL   0x6672 ; CALL_NEAR
0073B9  8B F0                 MOV    si, ax ; MOV
0073BB  0B F6                 OR     si, si ; LOGIC
0073BD  7D 03                 JGE    0x73c2 ; CJUMP
0073BF  E9 B5 01              JMP    0x7577 ; JUMP
0073C2  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0073C5  89 5E FA              MOV    word ptr [bp - 6], bx ; LOCAL_STORE
0073C8  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
0073CC  2A E4                 SUB    ah, ah ; ARITH
0073CE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0073D1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0073D4  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0073D7  3D 0E 00              CMP    ax, 0xe ; CMP
0073DA  76 03                 JBE    0x73df ; CJUMP
0073DC  E9 89 01              JMP    0x7568 ; JUMP
0073DF  D1 E0                 SHL    ax, 1 ; LOGIC
0073E1  93                    XCHG   bx, ax ; MOV
0073E2  2E FF A7 78 0D        JMP    word ptr cs:[bx + 0xd78] ; JUMP
0073E7  90                    NOP ; NOP
0073E8  96                    XCHG   si, ax ; MOV
0073E9  0D F8 0E              OR     ax, 0xef8 ; LOGIC
0073EC  B9 0D B0              MOV    cx, 0xb00d ; CONST_LOAD
0073EF  0D BE 0D              OR     ax, 0xdbe ; LOGIC
0073F2  E0 0D                 LOOPNE 0x7401 ; CJUMP
0073F4  E6 0D                 OUT    0xd, al ; IO
0073F6  F8                    CLC ; FLAG
0073F7  0E                    PUSH   cs ; STACK_PUSH
0073F8  F8                    CLC ; FLAG
0073F9  0E                    PUSH   cs ; STACK_PUSH
0073FA  F8                    CLC ; FLAG
0073FB  0E                    PUSH   cs ; STACK_PUSH
0073FC  16                    PUSH   ss ; STACK_PUSH
0073FD  0E                    PUSH   cs ; STACK_PUSH
0073FE  46                    INC    si ; ARITH
0073FF  0E                    PUSH   cs ; STACK_PUSH
007400  8C 0E 94 0E           MOV    word ptr [0xe94], cs ; GLOBAL_LOAD
007404  BC 0E 8B              MOV    sp, 0x8b0e ; CONST_LOAD
007407  5E                    POP    si ; STACK_POP
007408  FC                    CLD ; FLAG
007409  8B C3                 MOV    ax, bx ; MOV
