; ============================================================================
; func_03CDB0_unknown
; Region   : load_image
; Bytes    : file 0x03CDB0..0x03CDC7  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CDB0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CDB4  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03CDB7  F7 6E 08              IMUL   word ptr [bp + 8]            ; UNKNOWN
03CDBA  03 06 10 0B           ADD    ax, word ptr [0xb10]         ; UNKNOWN
03CDBE  8B 16 12 0B           MOV    dx, word ptr [0xb12]         ; UNKNOWN
03CDC2  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
03CDC5  C9                    LEAVE                               ; UNKNOWN
03CDC6  CB                    RETF                                ; UNKNOWN
