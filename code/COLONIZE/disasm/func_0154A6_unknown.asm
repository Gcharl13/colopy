; ============================================================================
; func_0154A6_unknown
; Region   : load_image
; Bytes    : file 0x0154A6..0x015543  (157 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0154A6  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0154AA  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
0154AE  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
0154B2  98                    CWDE                                ; UNKNOWN
0154B3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0154B6  8A 8F 82 88           MOV    cl, byte ptr [bx - 0x777e]   ; UNKNOWN
0154BA  2A ED                 SUB    ch, ch                       ; UNKNOWN
0154BC  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
0154BF  3D 1C 00              CMP    ax, 0x1c                     ; UNKNOWN
0154C2  75 05                 JNE    0x154c9                      ; UNKNOWN
0154C4  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13      ; UNKNOWN
0154C9  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
0154CC  C1 E3 03              SHL    bx, 3                        ; UNKNOWN
0154CF  8B 87 33 38           MOV    ax, word ptr [bx + 0x3833]   ; UNKNOWN
0154D3  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0154D6  0B C9                 OR     cx, cx                       ; UNKNOWN
0154D8  74 1A                 JE     0x154f4                      ; UNKNOWN
0154DA  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0154DE  75 14                 JNE    0x154f4                      ; UNKNOWN
0154E0  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0154E3  9A 08 00 5F 24        LCALL  0x245f, 8                    ; UNKNOWN
0154E8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0154EB  0B C0                 OR     ax, ax                       ; UNKNOWN
0154ED  75 05                 JNE    0x154f4                      ; UNKNOWN
0154EF  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
0154F4  83 7E FA 01           CMP    word ptr [bp - 6], 1         ; UNKNOWN
0154F8  74 06                 JE     0x15500                      ; UNKNOWN
0154FA  83 7E FA 04           CMP    word ptr [bp - 6], 4         ; UNKNOWN
0154FE  75 0C                 JNE    0x1550c                      ; UNKNOWN
015500  83 7E FE 15           CMP    word ptr [bp - 2], 0x15      ; UNKNOWN
015504  75 06                 JNE    0x1550c                      ; UNKNOWN
015506  A1 7C 33              MOV    ax, word ptr [0x337c]        ; UNKNOWN
015509  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01550C  83 7E FA 05           CMP    word ptr [bp - 6], 5         ; UNKNOWN
015510  75 0C                 JNE    0x1551e                      ; UNKNOWN
015512  83 7E FE 16           CMP    word ptr [bp - 2], 0x16      ; UNKNOWN
015516  75 06                 JNE    0x1551e                      ; UNKNOWN
015518  A1 02 33              MOV    ax, word ptr [0x3302]        ; UNKNOWN
01551B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01551E  83 7E FA 03           CMP    word ptr [bp - 6], 3         ; UNKNOWN
015522  75 0C                 JNE    0x15530                      ; UNKNOWN
015524  83 7E FE 18           CMP    word ptr [bp - 2], 0x18      ; UNKNOWN
015528  75 06                 JNE    0x15530                      ; UNKNOWN
01552A  A1 02 33              MOV    ax, word ptr [0x3302]        ; UNKNOWN
01552D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
015530  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
015534  7C 0B                 JL     0x15541                      ; UNKNOWN
015536  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
015539  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01553C  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
015541  C9                    LEAVE                               ; UNKNOWN
015542  CB                    RETF                                ; UNKNOWN
