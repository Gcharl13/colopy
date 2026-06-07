; ============================================================================
; func_069B9E_unknown
; Region   : load_image
; Bytes    : file 0x069B9E..0x069BC0  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069B9E  55                    PUSH   bp                           ; UNKNOWN
069B9F  8B EC                 MOV    bp, sp                       ; UNKNOWN
069BA1  B8 FC 00              MOV    ax, 0xfc                     ; UNKNOWN
069BA4  50                    PUSH   ax                           ; UNKNOWN
069BA5  0E                    PUSH   cs                           ; UNKNOWN
069BA6  E8 7C 02              CALL   0x69e25                      ; UNKNOWN
069BA9  83 3E C0 14 00        CMP    word ptr [0x14c0], 0         ; UNKNOWN
069BAE  74 04                 JE     0x69bb4                      ; UNKNOWN
069BB0  FF 1E BE 14           LCALL  [0x14be]                     ; UNKNOWN
069BB4  B8 FF 00              MOV    ax, 0xff                     ; UNKNOWN
069BB7  50                    PUSH   ax                           ; UNKNOWN
069BB8  0E                    PUSH   cs                           ; UNKNOWN
069BB9  E8 69 02              CALL   0x69e25                      ; UNKNOWN
069BBC  8B E5                 MOV    sp, bp                       ; UNKNOWN
069BBE  5D                    POP    bp                           ; UNKNOWN
069BBF  CB                    RETF                                ; UNKNOWN
