; ============================================================================
; func_02D912_unknown
; Region   : load_image
; Bytes    : file 0x02D912..0x02D93E  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D912  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02D916  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
02D919  80 E1 07              AND    cl, 7                        ; UNKNOWN
02D91C  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02D91F  D3 E0                 SHL    ax, cl                       ; UNKNOWN
02D921  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02D924  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
02D927  C1 F9 03              SAR    cx, 3                        ; UNKNOWN
02D92A  03 0E 38 73           ADD    cx, word ptr [0x7338]        ; UNKNOWN
02D92E  81 C1 8A 00           ADD    cx, 0x8a                     ; UNKNOWN
02D932  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02D936  74 06                 JE     0x2d93e                      ; UNKNOWN
02D938  8B D9                 MOV    bx, cx                       ; UNKNOWN
02D93A  08 07                 OR     byte ptr [bx], al            ; UNKNOWN
02D93C  C9                    LEAVE                               ; UNKNOWN
02D93D  CB                    RETF                                ; UNKNOWN
