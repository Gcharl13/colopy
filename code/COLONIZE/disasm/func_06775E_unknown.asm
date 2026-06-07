; ============================================================================
; func_06775E_unknown
; Region   : load_image
; Bytes    : file 0x06775E..0x067795  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06775E  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
067762  53                    PUSH   bx                           ; UNKNOWN
067763  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
067768  8B 47 06              MOV    ax, word ptr [bx + 6]        ; UNKNOWN
06776B  0B 47 04              OR     ax, word ptr [bx + 4]        ; UNKNOWN
06776E  74 10                 JE     0x67780                      ; UNKNOWN
067770  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
067773  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
067776  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
06777B  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
067780  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
067783  2B C0                 SUB    ax, ax                       ; UNKNOWN
067785  89 47 06              MOV    word ptr [bx + 6], ax        ; UNKNOWN
067788  89 47 04              MOV    word ptr [bx + 4], ax        ; UNKNOWN
06778B  89 47 02              MOV    word ptr [bx + 2], ax        ; UNKNOWN
06778E  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
067790  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
067793  C9                    LEAVE                               ; UNKNOWN
067794  CB                    RETF                                ; UNKNOWN
