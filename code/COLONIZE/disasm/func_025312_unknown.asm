; ============================================================================
; func_025312_unknown
; Region   : load_image
; Bytes    : file 0x025312..0x025339  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025312  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
025316  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
025319  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02531C  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
02531F  0E                    PUSH   cs                           ; UNKNOWN
025320  E8 D5 FE              CALL   0x251f8                      ; UNKNOWN
025323  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
025326  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
025329  0B D0                 OR     dx, ax                       ; UNKNOWN
02532B  74 0A                 JE     0x25337                      ; UNKNOWN
02532D  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
025330  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
025333  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
025337  C9                    LEAVE                               ; UNKNOWN
025338  CB                    RETF                                ; UNKNOWN
