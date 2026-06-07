; ============================================================================
; func_03CD46_unknown
; Region   : load_image
; Bytes    : file 0x03CD46..0x03CD7C  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CD46  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CD4A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03CD4F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CD52  39 06 80 82           CMP    word ptr [0x8280], ax        ; UNKNOWN
03CD56  7F 06                 JG     0x3cd5e                      ; UNKNOWN
03CD58  39 06 50 85           CMP    word ptr [0x8550], ax        ; UNKNOWN
03CD5C  7D 05                 JGE    0x3cd63                      ; UNKNOWN
03CD5E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03CD63  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CD66  39 06 86 82           CMP    word ptr [0x8286], ax        ; UNKNOWN
03CD6A  7F 06                 JG     0x3cd72                      ; UNKNOWN
03CD6C  39 06 52 85           CMP    word ptr [0x8552], ax        ; UNKNOWN
03CD70  7D 05                 JGE    0x3cd77                      ; UNKNOWN
03CD72  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03CD77  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CD7A  C9                    LEAVE                               ; UNKNOWN
03CD7B  CB                    RETF                                ; UNKNOWN
