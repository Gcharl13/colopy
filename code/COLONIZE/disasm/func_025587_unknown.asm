; ============================================================================
; func_025587_unknown
; Region   : load_image
; Bytes    : file 0x025587..0x0255A9  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025587  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02558B  56                    PUSH   si                           ; UNKNOWN
02558C  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02558F  26 8B 47 58           MOV    ax, word ptr es:[bx + 0x58]  ; UNKNOWN
025593  26 8B 57 5A           MOV    dx, word ptr es:[bx + 0x5a]  ; UNKNOWN
025597  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02559A  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
02559D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02559F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0255A2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0255A5  8B C2                 MOV    ax, dx                       ; UNKNOWN
0255A7  0B                    DB     0x0B                         ; UNKNOWN (raw)
0255A8  46                    DB     0x46                         ; UNKNOWN (raw)
