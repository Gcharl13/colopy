; ============================================================================
; func_00E014_unknown
; Region   : load_image
; Bytes    : file 0x00E014..0x00E032  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E014  C8 00 03 00           ENTER  0x300, 0                     ; UNKNOWN
00E018  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
00E01C  16                    PUSH   ss                           ; UNKNOWN
00E01D  50                    PUSH   ax                           ; UNKNOWN
00E01E  9A 04 00 F8 5B        LCALL  0x5bf8, 4                    ; UNKNOWN
00E023  8D 86 00 FD           LEA    ax, [bp - 0x300]             ; UNKNOWN
00E027  16                    PUSH   ss                           ; UNKNOWN
00E028  50                    PUSH   ax                           ; UNKNOWN
00E029  2B C0                 SUB    ax, ax                       ; UNKNOWN
00E02B  9A 2F 00 D7 44        LCALL  0x44d7, 0x2f                 ; UNKNOWN
00E030  C9                    LEAVE                               ; UNKNOWN
00E031  CB                    RETF                                ; UNKNOWN
