; ============================================================================
; func_01729F_unknown
; Region   : load_image
; Bytes    : file 0x01729F..0x0172C7  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01729F  55                    PUSH   bp ; STACK_PUSH
0172A0  8B EC                 MOV    bp, sp ; MOV
0172A2  56                    PUSH   si ; STACK_PUSH
0172A3  57                    PUSH   di ; STACK_PUSH
0172A4  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
0172A7  83 F9 E8              CMP    cx, -0x18 ; CMP
0172AA  77 12                 JA     0x172be ; CJUMP
0172AC  BB 34 45              MOV    bx, 0x4534 ; CONST_LOAD
0172AF  E8 14 01              CALL   0x173c6 ; CALL_NEAR
0172B2  73 0F                 JAE    0x172c3 ; CJUMP
0172B4  E8 11 00              CALL   0x172c8 ; CALL_NEAR
0172B7  72 05                 JB     0x172be ; CJUMP
0172B9  E8 0A 01              CALL   0x173c6 ; CALL_NEAR
0172BC  73 05                 JAE    0x172c3 ; CJUMP
0172BE  33 C0                 XOR    ax, ax ; LOGIC
0172C0  99                    CDQ ; ARITH
0172C1  EB 00                 JMP    0x172c3 ; JUMP
0172C3  5F                    POP    di ; STACK_POP
0172C4  5E                    POP    si ; STACK_POP
0172C5  5D                    POP    bp ; STACK_POP
0172C6  CB                    RETF ; RETURN
