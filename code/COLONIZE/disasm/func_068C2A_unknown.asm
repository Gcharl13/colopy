; ============================================================================
; func_068C2A_unknown
; Region   : load_image
; Bytes    : file 0x068C2A..0x068C68  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068C2A  55                    PUSH   bp                           ; UNKNOWN
068C2B  8B EC                 MOV    bp, sp                       ; UNKNOWN
068C2D  83 EC 04              SUB    sp, 4                        ; UNKNOWN
068C30  57                    PUSH   di                           ; UNKNOWN
068C31  56                    PUSH   si                           ; UNKNOWN
068C32  BE 80 12              MOV    si, 0x1280                   ; UNKNOWN
068C35  56                    PUSH   si                           ; UNKNOWN
068C36  E8 07 15              CALL   0x6a140                      ; UNKNOWN
068C39  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068C3C  8B F8                 MOV    di, ax                       ; UNKNOWN
068C3E  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
068C41  50                    PUSH   ax                           ; UNKNOWN
068C42  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
068C45  B8 80 12              MOV    ax, 0x1280                   ; UNKNOWN
068C48  50                    PUSH   ax                           ; UNKNOWN
068C49  9A B2 1B 65 5F        LCALL  0x5f65, 0x1bb2               ; UNKNOWN
068C4E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
068C51  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068C54  B8 80 12              MOV    ax, 0x1280                   ; UNKNOWN
068C57  50                    PUSH   ax                           ; UNKNOWN
068C58  57                    PUSH   di                           ; UNKNOWN
068C59  E8 57 15              CALL   0x6a1b3                      ; UNKNOWN
068C5C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
068C5F  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
068C62  5E                    POP    si                           ; UNKNOWN
068C63  5F                    POP    di                           ; UNKNOWN
068C64  8B E5                 MOV    sp, bp                       ; UNKNOWN
068C66  5D                    POP    bp                           ; UNKNOWN
068C67  CB                    RETF                                ; UNKNOWN
