; ============================================================================
; func_00D920_unknown
; Region   : load_image
; Bytes    : file 0x00D920..0x00D92E  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D920  55                    PUSH   bp ; STACK_PUSH
00D921  8B EC                 MOV    bp, sp ; MOV
00D923  56                    PUSH   si ; STACK_PUSH
00D924  8B F2                 MOV    si, dx ; MOV
00D926  0B C0                 OR     ax, ax ; LOGIC
00D928  74 0A                 JE     0xd934 ; CJUMP
00D92A  6A FF                 PUSH   -1 ; STACK_PUSH
00D92C  9A                    DB     0x9A ; DATA_BYTE
00D92D  C3                    DB     0xC3 ; DATA_BYTE
