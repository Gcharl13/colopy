; ============================================================================
; func_06930A_unknown
; Region   : load_image
; Bytes    : file 0x06930A..0x06934C  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06930A  55                    PUSH   bp                           ; UNKNOWN
06930B  8B EC                 MOV    bp, sp                       ; UNKNOWN
06930D  8B D6                 MOV    dx, si                       ; UNKNOWN
06930F  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
069312  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
069315  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
069317  0A C0                 OR     al, al                       ; UNKNOWN
069319  74 2C                 JE     0x69347                      ; UNKNOWN
06931B  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06931C  8A 27                 MOV    ah, byte ptr [bx]            ; UNKNOWN
06931E  43                    INC    bx                           ; UNKNOWN
06931F  3A E0                 CMP    ah, al                       ; UNKNOWN
069321  74 F4                 JE     0x69317                      ; UNKNOWN
069323  2C 41                 SUB    al, 0x41                     ; UNKNOWN
069325  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
069327  1A C9                 SBB    cl, cl                       ; UNKNOWN
069329  80 E1 20              AND    cl, 0x20                     ; UNKNOWN
06932C  02 C1                 ADD    al, cl                       ; UNKNOWN
06932E  04 41                 ADD    al, 0x41                     ; UNKNOWN
069330  86 E0                 XCHG   al, ah                       ; UNKNOWN
069332  2C 41                 SUB    al, 0x41                     ; UNKNOWN
069334  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
069336  1A C9                 SBB    cl, cl                       ; UNKNOWN
069338  80 E1 20              AND    cl, 0x20                     ; UNKNOWN
06933B  02 C1                 ADD    al, cl                       ; UNKNOWN
06933D  04 41                 ADD    al, 0x41                     ; UNKNOWN
06933F  3A C4                 CMP    al, ah                       ; UNKNOWN
069341  74 D4                 JE     0x69317                      ; UNKNOWN
069343  1A C0                 SBB    al, al                       ; UNKNOWN
069345  1C FF                 SBB    al, 0xff                     ; UNKNOWN
069347  98                    CWDE                                ; UNKNOWN
069348  8B F2                 MOV    si, dx                       ; UNKNOWN
06934A  5D                    POP    bp                           ; UNKNOWN
06934B  CB                    RETF                                ; UNKNOWN
