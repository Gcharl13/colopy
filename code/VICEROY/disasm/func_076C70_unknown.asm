; ============================================================================
; func_076C70_unknown
; Region   : overlay
; Bytes    : file 0x076C70..0x076C90  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076C70  C8 3E 01 00           ENTER  0x13e, 0 ; PROLOGUE
076C74  53                    PUSH   bx ; STACK_PUSH
076C75  57                    PUSH   di ; STACK_PUSH
076C76  56                    PUSH   si ; STACK_PUSH
076C77  2B C0                 SUB    ax, ax ; ARITH
076C79  99                    CDQ ; ARITH
076C7A  8B F0                 MOV    si, ax ; MOV
076C7C  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
076C7F  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
076C82  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
076C85  C7 06 50 26 0F 00     MOV    word ptr [0x2650], 0xf ; GLOBAL_LOAD
076C8B  89 86 C2 FE           MOV    word ptr [bp - 0x13e], ax ; LOCAL_STORE
076C8F  53                    PUSH   bx ; STACK_PUSH
