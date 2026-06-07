; ============================================================================
; func_003710_unknown
; Region   : load_image
; Bytes    : file 0x003710..0x003724  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003710  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
003714  57                    PUSH   di ; STACK_PUSH
003715  56                    PUSH   si ; STACK_PUSH
003716  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
003719  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
00371C  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
003720  2A FF                 SUB    bh, bh ; ARITH
003722  8B CB                 MOV    cx, bx ; MOV
