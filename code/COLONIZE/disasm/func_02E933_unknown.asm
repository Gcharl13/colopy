; ============================================================================
; func_02E933_unknown
; Region   : load_image
; Bytes    : file 0x02E933..0x02E968  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E933  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02E937  2B C0                 SUB    ax, ax                       ; UNKNOWN
02E939  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E93C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E93F  EB 15                 JMP    0x2e956                      ; UNKNOWN
02E941  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E944  0E                    PUSH   cs                           ; UNKNOWN
02E945  E8 9F FA              CALL   0x2e3e7                      ; UNKNOWN
02E948  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E94B  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E94E  75 03                 JNE    0x2e953                      ; UNKNOWN
02E950  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02E953  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02E956  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E95A  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E95D  98                    CWDE                                ; UNKNOWN
02E95E  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
02E961  7F DE                 JG     0x2e941                      ; UNKNOWN
02E963  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E966  C9                    LEAVE                               ; UNKNOWN
02E967  CB                    RETF                                ; UNKNOWN
