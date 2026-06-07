; ============================================================================
; func_069ADA_unknown
; Region   : load_image
; Bytes    : file 0x069ADA..0x069B10  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069ADA  55                    PUSH   bp                           ; UNKNOWN
069ADB  8B EC                 MOV    bp, sp                       ; UNKNOWN
069ADD  8B D7                 MOV    dx, di                       ; UNKNOWN
069ADF  8B DE                 MOV    bx, si                       ; UNKNOWN
069AE1  1E                    PUSH   ds                           ; UNKNOWN
069AE2  C5 76 0A              LDS    si, ptr [bp + 0xa]           ; UNKNOWN
069AE5  8B FE                 MOV    di, si                       ; UNKNOWN
069AE7  8C D8                 MOV    ax, ds                       ; UNKNOWN
069AE9  8E C0                 MOV    es, ax                       ; UNKNOWN
069AEB  33 C0                 XOR    ax, ax                       ; UNKNOWN
069AED  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069AF0  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069AF2  F7 D1                 NOT    cx                           ; UNKNOWN
069AF4  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069AF7  8B C7                 MOV    ax, di                       ; UNKNOWN
069AF9  A8 01                 TEST   al, 1                        ; UNKNOWN
069AFB  74 02                 JE     0x69aff                      ; UNKNOWN
069AFD  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
069AFE  49                    DEC    cx                           ; UNKNOWN
069AFF  D1 E9                 SHR    cx, 1                        ; UNKNOWN
069B01  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
069B03  13 C9                 ADC    cx, cx                       ; UNKNOWN
069B05  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
069B07  8B F3                 MOV    si, bx                       ; UNKNOWN
069B09  8B FA                 MOV    di, dx                       ; UNKNOWN
069B0B  1F                    POP    ds                           ; UNKNOWN
069B0C  8C C2                 MOV    dx, es                       ; UNKNOWN
069B0E  5D                    POP    bp                           ; UNKNOWN
069B0F  CB                    RETF                                ; UNKNOWN
