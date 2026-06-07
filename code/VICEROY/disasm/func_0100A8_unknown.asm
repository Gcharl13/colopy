; ============================================================================
; func_0100A8_unknown
; Region   : load_image
; Bytes    : file 0x0100A8..0x0100C9  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0100A8  55                    PUSH   bp ; STACK_PUSH
0100A9  8B EC                 MOV    bp, sp ; MOV
0100AB  57                    PUSH   di ; STACK_PUSH
0100AC  56                    PUSH   si ; STACK_PUSH
0100AD  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0100B0  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
0100B3  2A E4                 SUB    ah, ah ; ARITH
0100B5  8B F8                 MOV    di, ax ; MOV
0100B7  56                    PUSH   si ; STACK_PUSH
0100B8  9A 96 18 1D 0D        LCALL  0xd1d, 0x1896 ; LCALL
0100BD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0100C0  80 A5 BB 27 FD        AND    byte ptr [di + 0x27bb], 0xfd ; LOGIC
0100C5  80 64 06 CF           AND    byte ptr [si + 6], 0xcf ; LOGIC
