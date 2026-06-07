; ============================================================================
; func_04DD78_unknown
; Region   : load_image
; Bytes    : file 0x04DD78..0x04DD9F  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DD78  55                    PUSH   bp                           ; UNKNOWN
04DD79  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DD7B  57                    PUSH   di                           ; UNKNOWN
04DD7C  56                    PUSH   si                           ; UNKNOWN
04DD7D  1E                    PUSH   ds                           ; UNKNOWN
04DD7E  C4 7E 0A              LES    di, ptr [bp + 0xa]           ; UNKNOWN
04DD81  C5 76 06              LDS    si, ptr [bp + 6]             ; UNKNOWN
04DD84  B9 00 03              MOV    cx, 0x300                    ; UNKNOWN
04DD87  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
04DD88  51                    PUSH   cx                           ; UNKNOWN
04DD89  8B 4E 0E              MOV    cx, word ptr [bp + 0xe]      ; UNKNOWN
04DD8C  D2 E8                 SHR    al, cl                       ; UNKNOWN
04DD8E  59                    POP    cx                           ; UNKNOWN
04DD8F  14 00                 ADC    al, 0                        ; UNKNOWN
04DD91  0A C0                 OR     al, al                       ; UNKNOWN
04DD93  75 02                 JNE    0x4dd97                      ; UNKNOWN
04DD95  FE C0                 INC    al                           ; UNKNOWN
04DD97  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
04DD98  E2 ED                 LOOP   0x4dd87                      ; UNKNOWN
04DD9A  1F                    POP    ds                           ; UNKNOWN
04DD9B  5E                    POP    si                           ; UNKNOWN
04DD9C  5F                    POP    di                           ; UNKNOWN
04DD9D  C9                    LEAVE                               ; UNKNOWN
04DD9E  CB                    RETF                                ; UNKNOWN
