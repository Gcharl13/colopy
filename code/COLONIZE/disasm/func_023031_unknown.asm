; ============================================================================
; func_023031_unknown
; Region   : load_image
; Bytes    : file 0x023031..0x02304B  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023031  55                    PUSH   bp                           ; UNKNOWN
023032  8B EC                 MOV    bp, sp                       ; UNKNOWN
023034  6A 00                 PUSH   0                            ; UNKNOWN
023036  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
023039  6A 27                 PUSH   0x27                         ; UNKNOWN
02303B  6A 38                 PUSH   0x38                         ; UNKNOWN
02303D  FF 36 B0 3E           PUSH   word ptr [0x3eb0]            ; UNKNOWN
023041  FF 36 B2 3E           PUSH   word ptr [0x3eb2]            ; UNKNOWN
023045  0E                    PUSH   cs                           ; UNKNOWN
023046  E8 C0 FD              CALL   0x22e09                      ; UNKNOWN
023049  C9                    LEAVE                               ; UNKNOWN
02304A  CB                    RETF                                ; UNKNOWN
