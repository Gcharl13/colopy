; ============================================================================
; func_030582_unknown
; Region   : load_image
; Bytes    : file 0x030582..0x0305A1  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030582  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
030586  56                    PUSH   si                           ; UNKNOWN
030587  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
03058B  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
03058F  2A E4                 SUB    ah, ah                       ; UNKNOWN
030591  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
030594  7F 0B                 JG     0x305a1                      ; UNKNOWN
030596  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
03059B  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03059E  5E                    POP    si                           ; UNKNOWN
03059F  C9                    LEAVE                               ; UNKNOWN
0305A0  CB                    RETF                                ; UNKNOWN
