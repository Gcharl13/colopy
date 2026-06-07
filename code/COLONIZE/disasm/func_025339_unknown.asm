; ============================================================================
; func_025339_unknown
; Region   : load_image
; Bytes    : file 0x025339..0x025356  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025339  55                    PUSH   bp                           ; UNKNOWN
02533A  8B EC                 MOV    bp, sp                       ; UNKNOWN
02533C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02533F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
025342  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
025345  0E                    PUSH   cs                           ; UNKNOWN
025346  E8 AF FE              CALL   0x251f8                      ; UNKNOWN
025349  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02534C  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax  ; UNKNOWN
025350  26 89 57 4E           MOV    word ptr es:[bx + 0x4e], dx  ; UNKNOWN
025354  C9                    LEAVE                               ; UNKNOWN
025355  CB                    RETF                                ; UNKNOWN
