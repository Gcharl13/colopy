; ============================================================================
; func_02EC51_unknown
; Region   : load_image
; Bytes    : file 0x02EC51..0x02EC79  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EC51  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02EC55  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
02EC58  50                    PUSH   ax                           ; UNKNOWN
02EC59  8D 4E FE              LEA    cx, [bp - 2]                 ; UNKNOWN
02EC5C  51                    PUSH   cx                           ; UNKNOWN
02EC5D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EC60  0E                    PUSH   cs                           ; UNKNOWN
02EC61  E8 98 FF              CALL   0x2ebfc                      ; UNKNOWN
02EC64  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02EC67  0B C0                 OR     ax, ax                       ; UNKNOWN
02EC69  74 0C                 JE     0x2ec77                      ; UNKNOWN
02EC6B  6A FF                 PUSH   -1                           ; UNKNOWN
02EC6D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02EC70  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02EC73  0E                    PUSH   cs                           ; UNKNOWN
02EC74  E8 3B F0              CALL   0x2dcb2                      ; UNKNOWN
02EC77  C9                    LEAVE                               ; UNKNOWN
02EC78  CB                    RETF                                ; UNKNOWN
