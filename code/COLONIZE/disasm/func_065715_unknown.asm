; ============================================================================
; func_065715_unknown
; Region   : load_image
; Bytes    : file 0x065715..0x06572E  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065715  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
065719  06                    PUSH   es                           ; UNKNOWN
06571A  C4 46 06              LES    ax, ptr [bp + 6]             ; UNKNOWN
06571D  A3 A8 0C              MOV    word ptr [0xca8], ax         ; UNKNOWN
065720  8C C0                 MOV    ax, es                       ; UNKNOWN
065722  A3 A6 0C              MOV    word ptr [0xca6], ax         ; UNKNOWN
065725  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
065728  A3 AA 0C              MOV    word ptr [0xcaa], ax         ; UNKNOWN
06572B  07                    POP    es                           ; UNKNOWN
06572C  C9                    LEAVE                               ; UNKNOWN
06572D  CB                    RETF                                ; UNKNOWN
