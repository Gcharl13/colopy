; ============================================================================
; func_00232A_unknown
; Region   : load_image
; Bytes    : file 0x00232A..0x002332  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00232A  55                    PUSH   bp ; STACK_PUSH
00232B  8B EC                 MOV    bp, sp ; MOV
00232D  FF 36 C2 04           PUSH   word ptr [0x4c2] ; PUSH_GLOBAL
002331  FF                    DB     0xFF ; DATA_BYTE
