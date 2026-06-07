; ============================================================================
; func_0485F6_unknown
; Region   : overlay
; Bytes    : file 0x0485F6..0x048608  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0485F6  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
0485FA  56                    PUSH   si ; STACK_PUSH
0485FB  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
048600  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
048604  9A                    DB     0x9A ; DATA_BYTE
048605  CA                    DB     0xCA ; DATA_BYTE
048606  04                    DB     0x04 ; DATA_BYTE
048607  1F                    DB     0x1F ; DATA_BYTE
