; ============================================================================
; func_06996C_unknown
; Region   : load_image
; Bytes    : file 0x06996C..0x069996  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06996C  55                    PUSH   bp                           ; UNKNOWN
06996D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06996F  57                    PUSH   di                           ; UNKNOWN
069970  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069973  8B DF                 MOV    bx, di                       ; UNKNOWN
069975  33 C0                 XOR    ax, ax                       ; UNKNOWN
069977  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
06997A  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
06997C  41                    INC    cx                           ; UNKNOWN
06997D  F7 D9                 NEG    cx                           ; UNKNOWN
06997F  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
069982  8B FB                 MOV    di, bx                       ; UNKNOWN
069984  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069986  4F                    DEC    di                           ; UNKNOWN
069987  26 38 05              CMP    byte ptr es:[di], al         ; UNKNOWN
06998A  74 04                 JE     0x69990                      ; UNKNOWN
06998C  33 FF                 XOR    di, di                       ; UNKNOWN
06998E  8E C7                 MOV    es, di                       ; UNKNOWN
069990  8B C7                 MOV    ax, di                       ; UNKNOWN
069992  8C C2                 MOV    dx, es                       ; UNKNOWN
069994  5F                    POP    di                           ; UNKNOWN
069995  8B                    DB     0x8B                         ; UNKNOWN (raw)
