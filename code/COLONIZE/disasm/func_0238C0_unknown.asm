; ============================================================================
; func_0238C0_unknown
; Region   : load_image
; Bytes    : file 0x0238C0..0x02391D  (93 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0238C0  55                    PUSH   bp                           ; UNKNOWN
0238C1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0238C3  53                    PUSH   bx                           ; UNKNOWN
0238C4  50                    PUSH   ax                           ; UNKNOWN
0238C5  57                    PUSH   di                           ; UNKNOWN
0238C6  56                    PUSH   si                           ; UNKNOWN
0238C7  8B FA                 MOV    di, dx                       ; UNKNOWN
0238C9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0238CC  F7 C6 01 00           TEST   si, 1                        ; UNKNOWN
0238D0  74 25                 JE     0x238f7                      ; UNKNOWN
0238D2  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0238D6  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0238DA  53                    PUSH   bx                           ; UNKNOWN
0238DB  8B C6                 MOV    ax, si                       ; UNKNOWN
0238DD  83 E0 04              AND    ax, 4                        ; UNKNOWN
0238E0  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0238E3  F5                    CMC                                 ; UNKNOWN
0238E4  1A C0                 SBB    al, al                       ; UNKNOWN
0238E6  24 5F                 AND    al, 0x5f                     ; UNKNOWN
0238E8  50                    PUSH   ax                           ; UNKNOWN
0238E9  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0238EC  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0238F0  8B D7                 MOV    dx, di                       ; UNKNOWN
0238F2  9A 0A 00 FF 5D        LCALL  0x5dff, 0xa                  ; UNKNOWN
0238F7  8B C6                 MOV    ax, si                       ; UNKNOWN
0238F9  A8 02                 TEST   al, 2                        ; UNKNOWN
0238FB  74 1A                 JE     0x23917                      ; UNKNOWN
0238FD  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
023901  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
023905  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
023908  8D 55 02              LEA    dx, [di + 2]                 ; UNKNOWN
02390B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02390E  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
023912  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
023917  5E                    POP    si                           ; UNKNOWN
023918  5F                    POP    di                           ; UNKNOWN
023919  C9                    LEAVE                               ; UNKNOWN
02391A  CA 02 00              RETF   2                            ; UNKNOWN
