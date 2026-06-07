; ============================================================================
; func_00B176_unknown
; Region   : load_image
; Bytes    : file 0x00B176..0x00B17E  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B176  55                    PUSH   bp ; STACK_PUSH
00B177  8B EC                 MOV    bp, sp ; MOV
00B179  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00B17C  F6                    DB     0xF6 ; DATA_BYTE
00B17D  C3                    DB     0xC3 ; DATA_BYTE
