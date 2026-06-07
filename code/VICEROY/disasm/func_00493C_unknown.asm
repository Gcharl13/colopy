; ============================================================================
; func_00493C_unknown
; Region   : load_image
; Bytes    : file 0x00493C..0x00494A  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00493C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
004940  57                    PUSH   di ; STACK_PUSH
004941  56                    PUSH   si ; STACK_PUSH
004942  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004945  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
004948  8B C3                 MOV    ax, bx ; MOV
