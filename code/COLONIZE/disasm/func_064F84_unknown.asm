; ============================================================================
; func_064F84_unknown
; Region   : load_image
; Bytes    : file 0x064F84..0x064FB5  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064F84  55                    PUSH   bp                           ; UNKNOWN
064F85  8B EC                 MOV    bp, sp                       ; UNKNOWN
064F87  57                    PUSH   di                           ; UNKNOWN
064F88  56                    PUSH   si                           ; UNKNOWN
064F89  C7 06 7C 0C 01 00     MOV    word ptr [0xc7c], 1          ; UNKNOWN
064F8F  BB 40 00              MOV    bx, 0x40                     ; UNKNOWN
064F92  BE 00 03              MOV    si, 0x300                    ; UNKNOWN
064F95  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
064F98  BA C7 03              MOV    dx, 0x3c7                    ; UNKNOWN
064F9B  32 C0                 XOR    al, al                       ; UNKNOWN
064F9D  EE                    OUT    dx, al                       ; UNKNOWN
064F9E  BA DA 03              MOV    dx, 0x3da                    ; UNKNOWN
064FA1  B4 08                 MOV    ah, 8                        ; UNKNOWN
064FA3  EC                    IN     al, dx                       ; UNKNOWN
064FA4  22 C4                 AND    al, ah                       ; UNKNOWN
064FA6  75 FB                 JNE    0x64fa3                      ; UNKNOWN
064FA8  EC                    IN     al, dx                       ; UNKNOWN
064FA9  22 C4                 AND    al, ah                       ; UNKNOWN
064FAB  74 FB                 JE     0x64fa8                      ; UNKNOWN
064FAD  FA                    CLI                                 ; UNKNOWN
064FAE  BA C9 03              MOV    dx, 0x3c9                    ; UNKNOWN
064FB1  8B CE                 MOV    cx, si                       ; UNKNOWN
064FB3  3B CB                 CMP    cx, bx                       ; UNKNOWN
