; ============================================================================
; func_069438_unknown
; Region   : load_image
; Bytes    : file 0x069438..0x069465  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069438  55                    PUSH   bp                           ; UNKNOWN
069439  8B EC                 MOV    bp, sp                       ; UNKNOWN
06943B  8B D7                 MOV    dx, di                       ; UNKNOWN
06943D  8C D8                 MOV    ax, ds                       ; UNKNOWN
06943F  8E C0                 MOV    es, ax                       ; UNKNOWN
069441  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
069444  8B DF                 MOV    bx, di                       ; UNKNOWN
069446  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
069449  E3 15                 JCXZ   0x69460                      ; UNKNOWN
06944B  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
06944E  8A E0                 MOV    ah, al                       ; UNKNOWN
069450  F7 C7 01 00           TEST   di, 1                        ; UNKNOWN
069454  74 02                 JE     0x69458                      ; UNKNOWN
069456  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
069457  49                    DEC    cx                           ; UNKNOWN
069458  D1 E9                 SHR    cx, 1                        ; UNKNOWN
06945A  F3 AB                 REP STOSW word ptr es:[di], ax         ; UNKNOWN
06945C  13 C9                 ADC    cx, cx                       ; UNKNOWN
06945E  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
069460  8B FA                 MOV    di, dx                       ; UNKNOWN
069462  93                    XCHG   bx, ax                       ; UNKNOWN
069463  5D                    POP    bp                           ; UNKNOWN
069464  CB                    RETF                                ; UNKNOWN
