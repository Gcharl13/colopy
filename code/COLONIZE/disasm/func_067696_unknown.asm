; ============================================================================
; func_067696_unknown
; Region   : load_image
; Bytes    : file 0x067696..0x0676B3  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067696  55                    PUSH   bp                           ; UNKNOWN
067697  8B EC                 MOV    bp, sp                       ; UNKNOWN
067699  06                    PUSH   es                           ; UNKNOWN
06769A  57                    PUSH   di                           ; UNKNOWN
06769B  C4 7E 0A              LES    di, ptr [bp + 0xa]           ; UNKNOWN
06769E  06                    PUSH   es                           ; UNKNOWN
06769F  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
0676A2  06                    PUSH   es                           ; UNKNOWN
0676A3  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
0676A6  50                    PUSH   ax                           ; UNKNOWN
0676A7  9A 0C 00 57 5E        LCALL  0x5e57, 0xc                  ; UNKNOWN
0676AC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0676AF  5F                    POP    di                           ; UNKNOWN
0676B0  07                    POP    es                           ; UNKNOWN
0676B1  5D                    POP    bp                           ; UNKNOWN
0676B2  CB                    RETF                                ; UNKNOWN
