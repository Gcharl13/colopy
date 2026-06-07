; ============================================================================
; func_03CD94_unknown
; Region   : load_image
; Bytes    : file 0x03CD94..0x03CDB0  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CD94  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CD98  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CD9B  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
03CD9E  8B D8                 MOV    bx, ax                       ; UNKNOWN
03CDA0  03 1E 0C 0B           ADD    bx, word ptr [0xb0c]         ; UNKNOWN
03CDA4  8E 06 0E 0B           MOV    es, word ptr [0xb0e]         ; UNKNOWN
03CDA8  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
03CDAB  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CDAE  C9                    LEAVE                               ; UNKNOWN
03CDAF  CB                    RETF                                ; UNKNOWN
