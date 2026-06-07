; ============================================================================
; func_03CD7C_unknown
; Region   : load_image
; Bytes    : file 0x03CD7C..0x03CD94  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CD7C  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CD80  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CD83  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
03CD87  03 06 0C 0B           ADD    ax, word ptr [0xb0c]         ; UNKNOWN
03CD8B  8B 16 0E 0B           MOV    dx, word ptr [0xb0e]         ; UNKNOWN
03CD8F  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03CD92  C9                    LEAVE                               ; UNKNOWN
03CD93  CB                    RETF                                ; UNKNOWN
