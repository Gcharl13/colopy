; ============================================================================
; func_0322D0_unknown
; Region   : overlay
; Bytes    : file 0x0322D0..0x0322E5  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0322D0  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0322D4  56                    PUSH   si ; STACK_PUSH
0322D5  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0322DA  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0322DD  E8 B4 FF              CALL   0x32294 ; CALL_NEAR
0322E0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0322E3  8B CB                 MOV    cx, bx ; MOV
