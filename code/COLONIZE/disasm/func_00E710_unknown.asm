; ============================================================================
; func_00E710_unknown
; Region   : load_image
; Bytes    : file 0x00E710..0x00E721  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E710  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
00E714  83 3E 4C 05 00        CMP    word ptr [0x54c], 0          ; UNKNOWN
00E719  74 31                 JE     0xe74c                       ; UNKNOWN
00E71B  C7 46 FA CA 05        MOV    word ptr [bp - 6], 0x5ca     ; UNKNOWN
00E720  8B                    DB     0x8B                         ; UNKNOWN (raw)
