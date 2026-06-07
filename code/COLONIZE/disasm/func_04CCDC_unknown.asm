; ============================================================================
; func_04CCDC_unknown
; Region   : load_image
; Bytes    : file 0x04CCDC..0x04CD33  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CCDC  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04CCE0  6A 06                 PUSH   6                            ; UNKNOWN
04CCE2  0E                    PUSH   cs                           ; UNKNOWN
04CCE3  E8 7C E4              CALL   0x4b162                      ; UNKNOWN
04CCE6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CCE9  68 90 00              PUSH   0x90                         ; UNKNOWN
04CCEC  6A 05                 PUSH   5                            ; UNKNOWN
04CCEE  68 40 01              PUSH   0x140                        ; UNKNOWN
04CCF1  6A 00                 PUSH   0                            ; UNKNOWN
04CCF3  FF 36 60 33           PUSH   word ptr [0x3360]            ; UNKNOWN
04CCF7  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04CCFC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CCFF  52                    PUSH   dx                           ; UNKNOWN
04CD00  50                    PUSH   ax                           ; UNKNOWN
04CD01  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04CD06  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04CD09  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
04CD0D  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
04CD10  2A E4                 SUB    ah, ah                       ; UNKNOWN
04CD12  83 C0 06              ADD    ax, 6                        ; UNKNOWN
04CD15  68 91 00              PUSH   0x91                         ; UNKNOWN
04CD18  50                    PUSH   ax                           ; UNKNOWN
04CD19  68 40 01              PUSH   0x140                        ; UNKNOWN
04CD1C  6A 00                 PUSH   0                            ; UNKNOWN
04CD1E  FF 36 9C 34           PUSH   word ptr [0x349c]            ; UNKNOWN
04CD22  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04CD27  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04CD2A  52                    PUSH   dx                           ; UNKNOWN
04CD2B  50                    PUSH   ax                           ; UNKNOWN
04CD2C  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04CD31  C9                    LEAVE                               ; UNKNOWN
04CD32  CB                    RETF                                ; UNKNOWN
