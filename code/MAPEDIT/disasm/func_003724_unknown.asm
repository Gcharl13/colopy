; ============================================================================
; func_003724_unknown
; Region   : load_image
; Bytes    : file 0x003724..0x003744  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003724  55                    PUSH   bp ; STACK_PUSH
003725  8B EC                 MOV    bp, sp ; MOV
003727  57                    PUSH   di ; STACK_PUSH
003728  56                    PUSH   si ; STACK_PUSH
003729  9A 06 00 18 0D        LCALL  0xd18, 6 ; LCALL
00372E  05 14 00              ADD    ax, 0x14 ; ARITH
003731  83 D2 00              ADC    dx, 0 ; ARITH
003734  A3 A0 4E              MOV    word ptr [0x4ea0], ax ; GLOBAL_LOAD
003737  89 16 A2 4E           MOV    word ptr [0x4ea2], dx ; GLOBAL_LOAD
00373B  2B F6                 SUB    si, si ; ARITH
00373D  89 36 72 69           MOV    word ptr [0x6972], si ; GLOBAL_LOAD
003741  0E                    PUSH   cs ; STACK_PUSH
003742  E8                    DB     0xE8 ; DATA_BYTE
003743  CB                    DB     0xCB ; DATA_BYTE
