; ============================================================================
; func_03234A_unknown
; Region   : overlay
; Bytes    : file 0x03234A..0x03235B  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03234A  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
03234E  57                    PUSH   di ; STACK_PUSH
03234F  56                    PUSH   si ; STACK_PUSH
032350  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
032353  E8 3E FF              CALL   0x32294 ; CALL_NEAR
032356  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
032359  8B CB                 MOV    cx, bx ; MOV
