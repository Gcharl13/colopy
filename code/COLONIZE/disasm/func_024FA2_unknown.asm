; ============================================================================
; func_024FA2_unknown
; Region   : load_image
; Bytes    : file 0x024FA2..0x024FDF  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024FA2  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
024FA6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
024FAB  6A 7E                 PUSH   0x7e                         ; UNKNOWN
024FAD  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024FB0  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024FB3  9A F6 13 65 5F        LCALL  0x5f65, 0x13f6               ; UNKNOWN
024FB8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
024FBB  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
024FBE  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
024FC1  6A 7E                 PUSH   0x7e                         ; UNKNOWN
024FC3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024FC6  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024FC9  9A 1C 13 65 5F        LCALL  0x5f65, 0x131c               ; UNKNOWN
024FCE  83 C4 06              ADD    sp, 6                        ; UNKNOWN
024FD1  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
024FD4  75 05                 JNE    0x24fdb                      ; UNKNOWN
024FD6  3B 56 FC              CMP    dx, word ptr [bp - 4]        ; UNKNOWN
024FD9  74 21                 JE     0x24ffc                      ; UNKNOWN
024FDB  8E C2                 MOV    es, dx                       ; UNKNOWN
024FDD  8B D8                 MOV    bx, ax                       ; UNKNOWN
