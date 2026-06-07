; ============================================================================
; func_0476D4_unknown
; Region   : load_image
; Bytes    : file 0x0476D4..0x047797  (195 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0476D4  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
0476D8  68 EA 28              PUSH   0x28ea                       ; UNKNOWN
0476DB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0476DE  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0476E3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0476E6  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0476E9  0B C0                 OR     ax, ax                       ; UNKNOWN
0476EB  74 0B                 JE     0x476f8                      ; UNKNOWN
0476ED  48                    DEC    ax                           ; UNKNOWN
0476EE  74 2C                 JE     0x4771c                      ; UNKNOWN
0476F0  48                    DEC    ax                           ; UNKNOWN
0476F1  74 2E                 JE     0x47721                      ; UNKNOWN
0476F3  48                    DEC    ax                           ; UNKNOWN
0476F4  74 30                 JE     0x47726                      ; UNKNOWN
0476F6  EB 0F                 JMP    0x47707                      ; UNKNOWN
0476F8  68 EC 28              PUSH   0x28ec                       ; UNKNOWN
0476FB  8D 46 9C              LEA    ax, [bp - 0x64]              ; UNKNOWN
0476FE  50                    PUSH   ax                           ; UNKNOWN
0476FF  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
047704  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047707  8D 46 9C              LEA    ax, [bp - 0x64]              ; UNKNOWN
04770A  50                    PUSH   ax                           ; UNKNOWN
04770B  68 09 29              PUSH   0x2909                       ; UNKNOWN
04770E  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
047713  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047716  0B C0                 OR     ax, ax                       ; UNKNOWN
047718  74 11                 JE     0x4772b                      ; UNKNOWN
04771A  EB 74                 JMP    0x47790                      ; UNKNOWN
04771C  68 F4 28              PUSH   0x28f4                       ; UNKNOWN
04771F  EB DA                 JMP    0x476fb                      ; UNKNOWN
047721  68 FB 28              PUSH   0x28fb                       ; UNKNOWN
047724  EB D5                 JMP    0x476fb                      ; UNKNOWN
047726  68 03 29              PUSH   0x2903                       ; UNKNOWN
047729  EB D0                 JMP    0x476fb                      ; UNKNOWN
04772B  C7 46 9A 00 00        MOV    word ptr [bp - 0x66], 0      ; UNKNOWN
047730  EB 42                 JMP    0x47774                      ; UNKNOWN
047732  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
047737  9A 66 01 09 45        LCALL  0x4509, 0x166                ; UNKNOWN
04773C  50                    PUSH   ax                           ; UNKNOWN
04773D  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
047740  50                    PUSH   ax                           ; UNKNOWN
047741  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
047746  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047749  80 7E B0 40           CMP    byte ptr [bp - 0x50], 0x40   ; UNKNOWN
04774D  74 41                 JE     0x47790                      ; UNKNOWN
04774F  83 7E 9A 00           CMP    word ptr [bp - 0x66], 0      ; UNKNOWN
047753  74 0D                 JE     0x47762                      ; UNKNOWN
047755  8B 46 9A              MOV    ax, word ptr [bp - 0x66]     ; UNKNOWN
047758  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
04775C  39 87 B8 C0           CMP    word ptr [bx - 0x3f48], ax   ; UNKNOWN
047760  75 0F                 JNE    0x47771                      ; UNKNOWN
047762  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
047765  50                    PUSH   ax                           ; UNKNOWN
047766  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
047769  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
04776E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
047771  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
047774  8B 46 9A              MOV    ax, word ptr [bp - 0x66]     ; UNKNOWN
047777  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
04777B  39 87 B8 C0           CMP    word ptr [bx - 0x3f48], ax   ; UNKNOWN
04777F  7D B1                 JGE    0x47732                      ; UNKNOWN
047781  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
047784  C6 47 17 00           MOV    byte ptr [bx + 0x17], 0      ; UNKNOWN
047788  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
04778C  FF 87 B8 C0           INC    word ptr [bx - 0x3f48]       ; UNKNOWN
047790  9A 0A 00 09 45        LCALL  0x4509, 0xa                  ; UNKNOWN
047795  C9                    LEAVE                               ; UNKNOWN
047796  CB                    RETF                                ; UNKNOWN
