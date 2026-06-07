; ============================================================================
; func_06AFE4_unknown
; Region   : load_image
; Bytes    : file 0x06AFE4..0x06AFFD  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AFE4  55                    PUSH   bp                           ; UNKNOWN
06AFE5  8B EC                 MOV    bp, sp                       ; UNKNOWN
06AFE7  56                    PUSH   si                           ; UNKNOWN
06AFE8  8B 76 04              MOV    si, word ptr [bp + 4]        ; UNKNOWN
06AFEB  B8 00 02              MOV    ax, 0x200                    ; UNKNOWN
06AFEE  50                    PUSH   ax                           ; UNKNOWN
06AFEF  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06AFF4  59                    POP    cx                           ; UNKNOWN
06AFF5  8B DE                 MOV    bx, si                       ; UNKNOWN
06AFF7  81 EB 78 12           SUB    bx, 0x1278                   ; UNKNOWN
06AFFB  81                    DB     0x81                         ; UNKNOWN (raw)
06AFFC  C3                    DB     0xC3                         ; UNKNOWN (raw)
