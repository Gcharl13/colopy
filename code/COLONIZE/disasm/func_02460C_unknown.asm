; ============================================================================
; func_02460C_unknown
; Region   : load_image
; Bytes    : file 0x02460C..0x024752  (326 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02460C  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
024610  57                    PUSH   di                           ; UNKNOWN
024611  56                    PUSH   si                           ; UNKNOWN
024612  2B C0                 SUB    ax, ax                       ; UNKNOWN
024614  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
024617  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
02461A  6A 01                 PUSH   1                            ; UNKNOWN
02461C  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
02461F  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
024622  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
024625  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
024628  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
02462D  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
024630  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
024633  3B 46 0C              CMP    ax, word ptr [bp + 0xc]      ; UNKNOWN
024636  7E 03                 JLE    0x2463b                      ; UNKNOWN
024638  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
02463B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02463E  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
024641  3B 46 0E              CMP    ax, word ptr [bp + 0xe]      ; UNKNOWN
024644  7E 03                 JLE    0x24649                      ; UNKNOWN
024646  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
024649  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02464C  A1 7C 82              MOV    ax, word ptr [0x827c]        ; UNKNOWN
02464F  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
024652  BE 01 00              MOV    si, 1                        ; UNKNOWN
024655  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
024658  39 46 10              CMP    word ptr [bp + 0x10], ax     ; UNKNOWN
02465B  74 06                 JE     0x24663                      ; UNKNOWN
02465D  D1 66 EA              SHL    word ptr [bp - 0x16], 1      ; UNKNOWN
024660  BE 02 00              MOV    si, 2                        ; UNKNOWN
024663  A1 7E 82              MOV    ax, word ptr [0x827e]        ; UNKNOWN
024666  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
024669  BF 01 00              MOV    di, 1                        ; UNKNOWN
02466C  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
02466F  39 46 12              CMP    word ptr [bp + 0x12], ax     ; UNKNOWN
024672  74 06                 JE     0x2467a                      ; UNKNOWN
024674  D1 66 E8              SHL    word ptr [bp - 0x18], 1      ; UNKNOWN
024677  BF 02 00              MOV    di, 2                        ; UNKNOWN
02467A  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
02467E  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
024681  D3 F8                 SAR    ax, cl                       ; UNKNOWN
024683  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
024686  57                    PUSH   di                           ; UNKNOWN
024687  56                    PUSH   si                           ; UNKNOWN
024688  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02468B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02468E  9A BD 00 BE 17        LCALL  0x17be, 0xbd                 ; UNKNOWN
024693  83 C4 08              ADD    sp, 8                        ; UNKNOWN
024696  57                    PUSH   di                           ; UNKNOWN
024697  56                    PUSH   si                           ; UNKNOWN
024698  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02469B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02469E  9A B5 04 E8 39        LCALL  0x39e8, 0x4b5                ; UNKNOWN
0246A3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0246A6  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0246AA  7C 59                 JL     0x24705                      ; UNKNOWN
0246AC  6B 5E 0A 1C           IMUL   bx, word ptr [bp + 0xa], 0x1c ; UNKNOWN
0246B0  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0246B4  2A E4                 SUB    ah, ah                       ; UNKNOWN
0246B6  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
0246B9  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
0246BD  2A ED                 SUB    ch, ch                       ; UNKNOWN
0246BF  89 4E E0              MOV    word ptr [bp - 0x20], cx     ; UNKNOWN
0246C2  6A 01                 PUSH   1                            ; UNKNOWN
0246C4  6A 01                 PUSH   1                            ; UNKNOWN
0246C6  51                    PUSH   cx                           ; UNKNOWN
0246C7  50                    PUSH   ax                           ; UNKNOWN
0246C8  9A BD 00 BE 17        LCALL  0x17be, 0xbd                 ; UNKNOWN
0246CD  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0246D0  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
0246D3  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
0246D7  03 06 84 82           ADD    ax, word ptr [0x8284]        ; UNKNOWN
0246DB  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
0246DF  83 C0 08              ADD    ax, 8                        ; UNKNOWN
0246E2  50                    PUSH   ax                           ; UNKNOWN
0246E3  FF 36 7C 82           PUSH   word ptr [0x827c]            ; UNKNOWN
0246E7  FF 36 36 0B           PUSH   word ptr [0xb36]             ; UNKNOWN
0246EB  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
0246EE  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
0246F2  03 06 82 82           ADD    ax, word ptr [0x8282]        ; UNKNOWN
0246F6  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
0246FA  8B D8                 MOV    bx, ax                       ; UNKNOWN
0246FC  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0246FF  2B D2                 SUB    dx, dx                       ; UNKNOWN
024701  0E                    PUSH   cs                           ; UNKNOWN
024702  E8 18 F2              CALL   0x2391d                      ; UNKNOWN
024705  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
024708  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
02470C  03 06 84 82           ADD    ax, word ptr [0x8284]        ; UNKNOWN
024710  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
024714  83 C0 08              ADD    ax, 8                        ; UNKNOWN
024717  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
02471A  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02471E  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
024722  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
024726  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02472A  FF 36 D8 3E           PUSH   word ptr [0x3ed8]            ; UNKNOWN
02472E  FF 36 D6 3E           PUSH   word ptr [0x3ed6]            ; UNKNOWN
024732  FF 36 D4 3E           PUSH   word ptr [0x3ed4]            ; UNKNOWN
024736  FF 36 D2 3E           PUSH   word ptr [0x3ed2]            ; UNKNOWN
02473A  6A 00                 PUSH   0                            ; UNKNOWN
02473C  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
02473F  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
024742  8B D0                 MOV    dx, ax                       ; UNKNOWN
024744  A1 82 82              MOV    ax, word ptr [0x8282]        ; UNKNOWN
024747  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
02474B  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
02474E  8B CA                 MOV    cx, dx                       ; UNKNOWN
024750  F7                    DB     0xF7                         ; UNKNOWN (raw)
024751  2E                    DB     0x2E                         ; UNKNOWN (raw)
