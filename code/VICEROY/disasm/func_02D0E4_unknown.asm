; ============================================================================
; func_02D0E4_unknown
; Region   : overlay
; Bytes    : file 0x02D0E4..0x02D0FB  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D0E4  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
02D0E8  56                    PUSH   si ; STACK_PUSH
02D0E9  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
02D0EC  50                    PUSH   ax ; STACK_PUSH
02D0ED  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02D0F1  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
02D0F5  98                    CWDE ; ARITH
02D0F6  50                    PUSH   ax ; STACK_PUSH
02D0F7  9A                    DB     0x9A ; DATA_BYTE
02D0F8  C2                    DB     0xC2 ; DATA_BYTE
02D0F9  0C                    DB     0x0C ; DATA_BYTE
02D0FA  1F                    DB     0x1F ; DATA_BYTE
