; ============================================================================
; func_033483_unknown
; Region   : load_image
; Bytes    : file 0x033483..0x0334AB  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033483  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
033487  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03348A  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03348D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
033490  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
033493  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
033496  8B D0                 MOV    dx, ax                       ; UNKNOWN
033498  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03349D  EB 36                 JMP    0x334d5                      ; UNKNOWN
03349F  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c  ; UNKNOWN
0334A3  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0334A7  2A FF                 SUB    bh, bh                       ; UNKNOWN
0334A9  8B C3                 MOV    ax, bx                       ; UNKNOWN
