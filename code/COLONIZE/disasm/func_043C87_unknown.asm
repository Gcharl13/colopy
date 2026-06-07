; ============================================================================
; func_043C87_unknown
; Region   : load_image
; Bytes    : file 0x043C87..0x043CE7  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043C87  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
043C8B  50                    PUSH   ax                           ; UNKNOWN
043C8C  56                    PUSH   si                           ; UNKNOWN
043C8D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043C92  3B 16 34 0B           CMP    dx, word ptr [0xb34]         ; UNKNOWN
043C96  7C 49                 JL     0x43ce1                      ; UNKNOWN
043C98  C4 1E A2 C1           LES    bx, ptr [0xc1a2]             ; UNKNOWN
043C9C  2B 1E 94 82           SUB    bx, word ptr [0x8294]        ; UNKNOWN
043CA0  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
043CA3  2A E4                 SUB    ah, ah                       ; UNKNOWN
043CA5  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043CA8  74 04                 JE     0x43cae                      ; UNKNOWN
043CAA  83 46 FE 08           ADD    word ptr [bp - 2], 8         ; UNKNOWN
043CAE  8B 1E A2 C1           MOV    bx, word ptr [0xc1a2]        ; UNKNOWN
043CB2  8B 36 94 82           MOV    si, word ptr [0x8294]        ; UNKNOWN
043CB6  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043CB9  2A E4                 SUB    ah, ah                       ; UNKNOWN
043CBB  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043CBE  74 04                 JE     0x43cc4                      ; UNKNOWN
043CC0  83 46 FE 04           ADD    word ptr [bp - 2], 4         ; UNKNOWN
043CC4  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1]     ; UNKNOWN
043CC8  2A E4                 SUB    ah, ah                       ; UNKNOWN
043CCA  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043CCD  74 04                 JE     0x43cd3                      ; UNKNOWN
043CCF  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
043CD3  26 8A 47 01           MOV    al, byte ptr es:[bx + 1]     ; UNKNOWN
043CD7  2A E4                 SUB    ah, ah                       ; UNKNOWN
043CD9  85 46 FC              TEST   word ptr [bp - 4], ax        ; UNKNOWN
043CDC  74 03                 JE     0x43ce1                      ; UNKNOWN
043CDE  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
043CE1  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
043CE4  5E                    POP    si                           ; UNKNOWN
043CE5  C9                    LEAVE                               ; UNKNOWN
043CE6  C3                    RET                                 ; UNKNOWN
