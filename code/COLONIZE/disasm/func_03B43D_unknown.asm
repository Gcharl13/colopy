; ============================================================================
; func_03B43D_unknown
; Region   : load_image
; Bytes    : file 0x03B43D..0x03B657  (538 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B43D  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03B441  2B C0                 SUB    ax, ax                       ; UNKNOWN
03B443  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B446  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03B449  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03B44C  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03B44F  A1 DA 09              MOV    ax, word ptr [0x9da]         ; UNKNOWN
03B452  EB 70                 JMP    0x3b4c4                      ; UNKNOWN
03B454  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03B459  E9 B0 00              JMP    0x3b50c                      ; UNKNOWN
03B45C  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2         ; UNKNOWN
03B461  E9 A8 00              JMP    0x3b50c                      ; UNKNOWN
03B464  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3         ; UNKNOWN
03B469  E9 A0 00              JMP    0x3b50c                      ; UNKNOWN
03B46C  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4         ; UNKNOWN
03B471  E9 98 00              JMP    0x3b50c                      ; UNKNOWN
03B474  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5         ; UNKNOWN
03B479  E9 90 00              JMP    0x3b50c                      ; UNKNOWN
03B47C  C7 46 FE 06 00        MOV    word ptr [bp - 2], 6         ; UNKNOWN
03B481  E9 88 00              JMP    0x3b50c                      ; UNKNOWN
03B484  C7 46 FE 07 00        MOV    word ptr [bp - 2], 7         ; UNKNOWN
03B489  E9 80 00              JMP    0x3b50c                      ; UNKNOWN
03B48C  C7 46 FE 08 00        MOV    word ptr [bp - 2], 8         ; UNKNOWN
03B491  EB 79                 JMP    0x3b50c                      ; UNKNOWN
03B493  C7 46 FE 09 00        MOV    word ptr [bp - 2], 9         ; UNKNOWN
03B498  EB 72                 JMP    0x3b50c                      ; UNKNOWN
03B49A  C7 46 FE 0A 00        MOV    word ptr [bp - 2], 0xa       ; UNKNOWN
03B49F  EB 6B                 JMP    0x3b50c                      ; UNKNOWN
03B4A1  C7 46 FE 0B 00        MOV    word ptr [bp - 2], 0xb       ; UNKNOWN
03B4A6  EB 64                 JMP    0x3b50c                      ; UNKNOWN
03B4A8  C7 46 FE 0C 00        MOV    word ptr [bp - 2], 0xc       ; UNKNOWN
03B4AD  EB 5D                 JMP    0x3b50c                      ; UNKNOWN
03B4AF  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd       ; UNKNOWN
03B4B4  EB 56                 JMP    0x3b50c                      ; UNKNOWN
03B4B6  C7 46 FE 0E 00        MOV    word ptr [bp - 2], 0xe       ; UNKNOWN
03B4BB  EB 4F                 JMP    0x3b50c                      ; UNKNOWN
03B4BD  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf       ; UNKNOWN
03B4C2  EB 48                 JMP    0x3b50c                      ; UNKNOWN
03B4C4  83 E8 20              SUB    ax, 0x20                     ; UNKNOWN
03B4C7  83 F8 1B              CMP    ax, 0x1b                     ; UNKNOWN
03B4CA  77 40                 JA     0x3b50c                      ; UNKNOWN
03B4CC  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03B4CE  93                    XCHG   bx, ax                       ; UNKNOWN
03B4CF  2E FF A7 C4 24        JMP    word ptr cs:[bx + 0x24c4]    ; UNKNOWN
03B4D4  44                    INC    sp                           ; UNKNOWN
03B4D5  24 4C                 AND    al, 0x4c                     ; UNKNOWN
03B4D7  24 54                 AND    al, 0x54                     ; UNKNOWN
03B4D9  24 5C                 AND    al, 0x5c                     ; UNKNOWN
03B4DB  24 64                 AND    al, 0x64                     ; UNKNOWN
03B4DD  24 6C                 AND    al, 0x6c                     ; UNKNOWN
03B4DF  24 74                 AND    al, 0x74                     ; UNKNOWN
03B4E1  24 7C                 AND    al, 0x7c                     ; UNKNOWN
03B4E3  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4E5  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4E7  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4E9  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4EB  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4ED  24 9F                 AND    al, 0x9f                     ; UNKNOWN
03B4EF  24 A6                 AND    al, 0xa6                     ; UNKNOWN
03B4F1  24 A6                 AND    al, 0xa6                     ; UNKNOWN
03B4F3  24 A6                 AND    al, 0xa6                     ; UNKNOWN
03B4F5  24 A6                 AND    al, 0xa6                     ; UNKNOWN
03B4F7  24 AD                 AND    al, 0xad                     ; UNKNOWN
03B4F9  24 AD                 AND    al, 0xad                     ; UNKNOWN
03B4FB  24 FC                 AND    al, 0xfc                     ; UNKNOWN
03B4FD  24 AD                 AND    al, 0xad                     ; UNKNOWN
03B4FF  24 AD                 AND    al, 0xad                     ; UNKNOWN
03B501  24 FC                 AND    al, 0xfc                     ; UNKNOWN
03B503  24 8A                 AND    al, 0x8a                     ; UNKNOWN
03B505  24 83                 AND    al, 0x83                     ; UNKNOWN
03B507  24 91                 AND    al, 0x91                     ; UNKNOWN
03B509  24 98                 AND    al, 0x98                     ; UNKNOWN
03B50B  24 8D                 AND    al, 0x8d                     ; UNKNOWN
03B50D  1E                    PUSH   ds                           ; UNKNOWN
03B50E  86 09                 XCHG   byte ptr [bx + di], cl       ; UNKNOWN
03B510  8D 06 BD 23           LEA    ax, [0x23bd]                 ; UNKNOWN
03B514  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
03B517  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
03B51C  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03B51F  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
03B522  0B D0                 OR     dx, ax                       ; UNKNOWN
03B524  75 03                 JNE    0x3b529                      ; UNKNOWN
03B526  E9 2C 01              JMP    0x3b655                      ; UNKNOWN
03B529  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03B52D  74 11                 JE     0x3b540                      ; UNKNOWN
03B52F  6A 01                 PUSH   1                            ; UNKNOWN
03B531  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03B534  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03B537  50                    PUSH   ax                           ; UNKNOWN
03B538  9A 15 09 97 1B        LCALL  0x1b97, 0x915                ; UNKNOWN
03B53D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03B540  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03B543  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03B546  9A 4A 25 97 1B        LCALL  0x1b97, 0x254a               ; UNKNOWN
03B54B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B54E  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03B551  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03B554  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
03B559  2B C0                 SUB    ax, ax                       ; UNKNOWN
03B55B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03B55E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03B561  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
03B564  7F 03                 JG     0x3b569                      ; UNKNOWN
03B566  E9 EC 00              JMP    0x3b655                      ; UNKNOWN
03B569  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03B56C  E9 A9 00              JMP    0x3b618                      ; UNKNOWN
03B56F  C7 46 F8 20 00        MOV    word ptr [bp - 8], 0x20      ; UNKNOWN
03B574  E9 CD 00              JMP    0x3b644                      ; UNKNOWN
03B577  C7 46 F8 21 00        MOV    word ptr [bp - 8], 0x21      ; UNKNOWN
03B57C  E9 C5 00              JMP    0x3b644                      ; UNKNOWN
03B57F  C7 46 F8 22 00        MOV    word ptr [bp - 8], 0x22      ; UNKNOWN
03B584  E9 BD 00              JMP    0x3b644                      ; UNKNOWN
03B587  C7 46 F8 23 00        MOV    word ptr [bp - 8], 0x23      ; UNKNOWN
03B58C  E9 B5 00              JMP    0x3b644                      ; UNKNOWN
03B58F  C7 46 F8 24 00        MOV    word ptr [bp - 8], 0x24      ; UNKNOWN
03B594  E9 AD 00              JMP    0x3b644                      ; UNKNOWN
03B597  C7 46 F8 25 00        MOV    word ptr [bp - 8], 0x25      ; UNKNOWN
03B59C  E9 A5 00              JMP    0x3b644                      ; UNKNOWN
03B59F  C7 46 F8 26 00        MOV    word ptr [bp - 8], 0x26      ; UNKNOWN
03B5A4  E9 9D 00              JMP    0x3b644                      ; UNKNOWN
03B5A7  C7 46 F8 27 00        MOV    word ptr [bp - 8], 0x27      ; UNKNOWN
03B5AC  E9 95 00              JMP    0x3b644                      ; UNKNOWN
03B5AF  C7 46 F8 39 00        MOV    word ptr [bp - 8], 0x39      ; UNKNOWN
03B5B4  E9 8D 00              JMP    0x3b644                      ; UNKNOWN
03B5B7  C7 46 F8 38 00        MOV    word ptr [bp - 8], 0x38      ; UNKNOWN
03B5BC  E9 85 00              JMP    0x3b644                      ; UNKNOWN
03B5BF  C7 46 F8 3A 00        MOV    word ptr [bp - 8], 0x3a      ; UNKNOWN
03B5C4  EB 7E                 JMP    0x3b644                      ; UNKNOWN
03B5C6  C7 46 F8 3B 00        MOV    word ptr [bp - 8], 0x3b      ; UNKNOWN
03B5CB  EB 77                 JMP    0x3b644                      ; UNKNOWN
03B5CD  8D 1E C7 23           LEA    bx, [0x23c7]                 ; UNKNOWN
03B5D1  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
03B5D6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B5D9  0B C0                 OR     ax, ax                       ; UNKNOWN
03B5DB  74 67                 JE     0x3b644                      ; UNKNOWN
03B5DD  83 C0 28              ADD    ax, 0x28                     ; UNKNOWN
03B5E0  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03B5E3  EB 5F                 JMP    0x3b644                      ; UNKNOWN
03B5E5  8D 1E D8 23           LEA    bx, [0x23d8]                 ; UNKNOWN
03B5E9  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
03B5EE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B5F1  0B C0                 OR     ax, ax                       ; UNKNOWN
03B5F3  74 4F                 JE     0x3b644                      ; UNKNOWN
03B5F5  83 C0 2D              ADD    ax, 0x2d                     ; UNKNOWN
03B5F8  EB E6                 JMP    0x3b5e0                      ; UNKNOWN
03B5FA  8D 1E E5 23           LEA    bx, [0x23e5]                 ; UNKNOWN
03B5FE  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
03B603  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B606  83 F8 02              CMP    ax, 2                        ; UNKNOWN
03B609  7E 04                 JLE    0x3b60f                      ; UNKNOWN
03B60B  40                    INC    ax                           ; UNKNOWN
03B60C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B60F  0B C0                 OR     ax, ax                       ; UNKNOWN
03B611  74 31                 JE     0x3b644                      ; UNKNOWN
03B613  83 C0 31              ADD    ax, 0x31                     ; UNKNOWN
03B616  EB C8                 JMP    0x3b5e0                      ; UNKNOWN
03B618  48                    DEC    ax                           ; UNKNOWN
03B619  83 F8 0E              CMP    ax, 0xe                      ; UNKNOWN
03B61C  77 26                 JA     0x3b644                      ; UNKNOWN
03B61E  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03B620  93                    XCHG   bx, ax                       ; UNKNOWN
03B621  2E FF A7 16 26        JMP    word ptr cs:[bx + 0x2616]    ; UNKNOWN
03B626  5F                    POP    di                           ; UNKNOWN
03B627  25 67 25              AND    ax, 0x2567                   ; UNKNOWN
03B62A  6F                    OUTSW  dx, word ptr [si]            ; UNKNOWN
03B62B  25 77 25              AND    ax, 0x2577                   ; UNKNOWN
03B62E  7F 25                 JG     0x3b655                      ; UNKNOWN
03B630  87 25                 XCHG   word ptr [di], sp            ; UNKNOWN
03B632  8F                    DB     0x8F                         ; UNKNOWN (raw)
03B633  25                    DB     0x25                         ; UNKNOWN (raw)
03B634  97                    DB     0x97                         ; UNKNOWN (raw)
03B635  25                    DB     0x25                         ; UNKNOWN (raw)
03B636  9F                    DB     0x9F                         ; UNKNOWN (raw)
03B637  25                    DB     0x25                         ; UNKNOWN (raw)
03B638  A7                    DB     0xA7                         ; UNKNOWN (raw)
03B639  25                    DB     0x25                         ; UNKNOWN (raw)
03B63A  AF                    DB     0xAF                         ; UNKNOWN (raw)
03B63B  25                    DB     0x25                         ; UNKNOWN (raw)
03B63C  B6                    DB     0xB6                         ; UNKNOWN (raw)
03B63D  25                    DB     0x25                         ; UNKNOWN (raw)
03B63E  BD                    DB     0xBD                         ; UNKNOWN (raw)
03B63F  25                    DB     0x25                         ; UNKNOWN (raw)
03B640  D5                    DB     0xD5                         ; UNKNOWN (raw)
03B641  25                    DB     0x25                         ; UNKNOWN (raw)
03B642  EA                    DB     0xEA                         ; UNKNOWN (raw)
03B643  25                    DB     0x25                         ; UNKNOWN (raw)
03B644  83                    DB     0x83                         ; UNKNOWN (raw)
03B645  7E                    DB     0x7E                         ; UNKNOWN (raw)
03B646  F8                    DB     0xF8                         ; UNKNOWN (raw)
03B647  00                    DB     0x00                         ; UNKNOWN (raw)
03B648  74                    DB     0x74                         ; UNKNOWN (raw)
03B649  0B                    DB     0x0B                         ; UNKNOWN (raw)
03B64A  8B                    DB     0x8B                         ; UNKNOWN (raw)
03B64B  46                    DB     0x46                         ; UNKNOWN (raw)
03B64C  F8                    DB     0xF8                         ; UNKNOWN (raw)
03B64D  A3                    DB     0xA3                         ; UNKNOWN (raw)
03B64E  DA                    DB     0xDA                         ; UNKNOWN (raw)
03B64F  09                    DB     0x09                         ; UNKNOWN (raw)
03B650  9A                    DB     0x9A                         ; UNKNOWN (raw)
03B651  0A                    DB     0x0A                         ; UNKNOWN (raw)
03B652  00                    DB     0x00                         ; UNKNOWN (raw)
03B653  11                    DB     0x11                         ; UNKNOWN (raw)
03B654  5D                    DB     0x5D                         ; UNKNOWN (raw)
03B655  C9                    DB     0xC9                         ; UNKNOWN (raw)
03B656  CB                    DB     0xCB                         ; UNKNOWN (raw)
