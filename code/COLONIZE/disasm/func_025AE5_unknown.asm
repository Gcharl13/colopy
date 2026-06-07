; ============================================================================
; func_025AE5_unknown
; Region   : load_image
; Bytes    : file 0x025AE5..0x025B29  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025AE5  C8 6A 01 00           ENTER  0x16a, 0                     ; UNKNOWN
025AE9  50                    PUSH   ax                           ; UNKNOWN
025AEA  57                    PUSH   di                           ; UNKNOWN
025AEB  56                    PUSH   si                           ; UNKNOWN
025AEC  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
025AEF  26 8B 47 58           MOV    ax, word ptr es:[bx + 0x58]  ; UNKNOWN
025AF3  26 8B 57 5A           MOV    dx, word ptr es:[bx + 0x5a]  ; UNKNOWN
025AF7  89 86 F4 FE           MOV    word ptr [bp - 0x10c], ax    ; UNKNOWN
025AFB  89 96 F6 FE           MOV    word ptr [bp - 0x10a], dx    ; UNKNOWN
025AFF  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48]  ; UNKNOWN
025B03  D1 E0                 SHL    ax, 1                        ; UNKNOWN
025B05  26 2B 47 28           SUB    ax, word ptr es:[bx + 0x28]  ; UNKNOWN
025B09  F7 D8                 NEG    ax                           ; UNKNOWN
025B0B  89 86 F8 FE           MOV    word ptr [bp - 0x108], ax    ; UNKNOWN
025B0F  26 8B 47 2C           MOV    ax, word ptr es:[bx + 0x2c]  ; UNKNOWN
025B13  89 86 F2 FE           MOV    word ptr [bp - 0x10e], ax    ; UNKNOWN
025B17  C6 86 FA FE 00        MOV    byte ptr [bp - 0x106], 0     ; UNKNOWN
025B1C  2B C0                 SUB    ax, ax                       ; UNKNOWN
025B1E  89 86 9A FE           MOV    word ptr [bp - 0x166], ax    ; UNKNOWN
025B22  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
025B25  8B C2                 MOV    ax, dx                       ; UNKNOWN
025B27  0B                    DB     0x0B                         ; UNKNOWN (raw)
025B28  86                    DB     0x86                         ; UNKNOWN (raw)
