; ============================================================================
; func_02B1F5_unknown
; Region   : load_image
; Bytes    : file 0x02B1F5..0x02B28D  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B1F5  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02B1F9  56                    PUSH   si                           ; UNKNOWN
02B1FA  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
02B1FF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02B202  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02B205  83 3E 48 0A 00        CMP    word ptr [0xa48], 0          ; UNKNOWN
02B20A  7C 13                 JL     0x2b21f                      ; UNKNOWN
02B20C  2B 06 46 0A           SUB    ax, word ptr [0xa46]         ; UNKNOWN
02B210  1B 16 48 0A           SBB    dx, word ptr [0xa48]         ; UNKNOWN
02B214  0B D2                 OR     dx, dx                       ; UNKNOWN
02B216  7C 3F                 JL     0x2b257                      ; UNKNOWN
02B218  7F 05                 JG     0x2b21f                      ; UNKNOWN
02B21A  3D 3A 02              CMP    ax, 0x23a                    ; UNKNOWN
02B21D  72 38                 JB     0x2b257                      ; UNKNOWN
02B21F  83 3E 44 0A 0A        CMP    word ptr [0xa44], 0xa        ; UNKNOWN
02B224  7C 15                 JL     0x2b23b                      ; UNKNOWN
02B226  C7 06 42 0A 01 00     MOV    word ptr [0xa42], 1          ; UNKNOWN
02B22C  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02B22F  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
02B232  A3 46 0A              MOV    word ptr [0xa46], ax         ; UNKNOWN
02B235  89 16 48 0A           MOV    word ptr [0xa48], dx         ; UNKNOWN
02B239  EB 1C                 JMP    0x2b257                      ; UNKNOWN
02B23B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02B23E  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
02B241  A3 46 0A              MOV    word ptr [0xa46], ax         ; UNKNOWN
02B244  89 16 48 0A           MOV    word ptr [0xa48], dx         ; UNKNOWN
02B248  FF 06 44 0A           INC    word ptr [0xa44]             ; UNKNOWN
02B24C  FF 36 44 0A           PUSH   word ptr [0xa44]             ; UNKNOWN
02B250  0E                    PUSH   cs                           ; UNKNOWN
02B251  E8 F6 FD              CALL   0x2b04a                      ; UNKNOWN
02B254  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02B257  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02B25C  0B C0                 OR     ax, ax                       ; UNKNOWN
02B25E  74 38                 JE     0x2b298                      ; UNKNOWN
02B260  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02B265  8B F0                 MOV    si, ax                       ; UNKNOWN
02B267  0E                    PUSH   cs                           ; UNKNOWN
02B268  E8 69 FD              CALL   0x2afd4                      ; UNKNOWN
02B26B  C7 06 42 0A 01 00     MOV    word ptr [0xa42], 1          ; UNKNOWN
02B271  81 FE 2D 01           CMP    si, 0x12d                    ; UNKNOWN
02B275  74 06                 JE     0x2b27d                      ; UNKNOWN
02B277  81 FE 10 01           CMP    si, 0x110                    ; UNKNOWN
02B27B  75 05                 JNE    0x2b282                      ; UNKNOWN
02B27D  C6 06 A0 09 01        MOV    byte ptr [0x9a0], 1          ; UNKNOWN
02B282  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
02B287  74 0F                 JE     0x2b298                      ; UNKNOWN
02B289  9A                    DB     0x9A                         ; UNKNOWN (raw)
02B28A  C2                    DB     0xC2                         ; UNKNOWN (raw)
02B28B  00                    DB     0x00                         ; UNKNOWN (raw)
02B28C  B2                    DB     0xB2                         ; UNKNOWN (raw)
