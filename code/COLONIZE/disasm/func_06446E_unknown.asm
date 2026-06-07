; ============================================================================
; func_06446E_unknown
; Region   : load_image
; Bytes    : file 0x06446E..0x064485  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06446E  C8 04 01 00           ENTER  0x104, 0                     ; UNKNOWN
064472  57                    PUSH   di                           ; UNKNOWN
064473  56                    PUSH   si                           ; UNKNOWN
064474  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
064477  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06447A  57                    PUSH   di                           ; UNKNOWN
06447B  9A 00 00 91 5E        LCALL  0x5e91, 0                    ; UNKNOWN
064480  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
064483  8B CF                 MOV    cx, di                       ; UNKNOWN
