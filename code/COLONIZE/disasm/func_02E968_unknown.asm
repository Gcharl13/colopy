; ============================================================================
; func_02E968_unknown
; Region   : load_image
; Bytes    : file 0x02E968..0x02E99D  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E968  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02E96C  2B C0                 SUB    ax, ax                       ; UNKNOWN
02E96E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E971  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E974  EB 15                 JMP    0x2e98b                      ; UNKNOWN
02E976  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E979  0E                    PUSH   cs                           ; UNKNOWN
02E97A  E8 A3 FA              CALL   0x2e420                      ; UNKNOWN
02E97D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E980  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E983  75 03                 JNE    0x2e988                      ; UNKNOWN
02E985  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02E988  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02E98B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E98F  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E992  98                    CWDE                                ; UNKNOWN
02E993  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
02E996  7F DE                 JG     0x2e976                      ; UNKNOWN
02E998  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E99B  C9                    LEAVE                               ; UNKNOWN
02E99C  CB                    RETF                                ; UNKNOWN
