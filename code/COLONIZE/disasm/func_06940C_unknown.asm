; ============================================================================
; func_06940C_unknown
; Region   : load_image
; Bytes    : file 0x06940C..0x069438  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06940C  55                    PUSH   bp                           ; UNKNOWN
06940D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06940F  8B D7                 MOV    dx, di                       ; UNKNOWN
069411  8B DE                 MOV    bx, si                       ; UNKNOWN
069413  8C D8                 MOV    ax, ds                       ; UNKNOWN
069415  8E C0                 MOV    es, ax                       ; UNKNOWN
069417  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
06941A  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
06941D  8B C7                 MOV    ax, di                       ; UNKNOWN
06941F  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
069422  E3 0E                 JCXZ   0x69432                      ; UNKNOWN
069424  A8 01                 TEST   al, 1                        ; UNKNOWN
069426  74 02                 JE     0x6942a                      ; UNKNOWN
069428  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
069429  49                    DEC    cx                           ; UNKNOWN
06942A  D1 E9                 SHR    cx, 1                        ; UNKNOWN
06942C  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
06942E  13 C9                 ADC    cx, cx                       ; UNKNOWN
069430  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
069432  8B F3                 MOV    si, bx                       ; UNKNOWN
069434  8B FA                 MOV    di, dx                       ; UNKNOWN
069436  5D                    POP    bp                           ; UNKNOWN
069437  CB                    RETF                                ; UNKNOWN
