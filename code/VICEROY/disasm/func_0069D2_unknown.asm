; ============================================================================
; func_0069D2_unknown
; Region   : load_image
; Bytes    : file 0x0069D2..0x0069DE  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0069D2  55                    PUSH   bp ; STACK_PUSH
0069D3  8B EC                 MOV    bp, sp ; MOV
0069D5  56                    PUSH   si ; STACK_PUSH
0069D6  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0069D9  8B C6                 MOV    ax, si ; MOV
0069DB  0E                    PUSH   cs ; STACK_PUSH
0069DC  E8                    DB     0xE8 ; DATA_BYTE
0069DD  CB                    DB     0xCB ; DATA_BYTE
