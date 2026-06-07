; ============================================================================
; func_00F0F1_unknown
; Region   : load_image
; Bytes    : file 0x00F0F1..0x00F10E  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F0F1  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
00F0F5  56                    PUSH   si                           ; UNKNOWN
00F0F6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
00F0FB  9A 0C 00 71 22        LCALL  0x2271, 0xc                  ; UNKNOWN
00F100  6A 04                 PUSH   4                            ; UNKNOWN
00F102  9A A9 00 0B 38        LCALL  0x380b, 0xa9                 ; UNKNOWN
00F107  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00F10A  9A                    DB     0x9A                         ; UNKNOWN (raw)
00F10B  D9                    DB     0xD9                         ; UNKNOWN (raw)
00F10C  00                    DB     0x00                         ; UNKNOWN (raw)
00F10D  CF                    DB     0xCF                         ; UNKNOWN (raw)
