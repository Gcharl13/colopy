; ============================================================================
; func_003D2E_unknown
; Region   : load_image
; Bytes    : file 0x003D2E..0x003D42  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003D2E  55                    PUSH   bp ; STACK_PUSH
003D2F  8B EC                 MOV    bp, sp ; MOV
003D31  B8 00 00              MOV    ax, 0 ; MOV
003D34  9A DC 03 52 04        LCALL  0x452, 0x3dc ; LCALL
003D39  56                    PUSH   si ; STACK_PUSH
003D3A  57                    PUSH   di ; STACK_PUSH
003D3B  B4 62                 MOV    ah, 0x62 ; CONST_LOAD
003D3D  CD 21                 INT    0x21 ; SYS
003D3F  4B                    DEC    bx ; ARITH
003D40  8E C3                 MOV    es, bx ; MOV
