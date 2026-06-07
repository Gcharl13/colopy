; ============================================================================
; func_007997_unknown
; Region   : load_image
; Bytes    : file 0x007997..0x0079BF  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007997  55                    PUSH   bp ; STACK_PUSH
007998  8B EC                 MOV    bp, sp ; MOV
00799A  56                    PUSH   si ; STACK_PUSH
00799B  57                    PUSH   di ; STACK_PUSH
00799C  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00799F  83 F9 E8              CMP    cx, -0x18 ; CMP
0079A2  77 12                 JA     0x79b6 ; CJUMP
0079A4  BB 6C 42              MOV    bx, 0x426c ; CONST_LOAD
0079A7  E8 9E 07              CALL   0x8148 ; CALL_NEAR
0079AA  73 0F                 JAE    0x79bb ; CJUMP
0079AC  E8 11 00              CALL   0x79c0 ; CALL_NEAR
0079AF  72 05                 JB     0x79b6 ; CJUMP
0079B1  E8 94 07              CALL   0x8148 ; CALL_NEAR
0079B4  73 05                 JAE    0x79bb ; CJUMP
0079B6  33 C0                 XOR    ax, ax ; LOGIC
0079B8  99                    CDQ ; ARITH
0079B9  EB 00                 JMP    0x79bb ; JUMP
0079BB  5F                    POP    di ; STACK_POP
0079BC  5E                    POP    si ; STACK_POP
0079BD  5D                    POP    bp ; STACK_POP
0079BE  CB                    RETF ; RETURN
