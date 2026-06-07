; ============================================================================
; func_00D972_unknown
; Region   : load_image
; Bytes    : file 0x00D972..0x00D989  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D972  C8 04 01 00           ENTER  0x104, 0 ; PROLOGUE
00D976  57                    PUSH   di ; STACK_PUSH
00D977  56                    PUSH   si ; STACK_PUSH
00D978  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00D97B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D97E  57                    PUSH   di ; STACK_PUSH
00D97F  9A 0A 00 94 10        LCALL  0x1094, 0xa ; LCALL
00D984  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00D987  8B CF                 MOV    cx, di ; MOV
