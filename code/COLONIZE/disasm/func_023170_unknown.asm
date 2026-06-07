; ============================================================================
; func_023170_unknown
; Region   : load_image
; Bytes    : file 0x023170..0x023230  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023170  55                    PUSH   bp                           ; UNKNOWN
023171  8B EC                 MOV    bp, sp                       ; UNKNOWN
023173  0E                    PUSH   cs                           ; UNKNOWN
023174  E8 52 FC              CALL   0x22dc9                      ; UNKNOWN
023177  83 3E 4A 0A 00        CMP    word ptr [0xa4a], 0          ; UNKNOWN
02317C  75 24                 JNE    0x231a2                      ; UNKNOWN
02317E  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
023182  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
023186  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02318A  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02318E  6A 29                 PUSH   0x29                         ; UNKNOWN
023190  6A 00                 PUSH   0                            ; UNKNOWN
023192  B8 F1 00              MOV    ax, 0xf1                     ; UNKNOWN
023195  BA 08 00              MOV    dx, 8                        ; UNKNOWN
023198  BB 4F 00              MOV    bx, 0x4f                     ; UNKNOWN
02319B  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
0231A0  EB 33                 JMP    0x231d5                      ; UNKNOWN
0231A2  6A 00                 PUSH   0                            ; UNKNOWN
0231A4  6A 00                 PUSH   0                            ; UNKNOWN
0231A6  6A 29                 PUSH   0x29                         ; UNKNOWN
0231A8  6A 4F                 PUSH   0x4f                         ; UNKNOWN
0231AA  6A 08                 PUSH   8                            ; UNKNOWN
0231AC  68 F1 00              PUSH   0xf1                         ; UNKNOWN
0231AF  8B 1E 4A 0A           MOV    bx, word ptr [0xa4a]         ; UNKNOWN
0231B3  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
0231B6  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
0231B9  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
0231BC  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0231BE  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0231C2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0231C6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0231CA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0231CE  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
0231D3  8B E5                 MOV    sp, bp                       ; UNKNOWN
0231D5  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0231D9  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0231DD  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0231E1  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0231E5  6A 30                 PUSH   0x30                         ; UNKNOWN
0231E7  6A 06                 PUSH   6                            ; UNKNOWN
0231E9  B8 FB 00              MOV    ax, 0xfb                     ; UNKNOWN
0231EC  BA 08 00              MOV    dx, 8                        ; UNKNOWN
0231EF  BB 34 01              MOV    bx, 0x134                    ; UNKNOWN
0231F2  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
0231F7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0231FA  0E                    PUSH   cs                           ; UNKNOWN
0231FB  E8 33 FE              CALL   0x23031                      ; UNKNOWN
0231FE  8B E5                 MOV    sp, bp                       ; UNKNOWN
023200  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
023204  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
023208  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02320C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
023210  A1 B0 3E              MOV    ax, word ptr [0x3eb0]        ; UNKNOWN
023213  83 C0 26              ADD    ax, 0x26                     ; UNKNOWN
023216  3B 06 52 85           CMP    ax, word ptr [0x8552]        ; UNKNOWN
02321A  7E 03                 JLE    0x2321f                      ; UNKNOWN
02321C  A1 52 85              MOV    ax, word ptr [0x8552]        ; UNKNOWN
02321F  2B 06 B0 3E           SUB    ax, word ptr [0x3eb0]        ; UNKNOWN
023223  83 C0 09              ADD    ax, 9                        ; UNKNOWN
023226  50                    PUSH   ax                           ; UNKNOWN
023227  6A 0F                 PUSH   0xf                          ; UNKNOWN
023229  A1 B2 3E              MOV    ax, word ptr [0x3eb2]        ; UNKNOWN
02322C  8B D8                 MOV    bx, ax                       ; UNKNOWN
02322E  83                    DB     0x83                         ; UNKNOWN (raw)
02322F  C3                    DB     0xC3                         ; UNKNOWN (raw)
