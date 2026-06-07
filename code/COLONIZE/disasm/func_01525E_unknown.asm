; ============================================================================
; func_01525E_unknown
; Region   : load_image
; Bytes    : file 0x01525E..0x0152AF  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01525E  55                    PUSH   bp                           ; UNKNOWN
01525F  8B EC                 MOV    bp, sp                       ; UNKNOWN
015261  83 3E 56 C1 01        CMP    word ptr [0xc156], 1         ; UNKNOWN
015266  F5                    CMC                                 ; UNKNOWN
015267  1B C0                 SBB    ax, ax                       ; UNKNOWN
015269  25 0F 00              AND    ax, 0xf                      ; UNKNOWN
01526C  50                    PUSH   ax                           ; UNKNOWN
01526D  FF 36 C4 32           PUSH   word ptr [0x32c4]            ; UNKNOWN
015271  68 F2 00              PUSH   0xf2                         ; UNKNOWN
015274  FF 36 FE 32           PUSH   word ptr [0x32fe]            ; UNKNOWN
015278  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
01527D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
015280  52                    PUSH   dx                           ; UNKNOWN
015281  50                    PUSH   ax                           ; UNKNOWN
015282  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
015287  8B E5                 MOV    sp, bp                       ; UNKNOWN
015289  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01528D  74 1E                 JE     0x152ad                      ; UNKNOWN
01528F  FF 36 C4 32           PUSH   word ptr [0x32c4]            ; UNKNOWN
015293  6A 4F                 PUSH   0x4f                         ; UNKNOWN
015295  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
015299  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
01529C  2A E4                 SUB    ah, ah                       ; UNKNOWN
01529E  50                    PUSH   ax                           ; UNKNOWN
01529F  B8 F1 00              MOV    ax, 0xf1                     ; UNKNOWN
0152A2  8B 16 C4 32           MOV    dx, word ptr [0x32c4]        ; UNKNOWN
0152A6  8B D8                 MOV    bx, ax                       ; UNKNOWN
0152A8  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0152AD  C9                    LEAVE                               ; UNKNOWN
0152AE  CB                    RETF                                ; UNKNOWN
