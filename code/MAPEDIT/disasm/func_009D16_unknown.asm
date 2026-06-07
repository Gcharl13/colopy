; ============================================================================
; func_009D16_unknown
; Region   : load_image
; Bytes    : file 0x009D16..0x009D22  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009D16  55                    PUSH   bp ; STACK_PUSH
009D17  8B EC                 MOV    bp, sp ; MOV
009D19  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
009D1C  0B DB                 OR     bx, bx ; LOGIC
009D1E  7F 07                 JG     0x9d27 ; CJUMP
009D20  8B C3                 MOV    ax, bx ; MOV
