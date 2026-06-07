; ============================================================================
; func_0647A6_unknown
; Region   : load_image
; Bytes    : file 0x0647A6..0x0647DA  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0647A6  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0647AA  56                    PUSH   si                           ; UNKNOWN
0647AB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0647B0  8B C8                 MOV    cx, ax                       ; UNKNOWN
0647B2  C4 5E 0E              LES    bx, ptr [bp + 0xe]           ; UNKNOWN
0647B5  26 88 07              MOV    byte ptr es:[bx], al         ; UNKNOWN
0647B8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0647BB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0647BE  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0647C1  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
0647C4  8B F1                 MOV    si, cx                       ; UNKNOWN
0647C6  9A 5C 00 4F 00        LCALL  0x4f, 0x5c                   ; UNKNOWN
0647CB  C4 5E 0E              LES    bx, ptr [bp + 0xe]           ; UNKNOWN
0647CE  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
0647D2  26 89 57 04           MOV    word ptr es:[bx + 4], dx     ; UNKNOWN
0647D6  8B C2                 MOV    ax, dx                       ; UNKNOWN
0647D8  26                    DB     0x26                         ; UNKNOWN (raw)
0647D9  0B                    DB     0x0B                         ; UNKNOWN (raw)
