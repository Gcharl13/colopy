; ============================================================================
; func_0362CA_unknown
; Region   : load_image
; Bytes    : file 0x0362CA..0x03632E  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0362CA  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0362CE  83 3E BA 79 0A        CMP    word ptr [0x79ba], 0xa       ; UNKNOWN
0362D3  75 59                 JNE    0x3632e                      ; UNKNOWN
0362D5  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
0362DA  75 03                 JNE    0x362df                      ; UNKNOWN
0362DC  E9 78 01              JMP    0x36457                      ; UNKNOWN
0362DF  83 3E A2 79 00        CMP    word ptr [0x79a2], 0         ; UNKNOWN
0362E4  74 03                 JE     0x362e9                      ; UNKNOWN
0362E6  E9 6E 01              JMP    0x36457                      ; UNKNOWN
0362E9  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
0362ED  0E                    PUSH   cs                           ; UNKNOWN
0362EE  E8 16 D1              CALL   0x33407                      ; UNKNOWN
0362F1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0362F4  0B C0                 OR     ax, ax                       ; UNKNOWN
0362F6  74 12                 JE     0x3630a                      ; UNKNOWN
0362F8  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
0362FC  0E                    PUSH   cs                           ; UNKNOWN
0362FD  E8 D9 F8              CALL   0x35bd9                      ; UNKNOWN
036300  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036303  0B C0                 OR     ax, ax                       ; UNKNOWN
036305  75 03                 JNE    0x3630a                      ; UNKNOWN
036307  E9 4D 01              JMP    0x36457                      ; UNKNOWN
03630A  FF 36 9C 79           PUSH   word ptr [0x799c]            ; UNKNOWN
03630E  0E                    PUSH   cs                           ; UNKNOWN
03630F  E8 71 D1              CALL   0x33483                      ; UNKNOWN
036312  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036315  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
036318  9A 0E 00 EF 21        LCALL  0x21ef, 0xe                  ; UNKNOWN
03631D  50                    PUSH   ax                           ; UNKNOWN
03631E  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
036322  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
036325  0E                    PUSH   cs                           ; UNKNOWN
036326  E8 7F EE              CALL   0x351a8                      ; UNKNOWN
036329  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03632C  C9                    LEAVE                               ; UNKNOWN
03632D  CB                    RETF                                ; UNKNOWN
