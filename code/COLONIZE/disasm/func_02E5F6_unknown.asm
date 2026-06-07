; ============================================================================
; func_02E5F6_unknown
; Region   : load_image
; Bytes    : file 0x02E5F6..0x02E622  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E5F6  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02E5FA  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
02E5FD  80 E1 07              AND    cl, 7                        ; UNKNOWN
02E600  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02E603  D3 E0                 SHL    ax, cl                       ; UNKNOWN
02E605  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E608  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
02E60B  C1 F9 03              SAR    cx, 3                        ; UNKNOWN
02E60E  03 0E 38 73           ADD    cx, word ptr [0x7338]        ; UNKNOWN
02E612  81 C1 84 00           ADD    cx, 0x84                     ; UNKNOWN
02E616  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02E61A  74 06                 JE     0x2e622                      ; UNKNOWN
02E61C  8B D9                 MOV    bx, cx                       ; UNKNOWN
02E61E  08 07                 OR     byte ptr [bx], al            ; UNKNOWN
02E620  C9                    LEAVE                               ; UNKNOWN
02E621  CB                    RETF                                ; UNKNOWN
