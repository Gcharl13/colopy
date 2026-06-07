; ============================================================================
; func_00E67E_unknown
; Region   : load_image
; Bytes    : file 0x00E67E..0x00E68F  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E67E  55                    PUSH   bp                           ; UNKNOWN
00E67F  8B EC                 MOV    bp, sp                       ; UNKNOWN
00E681  57                    PUSH   di                           ; UNKNOWN
00E682  83 3E 4C 05 00        CMP    word ptr [0x54c], 0          ; UNKNOWN
00E687  74 07                 JE     0xe690                       ; UNKNOWN
00E689  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00E68C  5F                    POP    di                           ; UNKNOWN
00E68D  C9                    LEAVE                               ; UNKNOWN
00E68E  CB                    RETF                                ; UNKNOWN
