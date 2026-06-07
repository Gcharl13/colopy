; ============================================================================
; func_03CE2F_unknown
; Region   : load_image
; Bytes    : file 0x03CE2F..0x03CE4C  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CE2F  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CE33  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CE36  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
03CE3A  8B D8                 MOV    bx, ax                       ; UNKNOWN
03CE3C  03 1E 14 0B           ADD    bx, word ptr [0xb14]         ; UNKNOWN
03CE40  8E 06 16 0B           MOV    es, word ptr [0xb16]         ; UNKNOWN
03CE44  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
03CE47  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CE4A  C9                    LEAVE                               ; UNKNOWN
03CE4B  CB                    RETF                                ; UNKNOWN
