; ============================================================================
; func_004A80_unknown
; Region   : load_image
; Bytes    : file 0x004A80..0x004A9A  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004A80  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
004A84  57                    PUSH   di ; STACK_PUSH
004A85  56                    PUSH   si ; STACK_PUSH
004A86  BE 01 00              MOV    si, 1 ; MOV
004A89  2B FF                 SUB    di, di ; ARITH
004A8B  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
004A90  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
004A93  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
004A96  9A                    DB     0x9A ; DATA_BYTE
004A97  30                    DB     0x30 ; DATA_BYTE
004A98  00                    DB     0x00 ; DATA_BYTE
004A99  CB                    DB     0xCB ; DATA_BYTE
