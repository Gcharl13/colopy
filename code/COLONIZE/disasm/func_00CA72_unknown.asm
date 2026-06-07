; ============================================================================
; func_00CA72_unknown
; Region   : load_image
; Bytes    : file 0x00CA72..0x00CA9F  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CA72  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
00CA76  57                    PUSH   di                           ; UNKNOWN
00CA77  56                    PUSH   si                           ; UNKNOWN
00CA78  6A 00                 PUSH   0                            ; UNKNOWN
00CA7A  68 2C 1A              PUSH   0x1a2c                       ; UNKNOWN
00CA7D  9A 0C 00 E6 21        LCALL  0x21e6, 0xc                  ; UNKNOWN
00CA82  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00CA85  68 DB 1A              PUSH   0x1adb                       ; UNKNOWN
00CA88  68 8B 09              PUSH   0x98b                        ; UNKNOWN
00CA8B  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
00CA90  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00CA93  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
00CA98  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
00CA9D  9A                    DB     0x9A                         ; UNKNOWN (raw)
00CA9E  CF                    DB     0xCF                         ; UNKNOWN (raw)
