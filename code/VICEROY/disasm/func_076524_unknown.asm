; ============================================================================
; func_076524_unknown
; Region   : overlay
; Bytes    : file 0x076524..0x07653D  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

076524  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
076528  8B 0E 16 A6           MOV    cx, word ptr [0xa616] ; GLOBAL_LOAD
07652C  8B 16 18 A6           MOV    dx, word ptr [0xa618] ; GLOBAL_LOAD
076530  89 0E F6 23           MOV    word ptr [0x23f6], cx ; GLOBAL_LOAD
076534  89 16 F8 23           MOV    word ptr [0x23f8], dx ; GLOBAL_LOAD
076538  8B 0E CA 23           MOV    cx, word ptr [0x23ca] ; GLOBAL_LOAD
07653C  8B                    DB     0x8B ; DATA_BYTE
