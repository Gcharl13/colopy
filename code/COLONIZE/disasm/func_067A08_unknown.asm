; ============================================================================
; func_067A08_unknown
; Region   : load_image
; Bytes    : file 0x067A08..0x067A83  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067A08  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
067A0C  57                    PUSH   di                           ; UNKNOWN
067A0D  56                    PUSH   si                           ; UNKNOWN
067A0E  2B F6                 SUB    si, si                       ; UNKNOWN
067A10  39 36 EE CE           CMP    word ptr [0xceee], si        ; UNKNOWN
067A14  7C 67                 JL     0x67a7d                      ; UNKNOWN
067A16  7F 06                 JG     0x67a1e                      ; UNKNOWN
067A18  39 36 EC CE           CMP    word ptr [0xceec], si        ; UNKNOWN
067A1C  74 5F                 JE     0x67a7d                      ; UNKNOWN
067A1E  0B F6                 OR     si, si                       ; UNKNOWN
067A20  75 5B                 JNE    0x67a7d                      ; UNKNOWN
067A22  A1 E2 CE              MOV    ax, word ptr [0xcee2]        ; UNKNOWN
067A25  2B D2                 SUB    dx, dx                       ; UNKNOWN
067A27  3B 16 EE CE           CMP    dx, word ptr [0xceee]        ; UNKNOWN
067A2B  7C 0F                 JL     0x67a3c                      ; UNKNOWN
067A2D  7F 06                 JG     0x67a35                      ; UNKNOWN
067A2F  3B 06 EC CE           CMP    ax, word ptr [0xceec]        ; UNKNOWN
067A33  76 07                 JBE    0x67a3c                      ; UNKNOWN
067A35  8B 16 EE CE           MOV    dx, word ptr [0xceee]        ; UNKNOWN
067A39  A1 EC CE              MOV    ax, word ptr [0xceec]        ; UNKNOWN
067A3C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
067A3F  FF 36 E0 CE           PUSH   word ptr [0xcee0]            ; UNKNOWN
067A43  FF 36 DE CE           PUSH   word ptr [0xcede]            ; UNKNOWN
067A47  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
067A4A  16                    PUSH   ss                           ; UNKNOWN
067A4B  50                    PUSH   ax                           ; UNKNOWN
067A4C  FF 1E F8 CE           LCALL  [0xcef8]                     ; UNKNOWN
067A50  8B F8                 MOV    di, ax                       ; UNKNOWN
067A52  3B 7E FE              CMP    di, word ptr [bp - 2]        ; UNKNOWN
067A55  74 05                 JE     0x67a5c                      ; UNKNOWN
067A57  BE 04 00              MOV    si, 4                        ; UNKNOWN
067A5A  EB 11                 JMP    0x67a6d                      ; UNKNOWN
067A5C  FF 36 E0 CE           PUSH   word ptr [0xcee0]            ; UNKNOWN
067A60  FF 36 DE CE           PUSH   word ptr [0xcede]            ; UNKNOWN
067A64  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
067A67  16                    PUSH   ss                           ; UNKNOWN
067A68  50                    PUSH   ax                           ; UNKNOWN
067A69  FF 1E F4 CE           LCALL  [0xcef4]                     ; UNKNOWN
067A6D  83 3E EE CE 00        CMP    word ptr [0xceee], 0         ; UNKNOWN
067A72  7F AA                 JG     0x67a1e                      ; UNKNOWN
067A74  7C 07                 JL     0x67a7d                      ; UNKNOWN
067A76  83 3E EC CE 00        CMP    word ptr [0xceec], 0         ; UNKNOWN
067A7B  75 A1                 JNE    0x67a1e                      ; UNKNOWN
067A7D  8B C6                 MOV    ax, si                       ; UNKNOWN
067A7F  5E                    POP    si                           ; UNKNOWN
067A80  5F                    POP    di                           ; UNKNOWN
067A81  C9                    LEAVE                               ; UNKNOWN
067A82  CB                    RETF                                ; UNKNOWN
