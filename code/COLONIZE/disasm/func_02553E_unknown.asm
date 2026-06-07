; ============================================================================
; func_02553E_unknown
; Region   : load_image
; Bytes    : file 0x02553E..0x025578  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02553E  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
025542  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
025545  26 80 4F 0A 05        OR     byte ptr es:[bx + 0xa], 5    ; UNKNOWN
02554A  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02554D  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
025550  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
025553  06                    PUSH   es                           ; UNKNOWN
025554  53                    PUSH   bx                           ; UNKNOWN
025555  0E                    PUSH   cs                           ; UNKNOWN
025556  E8 FD FD              CALL   0x25356                      ; UNKNOWN
025559  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
02555C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02555F  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
025562  0B D0                 OR     dx, ax                       ; UNKNOWN
025564  74 0A                 JE     0x25570                      ; UNKNOWN
025566  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
025569  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
02556C  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
025570  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
025573  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
025576  C9                    LEAVE                               ; UNKNOWN
025577  CB                    RETF                                ; UNKNOWN
