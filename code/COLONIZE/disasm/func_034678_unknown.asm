; ============================================================================
; func_034678_unknown
; Region   : load_image
; Bytes    : file 0x034678..0x0346FC  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034678  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
03467C  6A 20                 PUSH   0x20                         ; UNKNOWN
03467E  6A 25                 PUSH   0x25                         ; UNKNOWN
034680  6A 59                 PUSH   0x59                         ; UNKNOWN
034682  68 19 01              PUSH   0x119                        ; UNKNOWN
034685  0E                    PUSH   cs                           ; UNKNOWN
034686  E8 C7 EF              CALL   0x33650                      ; UNKNOWN
034689  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03468C  C7 46 FE 19 01        MOV    word ptr [bp - 2], 0x119     ; UNKNOWN
034691  C7 46 FC 59 00        MOV    word ptr [bp - 4], 0x59      ; UNKNOWN
034696  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03469B  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0346A0  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0346A3  39 06 AE 79           CMP    word ptr [0x79ae], ax        ; UNKNOWN
0346A7  75 13                 JNE    0x346bc                      ; UNKNOWN
0346A9  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
0346AE  74 0C                 JE     0x346bc                      ; UNKNOWN
0346B0  83 3E BA 79 05        CMP    word ptr [0x79ba], 5         ; UNKNOWN
0346B5  75 05                 JNE    0x346bc                      ; UNKNOWN
0346B7  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
0346BC  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
0346BF  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0346C2  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0346C5  8B D8                 MOV    bx, ax                       ; UNKNOWN
0346C7  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0346C9  FF B7 D3 3B           PUSH   word ptr [bx + 0x3bd3]       ; UNKNOWN
0346CD  E8 C8 FD              CALL   0x34498                      ; UNKNOWN
0346D0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0346D3  40                    INC    ax                           ; UNKNOWN
0346D4  40                    INC    ax                           ; UNKNOWN
0346D5  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
0346D8  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
0346DB  83 7E FA 03           CMP    word ptr [bp - 6], 3         ; UNKNOWN
0346DF  7C BA                 JL     0x3469b                      ; UNKNOWN
0346E1  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
0346E5  74 13                 JE     0x346fa                      ; UNKNOWN
0346E7  6A 59                 PUSH   0x59                         ; UNKNOWN
0346E9  6A 25                 PUSH   0x25                         ; UNKNOWN
0346EB  6A 20                 PUSH   0x20                         ; UNKNOWN
0346ED  B8 19 01              MOV    ax, 0x119                    ; UNKNOWN
0346F0  BA 59 00              MOV    dx, 0x59                     ; UNKNOWN
0346F3  8B D8                 MOV    bx, ax                       ; UNKNOWN
0346F5  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0346FA  C9                    LEAVE                               ; UNKNOWN
0346FB  C3                    RET                                 ; UNKNOWN
