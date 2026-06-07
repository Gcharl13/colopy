; ============================================================================
; func_065BC0_unknown
; Region   : load_image
; Bytes    : file 0x065BC0..0x065C9B  (219 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065BC0  C8 0E 01 00           ENTER  0x10e, 0                     ; UNKNOWN
065BC4  52                    PUSH   dx                           ; UNKNOWN
065BC5  50                    PUSH   ax                           ; UNKNOWN
065BC6  57                    PUSH   di                           ; UNKNOWN
065BC7  56                    PUSH   si                           ; UNKNOWN
065BC8  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
065BCB  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
065BCE  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
065BD1  2B C0                 SUB    ax, ax                       ; UNKNOWN
065BD3  B9 04 00              MOV    cx, 4                        ; UNKNOWN
065BD6  8D 7E F6              LEA    di, [bp - 0xa]               ; UNKNOWN
065BD9  16                    PUSH   ss                           ; UNKNOWN
065BDA  07                    POP    es                           ; UNKNOWN
065BDB  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
065BDD  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
065BE2  8D 86 F2 FE           LEA    ax, [bp - 0x10e]             ; UNKNOWN
065BE6  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
065BE9  8C 56 F8              MOV    word ptr [bp - 8], ss        ; UNKNOWN
065BEC  16                    PUSH   ss                           ; UNKNOWN
065BED  50                    PUSH   ax                           ; UNKNOWN
065BEE  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
065BF1  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
065BF4  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
065BF6  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
065BFB  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
065BFE  83 BE F0 FE 00        CMP    word ptr [bp - 0x110], 0     ; UNKNOWN
065C03  74 1B                 JE     0x65c20                      ; UNKNOWN
065C05  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
065C08  56                    PUSH   si                           ; UNKNOWN
065C09  6A 00                 PUSH   0                            ; UNKNOWN
065C0B  6A 00                 PUSH   0                            ; UNKNOWN
065C0D  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112]    ; UNKNOWN
065C11  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
065C14  2B D2                 SUB    dx, dx                       ; UNKNOWN
065C16  9A 0A 00 FF 5D        LCALL  0x5dff, 0xa                  ; UNKNOWN
065C1B  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; UNKNOWN
065C20  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
065C23  50                    PUSH   ax                           ; UNKNOWN
065C24  56                    PUSH   si                           ; UNKNOWN
065C25  6A 00                 PUSH   0                            ; UNKNOWN
065C27  8B F8                 MOV    di, ax                       ; UNKNOWN
065C29  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112]    ; UNKNOWN
065C2D  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
065C30  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
065C33  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
065C38  8B 86 EE FE           MOV    ax, word ptr [bp - 0x112]    ; UNKNOWN
065C3C  8B C8                 MOV    cx, ax                       ; UNKNOWN
065C3E  D1 E0                 SHL    ax, 1                        ; UNKNOWN
065C40  03 C1                 ADD    ax, cx                       ; UNKNOWN
065C42  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
065C45  8E C7                 MOV    es, di                       ; UNKNOWN
065C47  03 F0                 ADD    si, ax                       ; UNKNOWN
065C49  26 8B 44 3E           MOV    ax, word ptr es:[si + 0x3e]  ; UNKNOWN
065C4D  D1 F8                 SAR    ax, 1                        ; UNKNOWN
065C4F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
065C52  26 8B 4C 40           MOV    cx, word ptr es:[si + 0x40]  ; UNKNOWN
065C56  D1 F9                 SAR    cx, 1                        ; UNKNOWN
065C58  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
065C5B  3B 06 FA 0E           CMP    ax, word ptr [0xefa]         ; UNKNOWN
065C5F  75 41                 JNE    0x65ca2                      ; UNKNOWN
065C61  8B C1                 MOV    ax, cx                       ; UNKNOWN
065C63  39 06 FC 0E           CMP    word ptr [0xefc], ax         ; UNKNOWN
065C67  75 39                 JNE    0x65ca2                      ; UNKNOWN
065C69  9A B6 03 1E 5C        LCALL  0x5c1e, 0x3b6                ; UNKNOWN
065C6E  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
065C71  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
065C74  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
065C77  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
065C7A  FF 36 A2 CE           PUSH   word ptr [0xcea2]            ; UNKNOWN
065C7E  FF 36 A0 CE           PUSH   word ptr [0xcea0]            ; UNKNOWN
065C82  FF 36 9E CE           PUSH   word ptr [0xce9e]            ; UNKNOWN
065C86  FF 36 9C CE           PUSH   word ptr [0xce9c]            ; UNKNOWN
065C8A  6A 10                 PUSH   0x10                         ; UNKNOWN
065C8C  2B C0                 SUB    ax, ax                       ; UNKNOWN
065C8E  99                    CDQ                                 ; UNKNOWN
065C8F  BB 10 00              MOV    bx, 0x10                     ; UNKNOWN
065C92  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
065C97  9A                    DB     0x9A                         ; UNKNOWN (raw)
065C98  CA                    DB     0xCA                         ; UNKNOWN (raw)
065C99  03                    DB     0x03                         ; UNKNOWN (raw)
065C9A  1E                    DB     0x1E                         ; UNKNOWN (raw)
