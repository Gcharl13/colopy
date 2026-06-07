; ============================================================================
; func_026383_unknown
; Region   : load_image
; Bytes    : file 0x026383..0x0263BE  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026383  55                    PUSH   bp                           ; UNKNOWN
026384  8B EC                 MOV    bp, sp                       ; UNKNOWN
026386  56                    PUSH   si                           ; UNKNOWN
026387  83 3E 12 0A 00        CMP    word ptr [0xa12], 0          ; UNKNOWN
02638C  74 0A                 JE     0x26398                      ; UNKNOWN
02638E  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026391  26 F6 47 0A 20        TEST   byte ptr es:[bx + 0xa], 0x20 ; UNKNOWN
026396  75 21                 JNE    0x263b9                      ; UNKNOWN
026398  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
02639B  26 FF 77 1A           PUSH   word ptr es:[bx + 0x1a]      ; UNKNOWN
02639F  26 FF 77 1C           PUSH   word ptr es:[bx + 0x1c]      ; UNKNOWN
0263A3  26 FF 77 1E           PUSH   word ptr es:[bx + 0x1e]      ; UNKNOWN
0263A7  26 8B 47 18           MOV    ax, word ptr es:[bx + 0x18]  ; UNKNOWN
0263AB  8B D8                 MOV    bx, ax                       ; UNKNOWN
0263AD  8B 76 04              MOV    si, word ptr [bp + 4]        ; UNKNOWN
0263B0  26 8B 54 1A           MOV    dx, word ptr es:[si + 0x1a]  ; UNKNOWN
0263B4  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0263B9  5E                    POP    si                           ; UNKNOWN
0263BA  C9                    LEAVE                               ; UNKNOWN
0263BB  C2 04 00              RET    4                            ; UNKNOWN
