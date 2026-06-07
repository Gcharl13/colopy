; ============================================================================
; func_01AFA6_unknown
; Region   : load_image
; Bytes    : file 0x01AFA6..0x01AFDF  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01AFA6  55                    PUSH   bp                           ; UNKNOWN
01AFA7  8B EC                 MOV    bp, sp                       ; UNKNOWN
01AFA9  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
01AFAD  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
01AFB1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01AFB4  9A F5 0E 5F 24        LCALL  0x245f, 0xef5                ; UNKNOWN
01AFB9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01AFBC  BA 01 00              MOV    dx, 1                        ; UNKNOWN
01AFBF  9A 00 00 BC 5C        LCALL  0x5cbc, 0                    ; UNKNOWN
01AFC4  C7 06 0A 09 01 00     MOV    word ptr [0x90a], 1          ; UNKNOWN
01AFCA  C7 06 C6 32 06 00     MOV    word ptr [0x32c6], 6         ; UNKNOWN
01AFD0  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01AFD3  A3 44 73              MOV    word ptr [0x7344], ax        ; UNKNOWN
01AFD6  A3 E3 32              MOV    word ptr [0x32e3], ax        ; UNKNOWN
01AFD9  0E                    PUSH   cs                           ; UNKNOWN
01AFDA  E8 F5 EA              CALL   0x19ad2                      ; UNKNOWN
01AFDD  C9                    LEAVE                               ; UNKNOWN
01AFDE  CB                    RETF                                ; UNKNOWN
