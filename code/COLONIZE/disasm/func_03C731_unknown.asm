; ============================================================================
; func_03C731_unknown
; Region   : load_image
; Bytes    : file 0x03C731..0x03C763  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C731  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03C735  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03C73A  0E                    PUSH   cs                           ; UNKNOWN
03C73B  E8 15 FC              CALL   0x3c353                      ; UNKNOWN
03C73E  A3 CE 79              MOV    word ptr [0x79ce], ax        ; UNKNOWN
03C741  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
03C746  74 03                 JE     0x3c74b                      ; UNKNOWN
03C748  A3 CC 79              MOV    word ptr [0x79cc], ax        ; UNKNOWN
03C74B  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
03C750  74 29                 JE     0x3c77b                      ; UNKNOWN
03C752  A1 CC 79              MOV    ax, word ptr [0x79cc]        ; UNKNOWN
03C755  EB 1B                 JMP    0x3c772                      ; UNKNOWN
03C757  0E                    PUSH   cs                           ; UNKNOWN
03C758  E8 8B FC              CALL   0x3c3e6                      ; UNKNOWN
03C75B  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03C75E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03C761  C9                    LEAVE                               ; UNKNOWN
03C762  CB                    RETF                                ; UNKNOWN
