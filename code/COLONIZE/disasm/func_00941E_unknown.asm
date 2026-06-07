; ============================================================================
; func_00941E_unknown
; Region   : load_image
; Bytes    : file 0x00941E..0x009432  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00941E  55                    PUSH   bp                           ; UNKNOWN
00941F  8B EC                 MOV    bp, sp                       ; UNKNOWN
009421  B8 02 58              MOV    ax, 0x5802                   ; UNKNOWN
009424  CD 21                 INT    0x21                         ; UNKNOWN
009426  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
009429  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
00942B  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00942E  C9                    LEAVE                               ; UNKNOWN
00942F  C2 02 00              RET    2                            ; UNKNOWN
