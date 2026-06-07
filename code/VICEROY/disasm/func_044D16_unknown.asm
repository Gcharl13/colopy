; ============================================================================
; func_044D16_unknown
; Region   : overlay
; Bytes    : file 0x044D16..0x044D30  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044D16  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
044D1A  57                    PUSH   di ; STACK_PUSH
044D1B  56                    PUSH   si ; STACK_PUSH
044D1C  2B C0                 SUB    ax, ax ; ARITH
044D1E  99                    CDQ ; ARITH
044D1F  8B F0                 MOV    si, ax ; MOV
044D21  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
044D24  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
044D27  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
044D2A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
044D2D  0E                    PUSH   cs ; STACK_PUSH
044D2E  E8                    DB     0xE8 ; DATA_BYTE
044D2F  CB                    DB     0xCB ; DATA_BYTE
