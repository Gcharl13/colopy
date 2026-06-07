; ============================================================================
; func_050175_unknown
; Region   : load_image
; Bytes    : file 0x050175..0x050191  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050175  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
050179  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05017E  EB 03                 JMP    0x50183                      ; UNKNOWN
050180  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
050183  83 7E FE 10           CMP    word ptr [bp - 2], 0x10      ; UNKNOWN
050187  7D 47                 JGE    0x501d0                      ; UNKNOWN
050189  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
05018C  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
05018F  8B CB                 MOV    cx, bx                       ; UNKNOWN
