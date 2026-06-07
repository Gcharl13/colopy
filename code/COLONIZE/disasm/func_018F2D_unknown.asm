; ============================================================================
; func_018F2D_unknown
; Region   : load_image
; Bytes    : file 0x018F2D..0x018FB5  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018F2D  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
018F31  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
018F36  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
018F3B  74 0D                 JE     0x18f4a                      ; UNKNOWN
018F3D  83 3E C6 32 04        CMP    word ptr [0x32c6], 4         ; UNKNOWN
018F42  75 06                 JNE    0x18f4a                      ; UNKNOWN
018F44  A1 08 09              MOV    ax, word ptr [0x908]         ; UNKNOWN
018F47  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
018F4A  6A 09                 PUSH   9                            ; UNKNOWN
018F4C  6A 1E                 PUSH   0x1e                         ; UNKNOWN
018F4E  68 8A 00              PUSH   0x8a                         ; UNKNOWN
018F51  68 D8 00              PUSH   0xd8                         ; UNKNOWN
018F54  0E                    PUSH   cs                           ; UNKNOWN
018F55  E8 4D E8              CALL   0x177a5                      ; UNKNOWN
018F58  83 C4 08              ADD    sp, 8                        ; UNKNOWN
018F5B  6A 09                 PUSH   9                            ; UNKNOWN
018F5D  6A 1E                 PUSH   0x1e                         ; UNKNOWN
018F5F  68 8A 00              PUSH   0x8a                         ; UNKNOWN
018F62  68 0E 01              PUSH   0x10e                        ; UNKNOWN
018F65  0E                    PUSH   cs                           ; UNKNOWN
018F66  E8 3C E8              CALL   0x177a5                      ; UNKNOWN
018F69  83 C4 08              ADD    sp, 8                        ; UNKNOWN
018F6C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
018F70  80 BF 94 00 00        CMP    byte ptr [bx + 0x94], 0      ; UNKNOWN
018F75  7C 1D                 JL     0x18f94                      ; UNKNOWN
018F77  83 7E FE 01           CMP    word ptr [bp - 2], 1         ; UNKNOWN
018F7B  1B C0                 SBB    ax, ax                       ; UNKNOWN
018F7D  F7 D8                 NEG    ax                           ; UNKNOWN
018F7F  83 E0 01              AND    ax, 1                        ; UNKNOWN
018F82  50                    PUSH   ax                           ; UNKNOWN
018F83  68 8A 00              PUSH   0x8a                         ; UNKNOWN
018F86  68 D8 00              PUSH   0xd8                         ; UNKNOWN
018F89  FF 36 9D 3B           PUSH   word ptr [0x3b9d]            ; UNKNOWN
018F8D  0E                    PUSH   cs                           ; UNKNOWN
018F8E  E8 4F FE              CALL   0x18de0                      ; UNKNOWN
018F91  83 C4 08              ADD    sp, 8                        ; UNKNOWN
018F94  83 7E FE 01           CMP    word ptr [bp - 2], 1         ; UNKNOWN
018F98  75 05                 JNE    0x18f9f                      ; UNKNOWN
018F9A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
018F9D  EB 02                 JMP    0x18fa1                      ; UNKNOWN
018F9F  2B C0                 SUB    ax, ax                       ; UNKNOWN
018FA1  83 E0 01              AND    ax, 1                        ; UNKNOWN
018FA4  50                    PUSH   ax                           ; UNKNOWN
018FA5  68 8A 00              PUSH   0x8a                         ; UNKNOWN
018FA8  68 0E 01              PUSH   0x10e                        ; UNKNOWN
018FAB  FF 36 9F 3B           PUSH   word ptr [0x3b9f]            ; UNKNOWN
018FAF  0E                    PUSH   cs                           ; UNKNOWN
018FB0  E8 2D FE              CALL   0x18de0                      ; UNKNOWN
018FB3  C9                    LEAVE                               ; UNKNOWN
018FB4  CB                    RETF                                ; UNKNOWN
