; ============================================================================
; func_00A912_unknown
; Region   : load_image
; Bytes    : file 0x00A912..0x00A920  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A912  55                    PUSH   bp ; STACK_PUSH
00A913  8B EC                 MOV    bp, sp ; MOV
00A915  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
00A919  75 06                 JNE    0xa921 ; CJUMP
00A91B  C7                    DB     0xC7 ; DATA_BYTE
00A91C  06                    DB     0x06 ; DATA_BYTE
00A91D  C2                    DB     0xC2 ; DATA_BYTE
00A91E  3F                    DB     0x3F ; DATA_BYTE
00A91F  00                    DB     0x00 ; DATA_BYTE
