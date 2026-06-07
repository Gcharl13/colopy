; ============================================================================
; func_02171E_unknown
; Region   : load_image
; Bytes    : file 0x02171E..0x021774  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02171E  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
021722  56                    PUSH   si                           ; UNKNOWN
021723  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
021726  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
021729  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02172C  16                    PUSH   ss                           ; UNKNOWN
02172D  50                    PUSH   ax                           ; UNKNOWN
02172E  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
021733  83 C4 08              ADD    sp, 8                        ; UNKNOWN
021736  6A 7E                 PUSH   0x7e                         ; UNKNOWN
021738  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
02173B  50                    PUSH   ax                           ; UNKNOWN
02173C  9A 90 0C 65 5F        LCALL  0x5f65, 0xc90                ; UNKNOWN
021741  83 C4 04              ADD    sp, 4                        ; UNKNOWN
021744  8B F0                 MOV    si, ax                       ; UNKNOWN
021746  0B F6                 OR     si, si                       ; UNKNOWN
021748  74 0F                 JE     0x21759                      ; UNKNOWN
02174A  8D 44 01              LEA    ax, [si + 1]                 ; UNKNOWN
02174D  1E                    PUSH   ds                           ; UNKNOWN
02174E  50                    PUSH   ax                           ; UNKNOWN
02174F  1E                    PUSH   ds                           ; UNKNOWN
021750  56                    PUSH   si                           ; UNKNOWN
021751  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
021756  83 C4 08              ADD    sp, 8                        ; UNKNOWN
021759  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02175C  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa]       ; UNKNOWN
021760  26 FF 77 08           PUSH   word ptr es:[bx + 8]         ; UNKNOWN
021764  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
021767  16                    PUSH   ss                           ; UNKNOWN
021768  50                    PUSH   ax                           ; UNKNOWN
021769  26 8B 07              MOV    ax, word ptr es:[bx]         ; UNKNOWN
02176C  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
021771  5E                    POP    si                           ; UNKNOWN
021772  C9                    LEAVE                               ; UNKNOWN
021773  CB                    RETF                                ; UNKNOWN
