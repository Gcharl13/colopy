; ============================================================================
; func_065D26_unknown
; Region   : overlay
; Bytes    : file 0x065D26..0x065D33  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065D26  C8 DA 00 00           ENTER  0xda, 0 ; PROLOGUE
065D2A  56                    PUSH   si ; STACK_PUSH
065D2B  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
065D2F  9A                    DB     0x9A ; DATA_BYTE
065D30  CA                    DB     0xCA ; DATA_BYTE
065D31  04                    DB     0x04 ; DATA_BYTE
065D32  1F                    DB     0x1F ; DATA_BYTE
