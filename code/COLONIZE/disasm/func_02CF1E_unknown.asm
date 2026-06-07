; ============================================================================
; func_02CF1E_unknown
; Region   : load_image
; Bytes    : file 0x02CF1E..0x02D0BE  (416 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02CF1E  C8 14 03 00           ENTER  0x314, 0                     ; UNKNOWN
02CF22  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
02CF27  8D 86 EE FC           LEA    ax, [bp - 0x312]             ; UNKNOWN
02CF2B  16                    PUSH   ss                           ; UNKNOWN
02CF2C  50                    PUSH   ax                           ; UNKNOWN
02CF2D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CF2F  A3 B6 40              MOV    word ptr [0x40b6], ax        ; UNKNOWN
02CF32  50                    PUSH   ax                           ; UNKNOWN
02CF33  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02CF37  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02CF3B  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02CF3F  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02CF43  68 07 1E              PUSH   0x1e07                       ; UNKNOWN
02CF46  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
02CF4B  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
02CF4E  0B C0                 OR     ax, ax                       ; UNKNOWN
02CF50  74 2C                 JE     0x2cf7e                      ; UNKNOWN
02CF52  C7 06 04 0A 04 00     MOV    word ptr [0xa04], 4          ; UNKNOWN
02CF58  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
02CF5C  8D 06 0F 1E           LEA    ax, [0x1e0f]                 ; UNKNOWN
02CF60  2B D2                 SUB    dx, dx                       ; UNKNOWN
02CF62  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
02CF67  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02CF6A  0B C0                 OR     ax, ax                       ; UNKNOWN
02CF6C  7F 03                 JG     0x2cf71                      ; UNKNOWN
02CF6E  E9 B5 01              JMP    0x2d126                      ; UNKNOWN
02CF71  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
02CF74  FE C8                 DEC    al                           ; UNKNOWN
02CF76  2A E4                 SUB    ah, ah                       ; UNKNOWN
02CF78  A3 10 3E              MOV    word ptr [0x3e10], ax        ; UNKNOWN
02CF7B  E9 A3 01              JMP    0x2d121                      ; UNKNOWN
02CF7E  9A 1D 00 EF 21        LCALL  0x21ef, 0x1d                 ; UNKNOWN
02CF83  8D 86 EE FC           LEA    ax, [bp - 0x312]             ; UNKNOWN
02CF87  16                    PUSH   ss                           ; UNKNOWN
02CF88  50                    PUSH   ax                           ; UNKNOWN
02CF89  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
02CF8E  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02CF92  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02CF96  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02CF9A  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02CF9E  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02CFA2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02CFA6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02CFAA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02CFAE  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02CFB1  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CFB3  99                    CDQ                                 ; UNKNOWN
02CFB4  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
02CFB7  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02CFBC  6A 00                 PUSH   0                            ; UNKNOWN
02CFBE  68 40 01              PUSH   0x140                        ; UNKNOWN
02CFC1  68 C8 00              PUSH   0xc8                         ; UNKNOWN
02CFC4  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CFC6  99                    CDQ                                 ; UNKNOWN
02CFC7  2B DB                 SUB    bx, bx                       ; UNKNOWN
02CFC9  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
02CFCE  0E                    PUSH   cs                           ; UNKNOWN
02CFCF  E8 60 FE              CALL   0x2ce32                      ; UNKNOWN
02CFD2  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
02CFD7  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
02CFDC  2B C0                 SUB    ax, ax                       ; UNKNOWN
02CFDE  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
02CFE3  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02CFE6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02CFE9  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02CFEE  0B C0                 OR     ax, ax                       ; UNKNOWN
02CFF0  74 2E                 JE     0x2d020                      ; UNKNOWN
02CFF2  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02CFF7  89 86 EC FC           MOV    word ptr [bp - 0x314], ax    ; UNKNOWN
02CFFB  83 F8 20              CMP    ax, 0x20                     ; UNKNOWN
02CFFE  74 75                 JE     0x2d075                      ; UNKNOWN
02D000  7E 03                 JLE    0x2d005                      ; UNKNOWN
02D002  E9 82 00              JMP    0x2d087                      ; UNKNOWN
02D005  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
02D008  75 03                 JNE    0x2d00d                      ; UNKNOWN
02D00A  E9 19 01              JMP    0x2d126                      ; UNKNOWN
02D00D  77 11                 JA     0x2d020                      ; UNKNOWN
02D00F  2C 08                 SUB    al, 8                        ; UNKNOWN
02D011  74 28                 JE     0x2d03b                      ; UNKNOWN
02D013  FE C8                 DEC    al                           ; UNKNOWN
02D015  74 5E                 JE     0x2d075                      ; UNKNOWN
02D017  2C 04                 SUB    al, 4                        ; UNKNOWN
02D019  75 05                 JNE    0x2d020                      ; UNKNOWN
02D01B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
02D020  83 3E EA 0E 00        CMP    word ptr [0xeea], 0          ; UNKNOWN
02D025  75 03                 JNE    0x2d02a                      ; UNKNOWN
02D027  E9 E4 00              JMP    0x2d10e                      ; UNKNOWN
02D02A  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
02D02F  75 03                 JNE    0x2d034                      ; UNKNOWN
02D031  E9 DA 00              JMP    0x2d10e                      ; UNKNOWN
02D034  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02D039  EB 64                 JMP    0x2d09f                      ; UNKNOWN
02D03B  81 BE EC FC 48 01     CMP    word ptr [bp - 0x314], 0x148 ; UNKNOWN
02D041  74 3A                 JE     0x2d07d                      ; UNKNOWN
02D043  B8 03 00              MOV    ax, 3                        ; UNKNOWN
02D046  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02D049  8B 0E 10 3E           MOV    cx, word ptr [0x3e10]        ; UNKNOWN
02D04D  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
02D050  03 C1                 ADD    ax, cx                       ; UNKNOWN
02D052  B9 04 00              MOV    cx, 4                        ; UNKNOWN
02D055  99                    CDQ                                 ; UNKNOWN
02D056  F7 F9                 IDIV   cx                           ; UNKNOWN
02D058  2A F6                 SUB    dh, dh                       ; UNKNOWN
02D05A  89 16 10 3E           MOV    word ptr [0x3e10], dx        ; UNKNOWN
02D05E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
02D061  0E                    PUSH   cs                           ; UNKNOWN
02D062  E8 55 FC              CALL   0x2ccba                      ; UNKNOWN
02D065  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D068  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
02D06C  0E                    PUSH   cs                           ; UNKNOWN
02D06D  E8 4A FC              CALL   0x2ccba                      ; UNKNOWN
02D070  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D073  EB AB                 JMP    0x2d020                      ; UNKNOWN
02D075  81 BE EC FC 50 01     CMP    word ptr [bp - 0x314], 0x150 ; UNKNOWN
02D07B  75 05                 JNE    0x2d082                      ; UNKNOWN
02D07D  B8 02 00              MOV    ax, 2                        ; UNKNOWN
02D080  EB C4                 JMP    0x2d046                      ; UNKNOWN
02D082  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02D085  EB BF                 JMP    0x2d046                      ; UNKNOWN
02D087  2D 48 01              SUB    ax, 0x148                    ; UNKNOWN
02D08A  74 AF                 JE     0x2d03b                      ; UNKNOWN
02D08C  83 E8 03              SUB    ax, 3                        ; UNKNOWN
02D08F  74 AA                 JE     0x2d03b                      ; UNKNOWN
02D091  48                    DEC    ax                           ; UNKNOWN
02D092  48                    DEC    ax                           ; UNKNOWN
02D093  74 E0                 JE     0x2d075                      ; UNKNOWN
02D095  83 E8 03              SUB    ax, 3                        ; UNKNOWN
02D098  74 DB                 JE     0x2d075                      ; UNKNOWN
02D09A  EB 84                 JMP    0x2d020                      ; UNKNOWN
02D09C  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02D09F  83 3E 52 0A 01        CMP    word ptr [0xa52], 1          ; UNKNOWN
02D0A4  1B C0                 SBB    ax, ax                       ; UNKNOWN
02D0A6  83 C0 05              ADD    ax, 5                        ; UNKNOWN
02D0A9  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
02D0AC  7E 4D                 JLE    0x2d0fb                      ; UNKNOWN
02D0AE  8D 46 EE              LEA    ax, [bp - 0x12]              ; UNKNOWN
02D0B1  50                    PUSH   ax                           ; UNKNOWN
02D0B2  8D 4E F2              LEA    cx, [bp - 0xe]               ; UNKNOWN
02D0B5  51                    PUSH   cx                           ; UNKNOWN
02D0B6  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02D0B9  0E                    PUSH   cs                           ; UNKNOWN
02D0BA  E8 CA FB              CALL   0x2cc87                      ; UNKNOWN
02D0BD  83                    DB     0x83                         ; UNKNOWN (raw)
