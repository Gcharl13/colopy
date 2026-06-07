; ============================================================================
; func_041AA4_unknown
; Region   : load_image
; Bytes    : file 0x041AA4..0x041B7D  (217 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041AA4  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
041AA8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041AAB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041AAE  9A B6 00 C9 33        LCALL  0x33c9, 0xb6                 ; UNKNOWN
041AB3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041AB6  0B C0                 OR     ax, ax                       ; UNKNOWN
041AB8  75 03                 JNE    0x41abd                      ; UNKNOWN
041ABA  E9 BE 00              JMP    0x41b7b                      ; UNKNOWN
041ABD  A1 82 82              MOV    ax, word ptr [0x8282]        ; UNKNOWN
041AC0  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
041AC4  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
041AC7  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
041ACB  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
041ACE  A1 84 82              MOV    ax, word ptr [0x8284]        ; UNKNOWN
041AD1  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
041AD5  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
041AD8  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
041ADC  83 C0 08              ADD    ax, 8                        ; UNKNOWN
041ADF  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
041AE2  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
041AE6  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
041AE9  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
041AEC  16                    PUSH   ss                           ; UNKNOWN
041AED  50                    PUSH   ax                           ; UNKNOWN
041AEE  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
041AF3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
041AF6  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
041AFA  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
041AFE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
041B01  16                    PUSH   ss                           ; UNKNOWN
041B02  50                    PUSH   ax                           ; UNKNOWN
041B03  2B C0                 SUB    ax, ax                       ; UNKNOWN
041B05  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
041B0A  40                    INC    ax                           ; UNKNOWN
041B0B  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
041B0E  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
041B12  B8 07 00              MOV    ax, 7                        ; UNKNOWN
041B15  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041B17  01 46 AE              ADD    word ptr [bp - 0x52], ax     ; UNKNOWN
041B1A  B8 06 00              MOV    ax, 6                        ; UNKNOWN
041B1D  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041B1F  01 46 AC              ADD    word ptr [bp - 0x54], ax     ; UNKNOWN
041B22  83 3E 34 0B 00        CMP    word ptr [0xb34], 0          ; UNKNOWN
041B27  75 24                 JNE    0x41b4d                      ; UNKNOWN
041B29  FF 36 72 0C           PUSH   word ptr [0xc72]             ; UNKNOWN
041B2D  FF 36 70 0C           PUSH   word ptr [0xc70]             ; UNKNOWN
041B31  FF 36 6E 0C           PUSH   word ptr [0xc6e]             ; UNKNOWN
041B35  FF 36 6C 0C           PUSH   word ptr [0xc6c]             ; UNKNOWN
041B39  6A 07                 PUSH   7                            ; UNKNOWN
041B3B  6A 00                 PUSH   0                            ; UNKNOWN
041B3D  8B 46 AE              MOV    ax, word ptr [bp - 0x52]     ; UNKNOWN
041B40  48                    DEC    ax                           ; UNKNOWN
041B41  8B 56 AC              MOV    dx, word ptr [bp - 0x54]     ; UNKNOWN
041B44  4A                    DEC    dx                           ; UNKNOWN
041B45  8B 5E AA              MOV    bx, word ptr [bp - 0x56]     ; UNKNOWN
041B48  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
041B4D  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041B50  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
041B53  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
041B56  8B DA                 MOV    bx, dx                       ; UNKNOWN
041B58  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
041B5D  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
041B61  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
041B65  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
041B68  16                    PUSH   ss                           ; UNKNOWN
041B69  50                    PUSH   ax                           ; UNKNOWN
041B6A  6A 00                 PUSH   0                            ; UNKNOWN
041B6C  8D 1E 6C 0C           LEA    bx, [0xc6c]                  ; UNKNOWN
041B70  8B 46 AE              MOV    ax, word ptr [bp - 0x52]     ; UNKNOWN
041B73  8B 56 AC              MOV    dx, word ptr [bp - 0x54]     ; UNKNOWN
041B76  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
041B7B  C9                    LEAVE                               ; UNKNOWN
041B7C  CB                    RETF                                ; UNKNOWN
