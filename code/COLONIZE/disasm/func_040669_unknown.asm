; ============================================================================
; func_040669_unknown
; Region   : load_image
; Bytes    : file 0x040669..0x040729  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040669  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
04066D  57                    PUSH   di                           ; UNKNOWN
04066E  56                    PUSH   si                           ; UNKNOWN
04066F  C7 06 82 C0 FF FF     MOV    word ptr [0xc082], 0xffff    ; UNKNOWN
040675  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
040678  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04067B  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
040680  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040683  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
040686  2B F6                 SUB    si, si                       ; UNKNOWN
040688  39 36 82 C0           CMP    word ptr [0xc082], si        ; UNKNOWN
04068C  7C 03                 JL     0x40691                      ; UNKNOWN
04068E  E9 8A 00              JMP    0x4071b                      ; UNKNOWN
040691  83 FE 08              CMP    si, 8                        ; UNKNOWN
040694  7C 03                 JL     0x40699                      ; UNKNOWN
040696  E9 82 00              JMP    0x4071b                      ; UNKNOWN
040699  8A 84 2F 09           MOV    al, byte ptr [si + 0x92f]    ; UNKNOWN
04069D  98                    CWDE                                ; UNKNOWN
04069E  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
0406A1  8B F8                 MOV    di, ax                       ; UNKNOWN
0406A3  50                    PUSH   ax                           ; UNKNOWN
0406A4  8A 84 26 09           MOV    al, byte ptr [si + 0x926]    ; UNKNOWN
0406A8  98                    CWDE                                ; UNKNOWN
0406A9  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
0406AC  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0406AF  50                    PUSH   ax                           ; UNKNOWN
0406B0  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
0406B5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0406B8  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0406BB  0B C0                 OR     ax, ax                       ; UNKNOWN
0406BD  7C 1F                 JL     0x406de                      ; UNKNOWN
0406BF  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0406C2  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
0406C5  74 17                 JE     0x406de                      ; UNKNOWN
0406C7  57                    PUSH   di                           ; UNKNOWN
0406C8  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0406CB  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
0406D0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0406D3  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
0406D6  75 06                 JNE    0x406de                      ; UNKNOWN
0406D8  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0406DB  A3 82 C0              MOV    word ptr [0xc082], ax        ; UNKNOWN
0406DE  57                    PUSH   di                           ; UNKNOWN
0406DF  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0406E2  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
0406E7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0406EA  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0406ED  0B C0                 OR     ax, ax                       ; UNKNOWN
0406EF  7C 1F                 JL     0x40710                      ; UNKNOWN
0406F1  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0406F4  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
0406F7  74 17                 JE     0x40710                      ; UNKNOWN
0406F9  57                    PUSH   di                           ; UNKNOWN
0406FA  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0406FD  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
040702  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040705  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
040708  75 06                 JNE    0x40710                      ; UNKNOWN
04070A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04070D  A3 82 C0              MOV    word ptr [0xc082], ax        ; UNKNOWN
040710  46                    INC    si                           ; UNKNOWN
040711  83 3E 82 C0 00        CMP    word ptr [0xc082], 0         ; UNKNOWN
040716  7D 03                 JGE    0x4071b                      ; UNKNOWN
040718  E9 76 FF              JMP    0x40691                      ; UNKNOWN
04071B  83 3E 82 C0 00        CMP    word ptr [0xc082], 0         ; UNKNOWN
040720  7C 07                 JL     0x40729                      ; UNKNOWN
040722  B8 01 00              MOV    ax, 1                        ; UNKNOWN
040725  5E                    POP    si                           ; UNKNOWN
040726  5F                    POP    di                           ; UNKNOWN
040727  C9                    LEAVE                               ; UNKNOWN
040728  CB                    RETF                                ; UNKNOWN
