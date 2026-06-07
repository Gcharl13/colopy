; ============================================================================
; func_068898_unknown
; Region   : overlay
; Bytes    : file 0x068898..0x0688A1  (9 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068898  55                    PUSH   bp ; STACK_PUSH
068899  8B EC                 MOV    bp, sp ; MOV
06889B  50                    PUSH   ax ; STACK_PUSH
06889C  0E                    PUSH   cs ; STACK_PUSH
06889D  E8 CA 00              CALL   0x6896a ; CALL_NEAR
0688A0  83                    DB     0x83 ; DATA_BYTE
