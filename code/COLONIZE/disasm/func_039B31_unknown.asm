; ============================================================================
; func_039B31_unknown
; Region   : load_image
; Bytes    : file 0x039B31..0x039D88  (599 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039B31  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
039B35  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
039B38  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
039B3B  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
039B40  74 03                 JE     0x39b45                      ; UNKNOWN
039B42  E9 04 03              JMP    0x39e49                      ; UNKNOWN
039B45  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039B49  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039B4D  9A 75 05 67 18        LCALL  0x1867, 0x575                ; UNKNOWN
039B52  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039B55  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039B59  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039B5D  9A E8 05 67 18        LCALL  0x1867, 0x5e8                ; UNKNOWN
039B62  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039B65  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; UNKNOWN
039B69  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
039B6D  2A E4                 SUB    ah, ah                       ; UNKNOWN
039B6F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
039B72  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
039B76  2A ED                 SUB    ch, ch                       ; UNKNOWN
039B78  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
039B7B  51                    PUSH   cx                           ; UNKNOWN
039B7C  50                    PUSH   ax                           ; UNKNOWN
039B7D  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
039B82  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039B85  88 46 FC              MOV    byte ptr [bp - 4], al        ; UNKNOWN
039B88  2B C0                 SUB    ax, ax                       ; UNKNOWN
039B8A  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
039B8D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
039B90  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
039B93  9A F0 08 5F 24        LCALL  0x245f, 0x8f0                ; UNKNOWN
039B98  83 C4 02              ADD    sp, 2                        ; UNKNOWN
039B9B  0B C0                 OR     ax, ax                       ; UNKNOWN
039B9D  7C 12                 JL     0x39bb1                      ; UNKNOWN
039B9F  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
039BA2  50                    PUSH   ax                           ; UNKNOWN
039BA3  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
039BA6  50                    PUSH   ax                           ; UNKNOWN
039BA7  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
039BAA  0E                    PUSH   cs                           ; UNKNOWN
039BAB  E8 57 FF              CALL   0x39b05                      ; UNKNOWN
039BAE  83 C4 06              ADD    sp, 6                        ; UNKNOWN
039BB1  6A 01                 PUSH   1                            ; UNKNOWN
039BB3  68 17 03              PUSH   0x317                        ; UNKNOWN
039BB6  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039BBA  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039BBE  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039BC3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039BC6  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
039BCA  75 1C                 JNE    0x39be8                      ; UNKNOWN
039BCC  6A 01                 PUSH   1                            ; UNKNOWN
039BCE  68 10 03              PUSH   0x310                        ; UNKNOWN
039BD1  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039BD5  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039BD9  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039BDE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039BE1  6A 01                 PUSH   1                            ; UNKNOWN
039BE3  68 11 03              PUSH   0x311                        ; UNKNOWN
039BE6  EB 17                 JMP    0x39bff                      ; UNKNOWN
039BE8  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
039BEB  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
039BEE  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
039BF3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039BF6  0B C0                 OR     ax, ax                       ; UNKNOWN
039BF8  7C 14                 JL     0x39c0e                      ; UNKNOWN
039BFA  6A 01                 PUSH   1                            ; UNKNOWN
039BFC  68 10 03              PUSH   0x310                        ; UNKNOWN
039BFF  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C03  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C07  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039C0C  EB 32                 JMP    0x39c40                      ; UNKNOWN
039C0E  6A 01                 PUSH   1                            ; UNKNOWN
039C10  68 11 03              PUSH   0x311                        ; UNKNOWN
039C13  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C17  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C1B  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039C20  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039C23  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; UNKNOWN
039C27  80 BF 97 88 1B        CMP    byte ptr [bx - 0x7769], 0x1b ; UNKNOWN
039C2C  75 15                 JNE    0x39c43                      ; UNKNOWN
039C2E  6A 01                 PUSH   1                            ; UNKNOWN
039C30  68 10 03              PUSH   0x310                        ; UNKNOWN
039C33  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C37  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C3B  9A 46 05 67 18        LCALL  0x1867, 0x546                ; UNKNOWN
039C40  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039C43  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
039C47  75 3F                 JNE    0x39c88                      ; UNKNOWN
039C49  6A 01                 PUSH   1                            ; UNKNOWN
039C4B  68 12 03              PUSH   0x312                        ; UNKNOWN
039C4E  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C52  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C56  9A 46 05 67 18        LCALL  0x1867, 0x546                ; UNKNOWN
039C5B  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039C5E  6A 01                 PUSH   1                            ; UNKNOWN
039C60  68 13 03              PUSH   0x313                        ; UNKNOWN
039C63  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C67  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C6B  9A 46 05 67 18        LCALL  0x1867, 0x546                ; UNKNOWN
039C70  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039C73  6A 01                 PUSH   1                            ; UNKNOWN
039C75  68 14 03              PUSH   0x314                        ; UNKNOWN
039C78  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039C7C  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039C80  9A 46 05 67 18        LCALL  0x1867, 0x546                ; UNKNOWN
039C85  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039C88  80 7E FC 08           CMP    byte ptr [bp - 4], 8         ; UNKNOWN
039C8C  72 06                 JB     0x39c94                      ; UNKNOWN
039C8E  80 7E FC 10           CMP    byte ptr [bp - 4], 0x10      ; UNKNOWN
039C92  72 0C                 JB     0x39ca0                      ; UNKNOWN
039C94  80 7E FC 10           CMP    byte ptr [bp - 4], 0x10      ; UNKNOWN
039C98  72 0D                 JB     0x39ca7                      ; UNKNOWN
039C9A  80 7E FC 18           CMP    byte ptr [bp - 4], 0x18      ; UNKNOWN
039C9E  73 07                 JAE    0x39ca7                      ; UNKNOWN
039CA0  6A 01                 PUSH   1                            ; UNKNOWN
039CA2  68 13 03              PUSH   0x313                        ; UNKNOWN
039CA5  EB 05                 JMP    0x39cac                      ; UNKNOWN
039CA7  6A 01                 PUSH   1                            ; UNKNOWN
039CA9  68 12 03              PUSH   0x312                        ; UNKNOWN
039CAC  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039CB0  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039CB4  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039CB9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039CBC  80 7E FC 1B           CMP    byte ptr [bp - 4], 0x1b      ; UNKNOWN
039CC0  74 06                 JE     0x39cc8                      ; UNKNOWN
039CC2  80 7E FC 1C           CMP    byte ptr [bp - 4], 0x1c      ; UNKNOWN
039CC6  75 2A                 JNE    0x39cf2                      ; UNKNOWN
039CC8  6A 01                 PUSH   1                            ; UNKNOWN
039CCA  68 13 03              PUSH   0x313                        ; UNKNOWN
039CCD  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039CD1  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039CD5  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039CDA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039CDD  6A 01                 PUSH   1                            ; UNKNOWN
039CDF  68 12 03              PUSH   0x312                        ; UNKNOWN
039CE2  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039CE6  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039CEA  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039CEF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039CF2  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039CF7  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
039CFC  72 3E                 JB     0x39d3c                      ; UNKNOWN
039CFE  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
039D03  77 37                 JA     0x39d3c                      ; UNKNOWN
039D05  80 7E FC 1A           CMP    byte ptr [bp - 4], 0x1a      ; UNKNOWN
039D09  74 15                 JE     0x39d20                      ; UNKNOWN
039D0B  6A 01                 PUSH   1                            ; UNKNOWN
039D0D  68 23 03              PUSH   0x323                        ; UNKNOWN
039D10  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039D14  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039D18  9A 46 05 67 18        LCALL  0x1867, 0x546                ; UNKNOWN
039D1D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039D20  6A 01                 PUSH   1                            ; UNKNOWN
039D22  68 21 03              PUSH   0x321                        ; UNKNOWN
039D25  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039D29  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039D2D  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039D32  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039D35  6A 01                 PUSH   1                            ; UNKNOWN
039D37  68 02 03              PUSH   0x302                        ; UNKNOWN
039D3A  EB 2F                 JMP    0x39d6b                      ; UNKNOWN
039D3C  6A 01                 PUSH   1                            ; UNKNOWN
039D3E  68 23 03              PUSH   0x323                        ; UNKNOWN
039D41  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039D45  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039D49  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039D4E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039D51  6A 01                 PUSH   1                            ; UNKNOWN
039D53  68 20 03              PUSH   0x320                        ; UNKNOWN
039D56  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039D5A  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039D5E  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039D63  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039D66  6A 01                 PUSH   1                            ; UNKNOWN
039D68  68 03 03              PUSH   0x303                        ; UNKNOWN
039D6B  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
039D6F  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
039D73  9A B9 05 67 18        LCALL  0x1867, 0x5b9                ; UNKNOWN
039D78  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039D7B  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039D80  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
039D84  2A FF                 SUB    bh, bh                       ; UNKNOWN
039D86  8B C3                 MOV    ax, bx                       ; UNKNOWN
