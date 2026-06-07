; ============================================================================
; func_065FDD_unknown
; Region   : load_image
; Bytes    : file 0x065FDD..0x06600E  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065FDD  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
065FE1  06                    PUSH   es                           ; UNKNOWN
065FE2  1E                    PUSH   ds                           ; UNKNOWN
065FE3  56                    PUSH   si                           ; UNKNOWN
065FE4  57                    PUSH   di                           ; UNKNOWN
065FE5  C6 06 FE 0E FF        MOV    byte ptr [0xefe], 0xff       ; UNKNOWN
065FEA  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
065FED  0B D2                 OR     dx, dx                       ; UNKNOWN
065FEF  74 17                 JE     0x66008                      ; UNKNOWN
065FF1  BE 32 00              MOV    si, 0x32                     ; UNKNOWN
065FF4  BF A8 CE              MOV    di, 0xcea8                   ; UNKNOWN
065FF7  B8 F7 62              MOV    ax, 0x62f7                   ; UNKNOWN
065FFA  8E C0                 MOV    es, ax                       ; UNKNOWN
065FFC  B9 05 00              MOV    cx, 5                        ; UNKNOWN
065FFF  8E DA                 MOV    ds, dx                       ; UNKNOWN
066001  A1 28 00              MOV    ax, word ptr [0x28]          ; UNKNOWN
066004  A5                    MOVSW  word ptr es:[di], word ptr [si] ; UNKNOWN
066005  AB                    STOSW  word ptr es:[di], ax         ; UNKNOWN
066006  E2 FC                 LOOP   0x66004                      ; UNKNOWN
066008  5F                    POP    di                           ; UNKNOWN
066009  5E                    POP    si                           ; UNKNOWN
06600A  1F                    POP    ds                           ; UNKNOWN
06600B  07                    POP    es                           ; UNKNOWN
06600C  C9                    LEAVE                               ; UNKNOWN
06600D  CB                    RETF                                ; UNKNOWN
