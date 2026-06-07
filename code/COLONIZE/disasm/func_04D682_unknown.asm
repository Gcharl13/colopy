; ============================================================================
; func_04D682_unknown
; Region   : load_image
; Bytes    : file 0x04D682..0x04D69E  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04D682  C8 72 00 00           ENTER  0x72, 0                      ; UNKNOWN
04D686  56                    PUSH   si                           ; UNKNOWN
04D687  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
04D68C  74 10                 JE     0x4d69e                      ; UNKNOWN
04D68E  6A 01                 PUSH   1                            ; UNKNOWN
04D690  68 A4 29              PUSH   0x29a4                       ; UNKNOWN
04D693  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
04D698  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04D69B  5E                    POP    si                           ; UNKNOWN
04D69C  C9                    LEAVE                               ; UNKNOWN
04D69D  CB                    RETF                                ; UNKNOWN
