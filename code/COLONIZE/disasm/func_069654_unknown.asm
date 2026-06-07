; ============================================================================
; func_069654_unknown
; Region   : load_image
; Bytes    : file 0x069654..0x069684  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069654  55                    PUSH   bp                           ; UNKNOWN
069655  8B EC                 MOV    bp, sp                       ; UNKNOWN
069657  B4 3A                 MOV    ah, 0x3a                     ; UNKNOWN
069659  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
06965C  CD 21                 INT    0x21                         ; UNKNOWN
06965E  73 F1                 JAE    0x69651                      ; UNKNOWN
069660  3D 10 00              CMP    ax, 0x10                     ; UNKNOWN
069663  75 EC                 JNE    0x69651                      ; UNKNOWN
069665  92                    XCHG   dx, ax                       ; UNKNOWN
069666  93                    XCHG   bx, ax                       ; UNKNOWN
069667  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
069669  43                    INC    bx                           ; UNKNOWN
06966A  3C 00                 CMP    al, 0                        ; UNKNOWN
06966C  74 0A                 JE     0x69678                      ; UNKNOWN
06966E  3C 3F                 CMP    al, 0x3f                     ; UNKNOWN
069670  74 04                 JE     0x69676                      ; UNKNOWN
069672  3C 2A                 CMP    al, 0x2a                     ; UNKNOWN
069674  75 F1                 JNE    0x69667                      ; UNKNOWN
069676  B2 03                 MOV    dl, 3                        ; UNKNOWN
069678  92                    XCHG   dx, ax                       ; UNKNOWN
069679  F9                    STC                                 ; UNKNOWN
06967A  EB D5                 JMP    0x69651                      ; UNKNOWN
06967C  B4 19                 MOV    ah, 0x19                     ; UNKNOWN
06967E  CD 21                 INT    0x21                         ; UNKNOWN
069680  B4 00                 MOV    ah, 0                        ; UNKNOWN
069682  40                    INC    ax                           ; UNKNOWN
069683  CB                    RETF                                ; UNKNOWN
