; ============================================================================
; func_068446_unknown
; Region   : load_image
; Bytes    : file 0x068446..0x06845A  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068446  55                    PUSH   bp                           ; UNKNOWN
068447  8B EC                 MOV    bp, sp                       ; UNKNOWN
068449  FA                    CLI                                 ; UNKNOWN
06844A  B0 36                 MOV    al, 0x36                     ; UNKNOWN
06844C  E6 43                 OUT    0x43, al                     ; UNKNOWN
06844E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
068451  E6 40                 OUT    0x40, al                     ; UNKNOWN
068453  8A C4                 MOV    al, ah                       ; UNKNOWN
068455  E6 40                 OUT    0x40, al                     ; UNKNOWN
068457  FB                    STI                                 ; UNKNOWN
068458  C9                    LEAVE                               ; UNKNOWN
068459  CB                    RETF                                ; UNKNOWN
