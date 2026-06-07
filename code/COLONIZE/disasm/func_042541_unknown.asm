; ============================================================================
; func_042541_unknown
; Region   : load_image
; Bytes    : file 0x042541..0x0425E4  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042541  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
042545  2B C0                 SUB    ax, ax                       ; UNKNOWN
042547  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04254A  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04254D  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
042550  8B 5E A8              MOV    bx, word ptr [bp - 0x58]     ; UNKNOWN
042553  8A 87 98 0B           MOV    al, byte ptr [bx + 0xb98]    ; UNKNOWN
042557  2A E4                 SUB    ah, ah                       ; UNKNOWN
042559  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
04255C  50                    PUSH   ax                           ; UNKNOWN
04255D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042560  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
042565  83 C4 04              ADD    sp, 4                        ; UNKNOWN
042568  0B C0                 OR     ax, ax                       ; UNKNOWN
04256A  74 6A                 JE     0x425d6                      ; UNKNOWN
04256C  68 AA 27              PUSH   0x27aa                       ; UNKNOWN
04256F  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
042572  50                    PUSH   ax                           ; UNKNOWN
042573  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
042578  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04257B  83 7E AA 0A           CMP    word ptr [bp - 0x56], 0xa    ; UNKNOWN
04257F  7D 0F                 JGE    0x42590                      ; UNKNOWN
042581  68 AE 27              PUSH   0x27ae                       ; UNKNOWN
042584  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
042587  50                    PUSH   ax                           ; UNKNOWN
042588  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
04258D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
042590  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
042593  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
042596  16                    PUSH   ss                           ; UNKNOWN
042597  50                    PUSH   ax                           ; UNKNOWN
042598  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
04259D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0425A0  9A 08 00 D0 21        LCALL  0x21d0, 8                    ; UNKNOWN
0425A5  8D 5E AC              LEA    bx, [bp - 0x54]              ; UNKNOWN
0425A8  2B C0                 SUB    ax, ax                       ; UNKNOWN
0425AA  9A 5A 00 D0 21        LCALL  0x21d0, 0x5a                 ; UNKNOWN
0425AF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0425B2  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
0425B5  0B D0                 OR     dx, ax                       ; UNKNOWN
0425B7  74 1D                 JE     0x425d6                      ; UNKNOWN
0425B9  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0425BC  50                    PUSH   ax                           ; UNKNOWN
0425BD  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
0425C0  26 FF 77 48           PUSH   word ptr es:[bx + 0x48]      ; UNKNOWN
0425C4  6A 64                 PUSH   0x64                         ; UNKNOWN
0425C6  26 8B 57 46           MOV    dx, word ptr es:[bx + 0x46]  ; UNKNOWN
0425CA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0425CD  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0425D1  9A 02 00 35 5D        LCALL  0x5d35, 2                    ; UNKNOWN
0425D6  FF 46 A8              INC    word ptr [bp - 0x58]         ; UNKNOWN
0425D9  83 7E A8 19           CMP    word ptr [bp - 0x58], 0x19   ; UNKNOWN
0425DD  7D 03                 JGE    0x425e2                      ; UNKNOWN
0425DF  E9 6E FF              JMP    0x42550                      ; UNKNOWN
0425E2  C9                    LEAVE                               ; UNKNOWN
0425E3  CB                    RETF                                ; UNKNOWN
