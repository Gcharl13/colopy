; ============================================================================
; func_00D77C_unknown
; Region   : load_image
; Bytes    : file 0x00D77C..0x00D796  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D77C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00D780  57                    PUSH   di ; STACK_PUSH
00D781  56                    PUSH   si ; STACK_PUSH
00D782  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00D785  8B 76 0E              MOV    si, word ptr [bp + 0xe] ; LOCAL_LOAD
00D788  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00D78B  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
00D78E  3B CE                 CMP    cx, si ; CMP
00D790  75 04                 JNE    0xd796 ; CJUMP
00D792  3B C2                 CMP    ax, dx ; CMP
00D794  74 0C                 JE     0xd7a2 ; CJUMP
