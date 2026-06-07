; ============================================================================
; func_069620_unknown
; Region   : load_image
; Bytes    : file 0x069620..0x069640  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069620  55                    PUSH   bp                           ; UNKNOWN
069621  8B EC                 MOV    bp, sp                       ; UNKNOWN
069623  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
069626  B8 00 43              MOV    ax, 0x4300                   ; UNKNOWN
069629  CD 21                 INT    0x21                         ; UNKNOWN
06962B  72 0F                 JB     0x6963c                      ; UNKNOWN
06962D  F6 46 08 02           TEST   byte ptr [bp + 8], 2         ; UNKNOWN
069631  74 09                 JE     0x6963c                      ; UNKNOWN
069633  F6 C1 01              TEST   cl, 1                        ; UNKNOWN
069636  74 04                 JE     0x6963c                      ; UNKNOWN
069638  B8 00 0D              MOV    ax, 0xd00                    ; UNKNOWN
06963B  F9                    STC                                 ; UNKNOWN
06963C  E9 1D 08              JMP    0x69e5c                      ; UNKNOWN
06963F  00                    DB     0x00                         ; UNKNOWN (raw)
