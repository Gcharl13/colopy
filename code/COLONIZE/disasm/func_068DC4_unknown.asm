; ============================================================================
; func_068DC4_unknown
; Region   : load_image
; Bytes    : file 0x068DC4..0x068DF6  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068DC4  55                    PUSH   bp                           ; UNKNOWN
068DC5  8B EC                 MOV    bp, sp                       ; UNKNOWN
068DC7  8B D7                 MOV    dx, di                       ; UNKNOWN
068DC9  8B DE                 MOV    bx, si                       ; UNKNOWN
068DCB  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
068DCE  8B FE                 MOV    di, si                       ; UNKNOWN
068DD0  8C D8                 MOV    ax, ds                       ; UNKNOWN
068DD2  8E C0                 MOV    es, ax                       ; UNKNOWN
068DD4  33 C0                 XOR    ax, ax                       ; UNKNOWN
068DD6  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068DD9  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068DDB  F7 D1                 NOT    cx                           ; UNKNOWN
068DDD  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068DE0  8B C7                 MOV    ax, di                       ; UNKNOWN
068DE2  A8 01                 TEST   al, 1                        ; UNKNOWN
068DE4  74 02                 JE     0x68de8                      ; UNKNOWN
068DE6  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
068DE7  49                    DEC    cx                           ; UNKNOWN
068DE8  D1 E9                 SHR    cx, 1                        ; UNKNOWN
068DEA  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
068DEC  13 C9                 ADC    cx, cx                       ; UNKNOWN
068DEE  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
068DF0  8B F3                 MOV    si, bx                       ; UNKNOWN
068DF2  8B FA                 MOV    di, dx                       ; UNKNOWN
068DF4  5D                    POP    bp                           ; UNKNOWN
068DF5  CB                    RETF                                ; UNKNOWN
