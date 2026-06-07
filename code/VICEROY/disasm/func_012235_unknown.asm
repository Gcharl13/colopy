; ============================================================================
; func_012235_unknown
; Region   : load_image
; Bytes    : file 0x012235..0x01225D  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012235  55                    PUSH   bp ; STACK_PUSH
012236  8B EC                 MOV    bp, sp ; MOV
012238  56                    PUSH   si ; STACK_PUSH
012239  57                    PUSH   di ; STACK_PUSH
01223A  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
01223D  83 F9 E8              CMP    cx, -0x18 ; CMP
012240  77 12                 JA     0x12254 ; CJUMP
012242  BB 78 27              MOV    bx, 0x2778 ; CONST_LOAD
012245  E8 AA FC              CALL   0x11ef2 ; CALL_NEAR
012248  73 0F                 JAE    0x12259 ; CJUMP
01224A  E8 C1 F4              CALL   0x1170e ; CALL_NEAR
01224D  72 05                 JB     0x12254 ; CJUMP
01224F  E8 A0 FC              CALL   0x11ef2 ; CALL_NEAR
012252  73 05                 JAE    0x12259 ; CJUMP
012254  33 C0                 XOR    ax, ax ; LOGIC
012256  99                    CDQ ; ARITH
012257  EB 00                 JMP    0x12259 ; JUMP
012259  5F                    POP    di ; STACK_POP
01225A  5E                    POP    si ; STACK_POP
01225B  5D                    POP    bp ; STACK_POP
01225C  CB                    RETF ; RETURN
