; ============================================================================
; func_03954C_unknown
; Region   : overlay
; Bytes    : file 0x03954C..0x039580  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03954C  C8 6A 00 00           ENTER  0x6a, 0 ; PROLOGUE
039550  56                    PUSH   si ; STACK_PUSH
039551  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
039554  0E                    PUSH   cs ; STACK_PUSH
039555  E8 E7 08              CALL   0x39e3f ; CALL_NEAR
039558  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03955B  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2 ; LOCAL_STORE
039560  C7 46 A8 2A 00        MOV    word ptr [bp - 0x58], 0x2a ; LOCAL_STORE
039565  2B C0                 SUB    ax, ax ; ARITH
039567  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
03956A  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
03956D  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
039570  E9 73 02              JMP    0x397e6 ; JUMP
039573  90                    NOP ; NOP
039574  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
039577  6A 00                 PUSH   0 ; STACK_PUSH
039579  6A 64                 PUSH   0x64 ; PUSH_CONST
03957B  8B 5E AA              MOV    bx, word ptr [bp - 0x56] ; LOCAL_LOAD
03957E  83                    DB     0x83 ; DATA_BYTE
03957F  C3                    DB     0xC3 ; DATA_BYTE
