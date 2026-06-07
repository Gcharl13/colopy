; ============================================================================
; func_03CF61_unknown
; Region   : load_image
; Bytes    : file 0x03CF61..0x03CF78  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CF61  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CF65  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CF68  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
03CF6B  03 06 18 0B           ADD    ax, word ptr [0xb18]         ; UNKNOWN
03CF6F  8B 16 1A 0B           MOV    dx, word ptr [0xb1a]         ; UNKNOWN
03CF73  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03CF76  C9                    LEAVE                               ; UNKNOWN
03CF77  CB                    RETF                                ; UNKNOWN
