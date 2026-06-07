; ============================================================================
; func_028C6A_unknown
; Region   : load_image
; Bytes    : file 0x028C6A..0x028D85  (283 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028C6A  C8 60 00 00           ENTER  0x60, 0                      ; UNKNOWN
028C6E  56                    PUSH   si                           ; UNKNOWN
028C6F  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
028C73  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
028C77  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
028C7B  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
028C7F  B0 22                 MOV    al, 0x22                     ; UNKNOWN
028C81  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
028C86  FF 36 D9 3B           PUSH   word ptr [0x3bd9]            ; UNKNOWN
028C8A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
028C8F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028C92  52                    PUSH   dx                           ; UNKNOWN
028C93  50                    PUSH   ax                           ; UNKNOWN
028C94  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028C97  16                    PUSH   ss                           ; UNKNOWN
028C98  50                    PUSH   ax                           ; UNKNOWN
028C99  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
028C9E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
028CA1  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028CA4  50                    PUSH   ax                           ; UNKNOWN
028CA5  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
028CAA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028CAD  A1 8A 40              MOV    ax, word ptr [0x408a]        ; UNKNOWN
028CB0  83 E8 00              SUB    ax, 0                        ; UNKNOWN
028CB3  B9 4A 00              MOV    cx, 0x4a                     ; UNKNOWN
028CB6  99                    CDQ                                 ; UNKNOWN
028CB7  F7 F9                 IDIV   cx                           ; UNKNOWN
028CB9  40                    INC    ax                           ; UNKNOWN
028CBA  50                    PUSH   ax                           ; UNKNOWN
028CBB  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028CBE  16                    PUSH   ss                           ; UNKNOWN
028CBF  50                    PUSH   ax                           ; UNKNOWN
028CC0  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
028CC5  83 C4 06              ADD    sp, 6                        ; UNKNOWN
028CC8  6A 0F                 PUSH   0xf                          ; UNKNOWN
028CCA  6A 05                 PUSH   5                            ; UNKNOWN
028CCC  68 40 01              PUSH   0x140                        ; UNKNOWN
028CCF  6A 00                 PUSH   0                            ; UNKNOWN
028CD1  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028CD4  16                    PUSH   ss                           ; UNKNOWN
028CD5  50                    PUSH   ax                           ; UNKNOWN
028CD6  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
028CDB  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
028CDE  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
028CE2  FF 36 DB 3B           PUSH   word ptr [0x3bdb]            ; UNKNOWN
028CE6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028CE9  50                    PUSH   ax                           ; UNKNOWN
028CEA  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
028CEF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
028CF2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028CF5  50                    PUSH   ax                           ; UNKNOWN
028CF6  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
028CFB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028CFE  6A 0F                 PUSH   0xf                          ; UNKNOWN
028D00  6A 19                 PUSH   0x19                         ; UNKNOWN
028D02  B8 0A 00              MOV    ax, 0xa                      ; UNKNOWN
028D05  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
028D08  50                    PUSH   ax                           ; UNKNOWN
028D09  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028D0C  16                    PUSH   ss                           ; UNKNOWN
028D0D  50                    PUSH   ax                           ; UNKNOWN
028D0E  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
028D13  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
028D16  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
028D19  6A 0F                 PUSH   0xf                          ; UNKNOWN
028D1B  6A 19                 PUSH   0x19                         ; UNKNOWN
028D1D  50                    PUSH   ax                           ; UNKNOWN
028D1E  FF 36 8C 40           PUSH   word ptr [0x408c]            ; UNKNOWN
028D22  FF 36 8A 40           PUSH   word ptr [0x408a]            ; UNKNOWN
028D26  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
028D2B  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
028D2E  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
028D32  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
028D35  2A E4                 SUB    ah, ah                       ; UNKNOWN
028D37  83 C0 1B              ADD    ax, 0x1b                     ; UNKNOWN
028D3A  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
028D3D  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
028D41  FF 36 DD 3B           PUSH   word ptr [0x3bdd]            ; UNKNOWN
028D45  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028D48  50                    PUSH   ax                           ; UNKNOWN
028D49  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
028D4E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
028D51  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028D54  50                    PUSH   ax                           ; UNKNOWN
028D55  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
028D5A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028D5D  6A 0F                 PUSH   0xf                          ; UNKNOWN
028D5F  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
028D62  6A 0A                 PUSH   0xa                          ; UNKNOWN
028D64  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
028D67  16                    PUSH   ss                           ; UNKNOWN
028D68  50                    PUSH   ax                           ; UNKNOWN
028D69  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
028D6E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
028D71  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
028D75  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
028D79  26 80 7F 20 01        CMP    byte ptr es:[bx + 0x20], 1   ; UNKNOWN
028D7E  1B DB                 SBB    bx, bx                       ; UNKNOWN
028D80  83 E3 01              AND    bx, 1                        ; UNKNOWN
028D83  83                    DB     0x83                         ; UNKNOWN (raw)
028D84  C3                    DB     0xC3                         ; UNKNOWN (raw)
