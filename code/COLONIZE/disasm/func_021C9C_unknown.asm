; ============================================================================
; func_021C9C_unknown
; Region   : load_image
; Bytes    : file 0x021C9C..0x021CD9  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021C9C  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
021CA0  57                    PUSH   di                           ; UNKNOWN
021CA1  56                    PUSH   si                           ; UNKNOWN
021CA2  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
021CA7  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
021CAA  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38]  ; UNKNOWN
021CAE  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a]  ; UNKNOWN
021CB2  8B F8                 MOV    di, ax                       ; UNKNOWN
021CB4  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
021CB7  8B C8                 MOV    cx, ax                       ; UNKNOWN
021CB9  8B F2                 MOV    si, dx                       ; UNKNOWN
021CBB  8B D8                 MOV    bx, ax                       ; UNKNOWN
021CBD  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
021CC0  0B F1                 OR     si, cx                       ; UNKNOWN
021CC2  74 5C                 JE     0x21d20                      ; UNKNOWN
021CC4  8E DA                 MOV    ds, dx                       ; UNKNOWN
021CC6  8B 4F 02              MOV    cx, word ptr [bx + 2]        ; UNKNOWN
021CC9  03 4F 04              ADD    cx, word ptr [bx + 4]        ; UNKNOWN
021CCC  8C D8                 MOV    ax, ds                       ; UNKNOWN
021CCE  8B FB                 MOV    di, bx                       ; UNKNOWN
021CD0  8E C0                 MOV    es, ax                       ; UNKNOWN
021CD2  C5 5F 16              LDS    bx, ptr [bx + 0x16]          ; UNKNOWN
021CD5  8C D8                 MOV    ax, ds                       ; UNKNOWN
021CD7  0B C3                 OR     ax, bx                       ; UNKNOWN
