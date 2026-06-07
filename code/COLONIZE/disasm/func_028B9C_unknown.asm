; ============================================================================
; func_028B9C_unknown
; Region   : load_image
; Bytes    : file 0x028B9C..0x028BDC  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028B9C  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
028BA0  56                    PUSH   si                           ; UNKNOWN
028BA1  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
028BA6  2B C0                 SUB    ax, ax                       ; UNKNOWN
028BA8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
028BAB  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
028BAE  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
028BB2  26 80 7F 20 00        CMP    byte ptr es:[bx + 0x20], 0   ; UNKNOWN
028BB7  74 0A                 JE     0x28bc3                      ; UNKNOWN
028BB9  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
028BBD  8D 06 8B 19           LEA    ax, [0x198b]                 ; UNKNOWN
028BC1  EB 08                 JMP    0x28bcb                      ; UNKNOWN
028BC3  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
028BC7  8D 06 94 19           LEA    ax, [0x1994]                 ; UNKNOWN
028BCB  2B D2                 SUB    dx, dx                       ; UNKNOWN
028BCD  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
028BD2  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
028BD5  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
028BD8  8B C2                 MOV    ax, dx                       ; UNKNOWN
028BDA  0B                    DB     0x0B                         ; UNKNOWN (raw)
028BDB  46                    DB     0x46                         ; UNKNOWN (raw)
