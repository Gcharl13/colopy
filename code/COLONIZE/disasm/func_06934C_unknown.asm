; ============================================================================
; func_06934C_unknown
; Region   : load_image
; Bytes    : file 0x06934C..0x069382  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06934C  55                    PUSH   bp                           ; UNKNOWN
06934D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06934F  57                    PUSH   di                           ; UNKNOWN
069350  56                    PUSH   si                           ; UNKNOWN
069351  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
069354  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
069357  1E                    PUSH   ds                           ; UNKNOWN
069358  07                    POP    es                           ; UNKNOWN
069359  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06935C  E3 3D                 JCXZ   0x6939b                      ; UNKNOWN
06935E  B7 41                 MOV    bh, 0x41                     ; UNKNOWN
069360  B3 5A                 MOV    bl, 0x5a                     ; UNKNOWN
069362  B6 20                 MOV    dh, 0x20                     ; UNKNOWN
069364  8A 24                 MOV    ah, byte ptr [si]            ; UNKNOWN
069366  8A 05                 MOV    al, byte ptr [di]            ; UNKNOWN
069368  0A E4                 OR     ah, ah                       ; UNKNOWN
06936A  74 20                 JE     0x6938c                      ; UNKNOWN
06936C  0A C0                 OR     al, al                       ; UNKNOWN
06936E  74 1C                 JE     0x6938c                      ; UNKNOWN
069370  46                    INC    si                           ; UNKNOWN
069371  47                    INC    di                           ; UNKNOWN
069372  3A E7                 CMP    ah, bh                       ; UNKNOWN
069374  72 06                 JB     0x6937c                      ; UNKNOWN
069376  3A E3                 CMP    ah, bl                       ; UNKNOWN
069378  77 02                 JA     0x6937c                      ; UNKNOWN
06937A  02 E6                 ADD    ah, dh                       ; UNKNOWN
06937C  3A C7                 CMP    al, bh                       ; UNKNOWN
06937E  72 06                 JB     0x69386                      ; UNKNOWN
069380  3A C3                 CMP    al, bl                       ; UNKNOWN
