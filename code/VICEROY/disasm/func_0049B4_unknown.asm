; ============================================================================
; func_0049B4_unknown
; Region   : load_image
; Bytes    : file 0x0049B4..0x0049C2  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0049B4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0049B8  57                    PUSH   di ; STACK_PUSH
0049B9  56                    PUSH   si ; STACK_PUSH
0049BA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0049BD  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
0049C0  8B C3                 MOV    ax, bx ; MOV
