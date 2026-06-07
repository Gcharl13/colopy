; ============================================================================
; func_025868_unknown
; Region   : load_image
; Bytes    : file 0x025868..0x02588D  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025868  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02586C  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
02586F  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
025872  2A E4                 SUB    ah, ah                       ; UNKNOWN
025874  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
025877  83 F8 06              CMP    ax, 6                        ; UNKNOWN
02587A  75 0C                 JNE    0x25888                      ; UNKNOWN
02587C  83 3E 1A 0A 00        CMP    word ptr [0xa1a], 0          ; UNKNOWN
025881  75 05                 JNE    0x25888                      ; UNKNOWN
025883  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5         ; UNKNOWN
025888  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02588B  C9                    LEAVE                               ; UNKNOWN
02588C  C3                    RET                                 ; UNKNOWN
