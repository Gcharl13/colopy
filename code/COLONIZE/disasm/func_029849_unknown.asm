; ============================================================================
; func_029849_unknown
; Region   : load_image
; Bytes    : file 0x029849..0x029892  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029849  55                    PUSH   bp                           ; UNKNOWN
02984A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02984C  83 06 9A 40 08        ADD    word ptr [0x409a], 8         ; UNKNOWN
029851  81 3E 9A 40 24 01     CMP    word ptr [0x409a], 0x124     ; UNKNOWN
029857  7C 13                 JL     0x2986c                      ; UNKNOWN
029859  83 06 9C 40 08        ADD    word ptr [0x409c], 8         ; UNKNOWN
02985E  A0 9A 40              MOV    al, byte ptr [0x409a]        ; UNKNOWN
029861  83 E0 08              AND    ax, 8                        ; UNKNOWN
029864  D1 F8                 SAR    ax, 1                        ; UNKNOWN
029866  83 C0 10              ADD    ax, 0x10                     ; UNKNOWN
029869  A3 9A 40              MOV    word ptr [0x409a], ax        ; UNKNOWN
02986C  81 3E 9C 40 90 00     CMP    word ptr [0x409c], 0x90      ; UNKNOWN
029872  7D 1C                 JGE    0x29890                      ; UNKNOWN
029874  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
029878  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
02987C  FF 36 9C 40           PUSH   word ptr [0x409c]            ; UNKNOWN
029880  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
029883  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
029887  8B 16 9A 40           MOV    dx, word ptr [0x409a]        ; UNKNOWN
02988B  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
029890  C9                    LEAVE                               ; UNKNOWN
029891  C3                    RET                                 ; UNKNOWN
