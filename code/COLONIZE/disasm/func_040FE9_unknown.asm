; ============================================================================
; func_040FE9_unknown
; Region   : load_image
; Bytes    : file 0x040FE9..0x041035  (76 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040FE9  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
040FED  57                    PUSH   di                           ; UNKNOWN
040FEE  56                    PUSH   si                           ; UNKNOWN
040FEF  39 06 14 3E           CMP    word ptr [0x3e14], ax        ; UNKNOWN
040FF3  7E 08                 JLE    0x40ffd                      ; UNKNOWN
040FF5  0B C0                 OR     ax, ax                       ; UNKNOWN
040FF7  7C 04                 JL     0x40ffd                      ; UNKNOWN
040FF9  8B D0                 MOV    dx, ax                       ; UNKNOWN
040FFB  EB 0F                 JMP    0x4100c                      ; UNKNOWN
040FFD  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
041000  8B 16 14 3E           MOV    dx, word ptr [0x3e14]        ; UNKNOWN
041004  4A                    DEC    dx                           ; UNKNOWN
041005  83 3E 14 3E 00        CMP    word ptr [0x3e14], 0         ; UNKNOWN
04100A  74 2C                 JE     0x41038                      ; UNKNOWN
04100C  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04100F  8B F0                 MOV    si, ax                       ; UNKNOWN
041011  46                    INC    si                           ; UNKNOWN
041012  39 36 14 3E           CMP    word ptr [0x3e14], si        ; UNKNOWN
041016  7F 02                 JG     0x4101a                      ; UNKNOWN
041018  2B F6                 SUB    si, si                       ; UNKNOWN
04101A  8B C6                 MOV    ax, si                       ; UNKNOWN
04101C  0E                    PUSH   cs                           ; UNKNOWN
04101D  E8 3A FF              CALL   0x40f5a                      ; UNKNOWN
041020  8B F8                 MOV    di, ax                       ; UNKNOWN
041022  0B FF                 OR     di, di                       ; UNKNOWN
041024  75 05                 JNE    0x4102b                      ; UNKNOWN
041026  39 76 FE              CMP    word ptr [bp - 2], si        ; UNKNOWN
041029  75 E6                 JNE    0x41011                      ; UNKNOWN
04102B  0B FF                 OR     di, di                       ; UNKNOWN
04102D  74 06                 JE     0x41035                      ; UNKNOWN
04102F  8B C6                 MOV    ax, si                       ; UNKNOWN
041031  5E                    POP    si                           ; UNKNOWN
041032  5F                    POP    di                           ; UNKNOWN
041033  C9                    LEAVE                               ; UNKNOWN
041034  CB                    RETF                                ; UNKNOWN
