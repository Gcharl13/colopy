; ============================================================================
; func_03CC41_unknown
; Region   : load_image
; Bytes    : file 0x03CC41..0x03CC55  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CC41  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CC45  83 7E 06 19           CMP    word ptr [bp + 6], 0x19      ; UNKNOWN
03CC49  7D 0A                 JGE    0x3cc55                      ; UNKNOWN
03CC4B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03CC50  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CC53  C9                    LEAVE                               ; UNKNOWN
03CC54  CB                    RETF                                ; UNKNOWN
