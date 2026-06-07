; ============================================================================
; func_026758_unknown
; Region   : load_image
; Bytes    : file 0x026758..0x02678C  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026758  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
02675C  50                    PUSH   ax                           ; UNKNOWN
02675D  57                    PUSH   di                           ; UNKNOWN
02675E  56                    PUSH   si                           ; UNKNOWN
02675F  C7 06 0A 0A 00 00     MOV    word ptr [0xa0a], 0          ; UNKNOWN
026765  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026768  26 8B 47 24           MOV    ax, word ptr es:[bx + 0x24]  ; UNKNOWN
02676C  26 03 47 48           ADD    ax, word ptr es:[bx + 0x48]  ; UNKNOWN
026770  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
026773  26 8B 47 26           MOV    ax, word ptr es:[bx + 0x26]  ; UNKNOWN
026777  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
02677A  26 8B 47 60           MOV    ax, word ptr es:[bx + 0x60]  ; UNKNOWN
02677E  26 8B 57 62           MOV    dx, word ptr es:[bx + 0x62]  ; UNKNOWN
026782  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
026785  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
026788  8B C2                 MOV    ax, dx                       ; UNKNOWN
02678A  0B                    DB     0x0B                         ; UNKNOWN (raw)
02678B  46                    DB     0x46                         ; UNKNOWN (raw)
