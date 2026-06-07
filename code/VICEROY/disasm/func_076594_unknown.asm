; ============================================================================
; func_076594_unknown
; Region   : overlay
; Bytes    : file 0x076594..0x0765B7  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076594  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
076598  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
07659D  0E                    PUSH   cs ; STACK_PUSH
07659E  E8 9C 00              CALL   0x7663d ; CALL_NEAR
0765A1  8D 1E D0 23           LEA    bx, [0x23d0] ; ADDR
0765A5  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
0765A8  0E                    PUSH   cs ; STACK_PUSH
0765A9  E8 8C 00              CALL   0x76638 ; CALL_NEAR
0765AC  A3 74 01              MOV    word ptr [0x174], ax ; GLOBAL_LOAD
0765AF  89 16 76 01           MOV    word ptr [0x176], dx ; GLOBAL_LOAD
0765B3  8B C2                 MOV    ax, dx ; MOV
0765B5  0B                    DB     0x0B ; DATA_BYTE
0765B6  06                    DB     0x06 ; DATA_BYTE
