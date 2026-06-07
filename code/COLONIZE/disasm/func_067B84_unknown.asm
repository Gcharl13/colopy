; ============================================================================
; func_067B84_unknown
; Region   : load_image
; Bytes    : file 0x067B84..0x067B99  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067B84  55                    PUSH   bp                           ; UNKNOWN
067B85  8B EC                 MOV    bp, sp                       ; UNKNOWN
067B87  57                    PUSH   di                           ; UNKNOWN
067B88  C4 3E 7A 11           LES    di, ptr [0x117a]             ; UNKNOWN
067B8C  8C C0                 MOV    ax, es                       ; UNKNOWN
067B8E  0B C7                 OR     ax, di                       ; UNKNOWN
067B90  74 04                 JE     0x67b96                      ; UNKNOWN
067B92  FF 1E 7A 11           LCALL  [0x117a]                     ; UNKNOWN
067B96  5F                    POP    di                           ; UNKNOWN
067B97  C9                    LEAVE                               ; UNKNOWN
067B98  CB                    RETF                                ; UNKNOWN
