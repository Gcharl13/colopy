; ============================================================================
; func_03341B_unknown
; Region   : load_image
; Bytes    : file 0x03341B..0x03343E  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03341B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03341F  2B C0                 SUB    ax, ax                       ; UNKNOWN
033421  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
033424  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
033427  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
033429  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
03342C  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
03342F  8B D0                 MOV    dx, ax                       ; UNKNOWN
033431  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
033436  EB 3F                 JMP    0x33477                      ; UNKNOWN
033438  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
03343C  8B C3                 MOV    ax, bx                       ; UNKNOWN
