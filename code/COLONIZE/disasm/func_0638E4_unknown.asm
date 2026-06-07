; ============================================================================
; func_0638E4_unknown
; Region   : load_image
; Bytes    : file 0x0638E4..0x063945  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0638E4  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
0638E8  53                    PUSH   bx                           ; UNKNOWN
0638E9  52                    PUSH   dx                           ; UNKNOWN
0638EA  50                    PUSH   ax                           ; UNKNOWN
0638EB  57                    PUSH   di                           ; UNKNOWN
0638EC  56                    PUSH   si                           ; UNKNOWN
0638ED  2B 5E 0E              SUB    bx, word ptr [bp + 0xe]      ; UNKNOWN
0638F0  F7 DB                 NEG    bx                           ; UNKNOWN
0638F2  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
0638F5  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0638F8  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
0638FB  8B 4E 12              MOV    cx, word ptr [bp + 0x12]     ; UNKNOWN
0638FE  0B 4E 10              OR     cx, word ptr [bp + 0x10]     ; UNKNOWN
063901  74 05                 JE     0x63908                      ; UNKNOWN
063903  B8 01 00              MOV    ax, 1                        ; UNKNOWN
063906  EB 02                 JMP    0x6390a                      ; UNKNOWN
063908  2B C0                 SUB    ax, ax                       ; UNKNOWN
06390A  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
06390D  0B C0                 OR     ax, ax                       ; UNKNOWN
06390F  74 55                 JE     0x63966                      ; UNKNOWN
063911  8D 5E 0C              LEA    bx, [bp + 0xc]               ; UNKNOWN
063914  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
063917  8B 56 F4              MOV    dx, word ptr [bp - 0xc]      ; UNKNOWN
06391A  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
06391F  52                    PUSH   dx                           ; UNKNOWN
063920  50                    PUSH   ax                           ; UNKNOWN
063921  9A 06 00 4E 00        LCALL  0x4e, 6                      ; UNKNOWN
063926  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
063929  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
06392C  C4 7E FA              LES    di, ptr [bp - 6]             ; UNKNOWN
06392F  8A 66 08              MOV    ah, byte ptr [bp + 8]        ; UNKNOWN
063932  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
063935  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
063938  0B F6                 OR     si, si                       ; UNKNOWN
06393A  75 02                 JNE    0x6393e                      ; UNKNOWN
06393C  EB 28                 JMP    0x63966                      ; UNKNOWN
06393E  8B 56 F2              MOV    dx, word ptr [bp - 0xe]      ; UNKNOWN
063941  8B CA                 MOV    cx, dx                       ; UNKNOWN
063943  26                    DB     0x26                         ; UNKNOWN (raw)
063944  8A                    DB     0x8A                         ; UNKNOWN (raw)
