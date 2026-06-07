; ============================================================================
; func_039721_unknown
; Region   : load_image
; Bytes    : file 0x039721..0x03977D  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039721  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
039725  A1 80 82              MOV    ax, word ptr [0x8280]        ; UNKNOWN
039728  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03972B  EB 31                 JMP    0x3975e                      ; UNKNOWN
03972D  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
039730  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
039733  39 06 52 85           CMP    word ptr [0x8552], ax        ; UNKNOWN
039737  7C 22                 JL     0x3975b                      ; UNKNOWN
039739  6A 0F                 PUSH   0xf                          ; UNKNOWN
03973B  50                    PUSH   ax                           ; UNKNOWN
03973C  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03973F  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
039744  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039747  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
03974A  50                    PUSH   ax                           ; UNKNOWN
03974B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03974E  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
039751  9A 04 00 AA 38        LCALL  0x38aa, 4                    ; UNKNOWN
039756  83 C4 08              ADD    sp, 8                        ; UNKNOWN
039759  EB D2                 JMP    0x3972d                      ; UNKNOWN
03975B  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03975E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
039761  39 06 50 85           CMP    word ptr [0x8550], ax        ; UNKNOWN
039765  7C 08                 JL     0x3976f                      ; UNKNOWN
039767  A1 86 82              MOV    ax, word ptr [0x8286]        ; UNKNOWN
03976A  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03976D  EB C1                 JMP    0x39730                      ; UNKNOWN
03976F  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
039774  6A 01                 PUSH   1                            ; UNKNOWN
039776  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
03977B  C9                    LEAVE                               ; UNKNOWN
03977C  CB                    RETF                                ; UNKNOWN
