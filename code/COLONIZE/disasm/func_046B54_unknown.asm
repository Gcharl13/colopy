; ============================================================================
; func_046B54_unknown
; Region   : load_image
; Bytes    : file 0x046B54..0x046B74  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046B54  C8 9A 00 00           ENTER  0x9a, 0                      ; UNKNOWN
046B58  60                    PUSHAW                              ; UNKNOWN
046B59  15 83 C4              ADC    ax, 0xc483                   ; UNKNOWN
046B5C  04 0B                 ADD    al, 0xb                      ; UNKNOWN
046B5E  C0 74 27 FF           SAL    byte ptr [si + 0x27], 0xff   ; UNKNOWN
046B62  76 0A                 JBE    0x46b6e                      ; UNKNOWN
046B64  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
046B67  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
046B6C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046B6F  69 D8 CA 00           IMUL   bx, ax, 0xca                 ; UNKNOWN
046B73  F6                    DB     0xF6                         ; UNKNOWN (raw)
