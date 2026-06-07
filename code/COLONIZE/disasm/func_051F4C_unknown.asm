; ============================================================================
; func_051F4C_unknown
; Region   : load_image
; Bytes    : file 0x051F4C..0x051F6C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051F4C  55                    PUSH   bp                           ; UNKNOWN
051F4D  8B EC                 MOV    bp, sp                       ; UNKNOWN
051F4F  56                    PUSH   si                           ; UNKNOWN
051F50  6B F0 1C              IMUL   si, ax, 0x1c                 ; UNKNOWN
051F53  88 94 87 88           MOV    byte ptr [si - 0x7779], dl   ; UNKNOWN
051F57  C6 84 88 88 0B        MOV    byte ptr [si - 0x7778], 0xb  ; UNKNOWN
051F5C  88 9C 89 88           MOV    byte ptr [si - 0x7777], bl   ; UNKNOWN
051F60  8A 46 04              MOV    al, byte ptr [bp + 4]        ; UNKNOWN
051F63  88 84 8A 88           MOV    byte ptr [si - 0x7776], al   ; UNKNOWN
051F67  5E                    POP    si                           ; UNKNOWN
051F68  C9                    LEAVE                               ; UNKNOWN
051F69  C2 02 00              RET    2                            ; UNKNOWN
