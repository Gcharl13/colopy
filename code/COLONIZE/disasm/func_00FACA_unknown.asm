; ============================================================================
; func_00FACA_unknown
; Region   : load_image
; Bytes    : file 0x00FACA..0x00FADF  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FACA  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
00FACE  56                    PUSH   si                           ; UNKNOWN
00FACF  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
00FAD4  83 3E 12 3E 54        CMP    word ptr [0x3e12], 0x54      ; UNKNOWN
00FAD9  7C 03                 JL     0xfade                       ; UNKNOWN
00FADB  E9 C2 00              JMP    0xfba0                       ; UNKNOWN
00FADE  A1                    DB     0xA1                         ; UNKNOWN (raw)
