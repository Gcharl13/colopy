; ============================================================================
; func_03CAD9_unknown
; Region   : load_image
; Bytes    : file 0x03CAD9..0x03CBA5  (204 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CAD9  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03CADD  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03CAE0  A3 3C 3E              MOV    word ptr [0x3e3c], ax        ; UNKNOWN
03CAE3  50                    PUSH   ax                           ; UNKNOWN
03CAE4  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
03CAE9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03CAEC  C7 06 0A 3E FF FF     MOV    word ptr [0x3e0a], 0xffff    ; UNKNOWN
03CAF2  2B C0                 SUB    ax, ax                       ; UNKNOWN
03CAF4  A3 D0 79              MOV    word ptr [0x79d0], ax        ; UNKNOWN
03CAF7  50                    PUSH   ax                           ; UNKNOWN
03CAF8  0E                    PUSH   cs                           ; UNKNOWN
03CAF9  E8 4F D3              CALL   0x39e4b                      ; UNKNOWN
03CAFC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03CAFF  9A 29 00 9A 5B        LCALL  0x5b9a, 0x29                 ; UNKNOWN
03CB04  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03CB09  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03CB0E  75 51                 JNE    0x3cb61                      ; UNKNOWN
03CB10  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03CB13  9A EA 13 B7 36        LCALL  0x36b7, 0x13ea               ; UNKNOWN
03CB18  0B C0                 OR     ax, ax                       ; UNKNOWN
03CB1A  75 45                 JNE    0x3cb61                      ; UNKNOWN
03CB1C  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
03CB21  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03CB24  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
03CB27  6A 00                 PUSH   0                            ; UNKNOWN
03CB29  0E                    PUSH   cs                           ; UNKNOWN
03CB2A  E8 1E D3              CALL   0x39e4b                      ; UNKNOWN
03CB2D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03CB30  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03CB33  0B C0                 OR     ax, ax                       ; UNKNOWN
03CB35  75 2A                 JNE    0x3cb61                      ; UNKNOWN
03CB37  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
03CB3C  8B 4E FA              MOV    cx, word ptr [bp - 6]        ; UNKNOWN
03CB3F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
03CB42  83 C1 1E              ADD    cx, 0x1e                     ; UNKNOWN
03CB45  83 D3 00              ADC    bx, 0                        ; UNKNOWN
03CB48  3B D3                 CMP    dx, bx                       ; UNKNOWN
03CB4A  7F 06                 JG     0x3cb52                      ; UNKNOWN
03CB4C  7C E9                 JL     0x3cb37                      ; UNKNOWN
03CB4E  3B C1                 CMP    ax, cx                       ; UNKNOWN
03CB50  72 E5                 JB     0x3cb37                      ; UNKNOWN
03CB52  9A 29 00 9A 5B        LCALL  0x5b9a, 0x29                 ; UNKNOWN
03CB57  F6 06 FA 3D 80        TEST   byte ptr [0x3dfa], 0x80      ; UNKNOWN
03CB5C  74 03                 JE     0x3cb61                      ; UNKNOWN
03CB5E  E8 23 C5              CALL   0x39084                      ; UNKNOWN
03CB61  83 3E 3C 3E 00        CMP    word ptr [0x3e3c], 0         ; UNKNOWN
03CB66  74 23                 JE     0x3cb8b                      ; UNKNOWN
03CB68  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03CB6C  75 0C                 JNE    0x3cb7a                      ; UNKNOWN
03CB6E  6A 00                 PUSH   0                            ; UNKNOWN
03CB70  6A 01                 PUSH   1                            ; UNKNOWN
03CB72  9A 44 04 10 0C        LCALL  0xc10, 0x444                 ; UNKNOWN
03CB77  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CB7A  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03CB7F  75 06                 JNE    0x3cb87                      ; UNKNOWN
03CB81  0E                    PUSH   cs                           ; UNKNOWN
03CB82  E8 DB FE              CALL   0x3ca60                      ; UNKNOWN
03CB85  EB 04                 JMP    0x3cb8b                      ; UNKNOWN
03CB87  0E                    PUSH   cs                           ; UNKNOWN
03CB88  E8 F5 FB              CALL   0x3c780                      ; UNKNOWN
03CB8B  83 3E 3A 3E 00        CMP    word ptr [0x3e3a], 0         ; UNKNOWN
03CB90  74 11                 JE     0x3cba3                      ; UNKNOWN
03CB92  83 3E 3C 3E 00        CMP    word ptr [0x3e3c], 0         ; UNKNOWN
03CB97  74 0A                 JE     0x3cba3                      ; UNKNOWN
03CB99  83 3E 9E 09 00        CMP    word ptr [0x99e], 0          ; UNKNOWN
03CB9E  75 03                 JNE    0x3cba3                      ; UNKNOWN
03CBA0  E9 61 FF              JMP    0x3cb04                      ; UNKNOWN
03CBA3  C9                    LEAVE                               ; UNKNOWN
03CBA4  CB                    RETF                                ; UNKNOWN
