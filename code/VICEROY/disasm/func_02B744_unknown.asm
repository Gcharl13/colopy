; ============================================================================
; func_02B744_unknown
; Region   : overlay
; Bytes    : file 0x02B744..0x02B75C  (24 bytes)
; Purpose  : Buy commodity (BUYME0)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

02B744  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
02B748  57                    PUSH   di ; STACK_PUSH
02B749  56                    PUSH   si ; STACK_PUSH
02B74A  8D 46 EE              LEA    ax, [bp - 0x12] ; ADDR
02B74D  50                    PUSH   ax ; STACK_PUSH
02B74E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02B752  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
02B756  98                    CWDE ; ARITH
02B757  50                    PUSH   ax ; STACK_PUSH
02B758  9A                    DB     0x9A ; DATA_BYTE
02B759  C2                    DB     0xC2 ; DATA_BYTE
02B75A  0C                    DB     0x0C ; DATA_BYTE
02B75B  1F                    DB     0x1F ; DATA_BYTE
