; ============================================================================
; func_03CDC7_unknown
; Region   : load_image
; Bytes    : file 0x03CDC7..0x03CDE3  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CDC7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CDCB  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CDCE  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
03CDD1  8B D8                 MOV    bx, ax                       ; UNKNOWN
03CDD3  03 1E 10 0B           ADD    bx, word ptr [0xb10]         ; UNKNOWN
03CDD7  8E 06 12 0B           MOV    es, word ptr [0xb12]         ; UNKNOWN
03CDDB  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
03CDDE  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CDE1  C9                    LEAVE                               ; UNKNOWN
03CDE2  CB                    RETF                                ; UNKNOWN
