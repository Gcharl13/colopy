; ============================================================================
; func_03FA9C_unknown
; Region   : overlay
; Bytes    : file 0x03FA9C..0x03FABA  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FA9C  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
03FAA0  53                    PUSH   bx ; STACK_PUSH
03FAA1  52                    PUSH   dx ; STACK_PUSH
03FAA2  50                    PUSH   ax ; STACK_PUSH
03FAA3  56                    PUSH   si ; STACK_PUSH
03FAA4  2B C0                 SUB    ax, ax ; ARITH
03FAA6  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03FAA9  A3 4E 9E              MOV    word ptr [0x9e4e], ax ; GLOBAL_LOAD
03FAAC  83 FB 01              CMP    bx, 1 ; CMP
03FAAF  7D 03                 JGE    0x3fab4 ; CJUMP
03FAB1  E9 24 03              JMP    0x3fdd8 ; JUMP
03FAB4  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
03FAB7  48                    DEC    ax ; ARITH
03FAB8  3B C3                 CMP    ax, bx ; CMP
