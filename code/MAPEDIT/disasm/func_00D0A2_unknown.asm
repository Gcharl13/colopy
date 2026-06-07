; ============================================================================
; func_00D0A2_unknown
; Region   : load_image
; Bytes    : file 0x00D0A2..0x00D0B0  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D0A2  55                    PUSH   bp ; STACK_PUSH
00D0A3  8B EC                 MOV    bp, sp ; MOV
00D0A5  53                    PUSH   bx ; STACK_PUSH
00D0A6  52                    PUSH   dx ; STACK_PUSH
00D0A7  50                    PUSH   ax ; STACK_PUSH
00D0A8  B8 01 00              MOV    ax, 1 ; MOV
00D0AB  BB 0A 53              MOV    bx, 0x530a ; CONST_LOAD
00D0AE  83                    DB     0x83 ; DATA_BYTE
00D0AF  C3                    DB     0xC3 ; DATA_BYTE
