; ============================================================================
; func_034CA5_unknown
; Region   : load_image
; Bytes    : file 0x034CA5..0x034CF5  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034CA5  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
034CA9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034CAC  0E                    PUSH   cs                           ; UNKNOWN
034CAD  E8 89 E1              CALL   0x32e39                      ; UNKNOWN
034CB0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034CB3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
034CB6  83 F9 64              CMP    cx, 0x64                     ; UNKNOWN
034CB9  7E 03                 JLE    0x34cbe                      ; UNKNOWN
034CBB  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
034CBE  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
034CC1  F7 E9                 IMUL   cx                           ; UNKNOWN
034CC3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
034CC6  99                    CDQ                                 ; UNKNOWN
034CC7  52                    PUSH   dx                           ; UNKNOWN
034CC8  50                    PUSH   ax                           ; UNKNOWN
034CC9  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
034CCD  9A 8A 05 5F 24        LCALL  0x245f, 0x58a                ; UNKNOWN
034CD2  83 C4 06              ADD    sp, 6                        ; UNKNOWN
034CD5  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
034CD8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034CDB  0E                    PUSH   cs                           ; UNKNOWN
034CDC  E8 8D FE              CALL   0x34b6c                      ; UNKNOWN
034CDF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
034CE2  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
034CE5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034CE8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
034CEB  9A 55 30 5F 24        LCALL  0x245f, 0x3055               ; UNKNOWN
034CF0  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
034CF3  C9                    LEAVE                               ; UNKNOWN
034CF4  CB                    RETF                                ; UNKNOWN
