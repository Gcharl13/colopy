; ============================================================================
; func_06A70E_unknown
; Region   : load_image
; Bytes    : file 0x06A70E..0x06A72E  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A70E  55                    PUSH   bp                           ; UNKNOWN
06A70F  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A711  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06A714  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
06A718  72 06                 JB     0x6a720                      ; UNKNOWN
06A71A  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
06A71D  F9                    STC                                 ; UNKNOWN
06A71E  EB 0B                 JMP    0x6a72b                      ; UNKNOWN
06A720  B4 3E                 MOV    ah, 0x3e                     ; UNKNOWN
06A722  CD 21                 INT    0x21                         ; UNKNOWN
06A724  72 05                 JB     0x6a72b                      ; UNKNOWN
06A726  C6 87 47 12 00        MOV    byte ptr [bx + 0x1247], 0    ; UNKNOWN
06A72B  E9 2E F7              JMP    0x69e5c                      ; UNKNOWN
