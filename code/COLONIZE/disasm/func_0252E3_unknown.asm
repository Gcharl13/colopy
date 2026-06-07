; ============================================================================
; func_0252E3_unknown
; Region   : load_image
; Bytes    : file 0x0252E3..0x025312  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0252E3  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0252E7  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0252EC  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0252EF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0252F2  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0252F5  0E                    PUSH   cs                           ; UNKNOWN
0252F6  E8 FF FE              CALL   0x251f8                      ; UNKNOWN
0252F9  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0252FC  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0252FF  0B D0                 OR     dx, ax                       ; UNKNOWN
025301  74 0A                 JE     0x2530d                      ; UNKNOWN
025303  C4 5E FA              LES    bx, ptr [bp - 6]             ; UNKNOWN
025306  26 8B 47 06           MOV    ax, word ptr es:[bx + 6]     ; UNKNOWN
02530A  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02530D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
025310  C9                    LEAVE                               ; UNKNOWN
025311  CB                    RETF                                ; UNKNOWN
