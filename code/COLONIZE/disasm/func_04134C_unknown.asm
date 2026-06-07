; ============================================================================
; func_04134C_unknown
; Region   : load_image
; Bytes    : file 0x04134C..0x0413A9  (93 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04134C  55                    PUSH   bp                           ; UNKNOWN
04134D  8B EC                 MOV    bp, sp                       ; UNKNOWN
04134F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041352  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041355  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
04135A  8B E5                 MOV    sp, bp                       ; UNKNOWN
04135C  0B C0                 OR     ax, ax                       ; UNKNOWN
04135E  74 47                 JE     0x413a7                      ; UNKNOWN
041360  83 3E 08 3E 01        CMP    word ptr [0x3e08], 1         ; UNKNOWN
041365  75 2D                 JNE    0x41394                      ; UNKNOWN
041367  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
04136B  74 0B                 JE     0x41378                      ; UNKNOWN
04136D  83 3E 56 C1 00        CMP    word ptr [0xc156], 0         ; UNKNOWN
041372  74 04                 JE     0x41378                      ; UNKNOWN
041374  0E                    PUSH   cs                           ; UNKNOWN
041375  E8 40 FE              CALL   0x411b8                      ; UNKNOWN
041378  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04137B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04137E  0E                    PUSH   cs                           ; UNKNOWN
04137F  E8 14 FE              CALL   0x41196                      ; UNKNOWN
041382  8B E5                 MOV    sp, bp                       ; UNKNOWN
041384  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
041388  74 0A                 JE     0x41394                      ; UNKNOWN
04138A  C7 06 56 C1 00 00     MOV    word ptr [0xc156], 0         ; UNKNOWN
041390  0E                    PUSH   cs                           ; UNKNOWN
041391  E8 24 FE              CALL   0x411b8                      ; UNKNOWN
041394  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
041397  A3 2C 0B              MOV    word ptr [0xb2c], ax         ; UNKNOWN
04139A  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04139D  A3 2E 0B              MOV    word ptr [0xb2e], ax         ; UNKNOWN
0413A0  6A 01                 PUSH   1                            ; UNKNOWN
0413A2  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
0413A7  C9                    LEAVE                               ; UNKNOWN
0413A8  CB                    RETF                                ; UNKNOWN
