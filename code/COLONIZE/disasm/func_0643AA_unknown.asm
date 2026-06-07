; ============================================================================
; func_0643AA_unknown
; Region   : load_image
; Bytes    : file 0x0643AA..0x0643F7  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0643AA  55                    PUSH   bp                           ; UNKNOWN
0643AB  8B EC                 MOV    bp, sp                       ; UNKNOWN
0643AD  56                    PUSH   si                           ; UNKNOWN
0643AE  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
0643B1  6A 2E                 PUSH   0x2e                         ; UNKNOWN
0643B3  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0643B6  56                    PUSH   si                           ; UNKNOWN
0643B7  9A F6 13 65 5F        LCALL  0x5f65, 0x13f6               ; UNKNOWN
0643BC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0643BF  0B D0                 OR     dx, ax                       ; UNKNOWN
0643C1  75 22                 JNE    0x643e5                      ; UNKNOWN
0643C3  1E                    PUSH   ds                           ; UNKNOWN
0643C4  68 9A 30              PUSH   0x309a                       ; UNKNOWN
0643C7  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0643CA  56                    PUSH   si                           ; UNKNOWN
0643CB  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
0643D0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0643D3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0643D6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0643D9  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0643DC  56                    PUSH   si                           ; UNKNOWN
0643DD  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
0643E2  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0643E5  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
0643E8  50                    PUSH   ax                           ; UNKNOWN
0643E9  56                    PUSH   si                           ; UNKNOWN
0643EA  9A 24 14 65 5F        LCALL  0x5f65, 0x1424               ; UNKNOWN
0643EF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0643F2  5E                    POP    si                           ; UNKNOWN
0643F3  C9                    LEAVE                               ; UNKNOWN
0643F4  CA 08 00              RETF   8                            ; UNKNOWN
