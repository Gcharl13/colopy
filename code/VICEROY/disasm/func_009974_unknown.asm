; ============================================================================
; func_009974_unknown
; Region   : load_image
; Bytes    : file 0x009974..0x009986  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009974  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
009978  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
00997D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
009980  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
009983  0E                    PUSH   cs ; STACK_PUSH
009984  E8                    DB     0xE8 ; DATA_BYTE
009985  CF                    DB     0xCF ; DATA_BYTE
