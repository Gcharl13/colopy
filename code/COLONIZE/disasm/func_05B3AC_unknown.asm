; ============================================================================
; func_05B3AC_unknown
; Region   : load_image
; Bytes    : file 0x05B3AC..0x05B3C7  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B3AC  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
05B3B0  56                    PUSH   si                           ; UNKNOWN
05B3B1  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
05B3B4  89 46 C0              MOV    word ptr [bp - 0x40], ax     ; UNKNOWN
05B3B7  89 46 B6              MOV    word ptr [bp - 0x4a], ax     ; UNKNOWN
05B3BA  2B C0                 SUB    ax, ax                       ; UNKNOWN
05B3BC  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
05B3BF  89 46 B0              MOV    word ptr [bp - 0x50], ax     ; UNKNOWN
05B3C2  89 46 CA              MOV    word ptr [bp - 0x36], ax     ; UNKNOWN
05B3C5  8B                    DB     0x8B                         ; UNKNOWN (raw)
05B3C6  46                    DB     0x46                         ; UNKNOWN (raw)
