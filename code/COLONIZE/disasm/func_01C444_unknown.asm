; ============================================================================
; func_01C444_unknown
; Region   : load_image
; Bytes    : file 0x01C444..0x01C47C  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C444  C8 60 00 00           ENTER  0x60, 0                      ; UNKNOWN
01C448  56                    PUSH   si                           ; UNKNOWN
01C449  2B C0                 SUB    ax, ax                       ; UNKNOWN
01C44B  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
01C44E  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
01C451  A1 40 73              MOV    ax, word ptr [0x7340]        ; UNKNOWN
01C454  8B 16 42 73           MOV    dx, word ptr [0x7342]        ; UNKNOWN
01C458  9A 83 01 B7 36        LCALL  0x36b7, 0x183                ; UNKNOWN
01C45D  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
01C460  0B C0                 OR     ax, ax                       ; UNKNOWN
01C462  7D 03                 JGE    0x1c467                      ; UNKNOWN
01C464  E9 1B 02              JMP    0x1c682                      ; UNKNOWN
01C467  9A 0C 13 B7 36        LCALL  0x36b7, 0x130c               ; UNKNOWN
01C46C  0B C0                 OR     ax, ax                       ; UNKNOWN
01C46E  74 06                 JE     0x1c476                      ; UNKNOWN
01C470  8B 46 A0              MOV    ax, word ptr [bp - 0x60]     ; UNKNOWN
01C473  A3 0A 3E              MOV    word ptr [0x3e0a], ax        ; UNKNOWN
01C476  6B 5E A0 1C           IMUL   bx, word ptr [bp - 0x60], 0x1c ; UNKNOWN
01C47A  8B C3                 MOV    ax, bx                       ; UNKNOWN
