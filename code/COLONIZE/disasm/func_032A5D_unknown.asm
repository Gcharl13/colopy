; ============================================================================
; func_032A5D_unknown
; Region   : load_image
; Bytes    : file 0x032A5D..0x032A94  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032A5D  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
032A61  56                    PUSH   si                           ; UNKNOWN
032A62  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
032A67  83 3E 16 3E 40        CMP    word ptr [0x3e16], 0x40      ; UNKNOWN
032A6C  7C 26                 JL     0x32a94                      ; UNKNOWN
032A6E  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
032A72  7C 03                 JL     0x32a77                      ; UNKNOWN
032A74  E9 99 02              JMP    0x32d10                      ; UNKNOWN
032A77  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
032A7B  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
032A80  74 03                 JE     0x32a85                      ; UNKNOWN
032A82  E9 8B 02              JMP    0x32d10                      ; UNKNOWN
032A85  8D 1E C5 1F           LEA    bx, [0x1fc5]                 ; UNKNOWN
032A89  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
032A8E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
032A91  5E                    POP    si                           ; UNKNOWN
032A92  C9                    LEAVE                               ; UNKNOWN
032A93  CB                    RETF                                ; UNKNOWN
