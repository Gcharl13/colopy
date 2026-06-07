; ============================================================================
; func_03CF78_unknown
; Region   : load_image
; Bytes    : file 0x03CF78..0x03CF94  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CF78  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CF7C  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CF7F  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
03CF82  8B D8                 MOV    bx, ax                       ; UNKNOWN
03CF84  03 1E 18 0B           ADD    bx, word ptr [0xb18]         ; UNKNOWN
03CF88  8E 06 1A 0B           MOV    es, word ptr [0xb1a]         ; UNKNOWN
03CF8C  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
03CF8F  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CF92  C9                    LEAVE                               ; UNKNOWN
03CF93  CB                    RETF                                ; UNKNOWN
