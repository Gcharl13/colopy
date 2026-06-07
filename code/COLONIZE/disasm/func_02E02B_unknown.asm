; ============================================================================
; func_02E02B_unknown
; Region   : load_image
; Bytes    : file 0x02E02B..0x02E051  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E02B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E02F  C7 46 FE 64 00        MOV    word ptr [bp - 2], 0x64      ; UNKNOWN
02E034  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E038  80 BF 95 00 00        CMP    byte ptr [bx + 0x95], 0      ; UNKNOWN
02E03D  74 0D                 JE     0x2e04c                      ; UNKNOWN
02E03F  8A 87 95 00           MOV    al, byte ptr [bx + 0x95]     ; UNKNOWN
02E043  2A E4                 SUB    ah, ah                       ; UNKNOWN
02E045  40                    INC    ax                           ; UNKNOWN
02E046  6B C0 64              IMUL   ax, ax, 0x64                 ; UNKNOWN
02E049  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E04C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E04F  C9                    LEAVE                               ; UNKNOWN
02E050  CB                    RETF                                ; UNKNOWN
