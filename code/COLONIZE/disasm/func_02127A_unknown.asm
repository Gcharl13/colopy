; ============================================================================
; func_02127A_unknown
; Region   : load_image
; Bytes    : file 0x02127A..0x021322  (168 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02127A  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02127E  50                    PUSH   ax                           ; UNKNOWN
02127F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
021284  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
021289  83 3E 3C 0B 00        CMP    word ptr [0xb3c], 0          ; UNKNOWN
02128E  75 5F                 JNE    0x212ef                      ; UNKNOWN
021290  1E                    PUSH   ds                           ; UNKNOWN
021291  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
021294  1E                    PUSH   ds                           ; UNKNOWN
021295  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
021298  1E                    PUSH   ds                           ; UNKNOWN
021299  68 04 0B              PUSH   0xb04                        ; UNKNOWN
02129C  9A 57 00 3A 5B        LCALL  0x5b3a, 0x57                 ; UNKNOWN
0212A1  1E                    PUSH   ds                           ; UNKNOWN
0212A2  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
0212A5  8D 1E A0 18           LEA    bx, [0x18a0]                 ; UNKNOWN
0212A9  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
0212AE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0212B1  C7 06 88 82 78 00     MOV    word ptr [0x8288], 0x78      ; UNKNOWN
0212B7  C7 06 8A 82 4B 00     MOV    word ptr [0x828a], 0x4b      ; UNKNOWN
0212BD  C7 06 F0 82 28 23     MOV    word ptr [0x82f0], 0x2328    ; UNKNOWN
0212C3  C7 06 F2 82 00 00     MOV    word ptr [0x82f2], 0         ; UNKNOWN
0212C9  0B C0                 OR     ax, ax                       ; UNKNOWN
0212CB  74 22                 JE     0x212ef                      ; UNKNOWN
0212CD  50                    PUSH   ax                           ; UNKNOWN
0212CE  6A 01                 PUSH   1                            ; UNKNOWN
0212D0  6A 04                 PUSH   4                            ; UNKNOWN
0212D2  68 88 82              PUSH   0x8288                       ; UNKNOWN
0212D5  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
0212DA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0212DD  0B C0                 OR     ax, ax                       ; UNKNOWN
0212DF  74 0E                 JE     0x212ef                      ; UNKNOWN
0212E1  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
0212E4  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
0212E8  A3 F0 82              MOV    word ptr [0x82f0], ax        ; UNKNOWN
0212EB  89 16 F2 82           MOV    word ptr [0x82f2], dx        ; UNKNOWN
0212EF  0E                    PUSH   cs                           ; UNKNOWN
0212F0  E8 7F FC              CALL   0x20f72                      ; UNKNOWN
0212F3  0B C0                 OR     ax, ax                       ; UNKNOWN
0212F5  75 18                 JNE    0x2130f                      ; UNKNOWN
0212F7  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
0212FA  0E                    PUSH   cs                           ; UNKNOWN
0212FB  E8 AB FB              CALL   0x20ea9                      ; UNKNOWN
0212FE  0B C0                 OR     ax, ax                       ; UNKNOWN
021300  74 08                 JE     0x2130a                      ; UNKNOWN
021302  C7 06 08 0B 13 00     MOV    word ptr [0xb08], 0x13       ; UNKNOWN
021308  EB 05                 JMP    0x2130f                      ; UNKNOWN
02130A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02130F  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
021313  74 08                 JE     0x2131d                      ; UNKNOWN
021315  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
021318  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
02131D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
021320  C9                    LEAVE                               ; UNKNOWN
021321  CB                    RETF                                ; UNKNOWN
