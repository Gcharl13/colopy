; ============================================================================
; func_069B10_unknown
; Region   : load_image
; Bytes    : file 0x069B10..0x069B56  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069B10  55                    PUSH   bp                           ; UNKNOWN
069B11  8B EC                 MOV    bp, sp                       ; UNKNOWN
069B13  8B D7                 MOV    dx, di                       ; UNKNOWN
069B15  8B DE                 MOV    bx, si                       ; UNKNOWN
069B17  1E                    PUSH   ds                           ; UNKNOWN
069B18  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069B1B  33 C0                 XOR    ax, ax                       ; UNKNOWN
069B1D  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069B20  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069B22  8D 75 FF              LEA    si, [di - 1]                 ; UNKNOWN
069B25  C4 7E 0A              LES    di, ptr [bp + 0xa]           ; UNKNOWN
069B28  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069B2B  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069B2D  F7 D1                 NOT    cx                           ; UNKNOWN
069B2F  2B F9                 SUB    di, cx                       ; UNKNOWN
069B31  8C C0                 MOV    ax, es                       ; UNKNOWN
069B33  8E D8                 MOV    ds, ax                       ; UNKNOWN
069B35  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
069B38  87 FE                 XCHG   si, di                       ; UNKNOWN
069B3A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
069B3D  F7 C6 01 00           TEST   si, 1                        ; UNKNOWN
069B41  74 02                 JE     0x69b45                      ; UNKNOWN
069B43  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
069B44  49                    DEC    cx                           ; UNKNOWN
069B45  D1 E9                 SHR    cx, 1                        ; UNKNOWN
069B47  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
069B49  13 C9                 ADC    cx, cx                       ; UNKNOWN
069B4B  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
069B4D  8B F3                 MOV    si, bx                       ; UNKNOWN
069B4F  8B FA                 MOV    di, dx                       ; UNKNOWN
069B51  1F                    POP    ds                           ; UNKNOWN
069B52  8C C2                 MOV    dx, es                       ; UNKNOWN
069B54  5D                    POP    bp                           ; UNKNOWN
069B55  CB                    RETF                                ; UNKNOWN
