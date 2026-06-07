; ============================================================================
; func_0682EA_unknown
; Region   : load_image
; Bytes    : file 0x0682EA..0x068304  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0682EA  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
0682EE  56                    PUSH   si                           ; UNKNOWN
0682EF  57                    PUSH   di                           ; UNKNOWN
0682F0  1E                    PUSH   ds                           ; UNKNOWN
0682F1  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
0682F4  8C C0                 MOV    ax, es                       ; UNKNOWN
0682F6  0B C7                 OR     ax, di                       ; UNKNOWN
0682F8  75 0A                 JNE    0x68304                      ; UNKNOWN
0682FA  B8 04 00              MOV    ax, 4                        ; UNKNOWN
0682FD  1F                    POP    ds                           ; UNKNOWN
0682FE  5F                    POP    di                           ; UNKNOWN
0682FF  5E                    POP    si                           ; UNKNOWN
068300  C9                    LEAVE                               ; UNKNOWN
068301  CA 0C 00              RETF   0xc                          ; UNKNOWN
