; ============================================================================
; func_02E99D_unknown
; Region   : load_image
; Bytes    : file 0x02E99D..0x02E9E0  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E99D  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02E9A1  2B C0                 SUB    ax, ax                       ; UNKNOWN
02E9A3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E9A6  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E9A9  EB 28                 JMP    0x2e9d3                      ; UNKNOWN
02E9AB  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E9AE  0E                    PUSH   cs                           ; UNKNOWN
02E9AF  E8 6E FA              CALL   0x2e420                      ; UNKNOWN
02E9B2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E9B5  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02E9B8  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E9BB  0E                    PUSH   cs                           ; UNKNOWN
02E9BC  E8 28 FA              CALL   0x2e3e7                      ; UNKNOWN
02E9BF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E9C2  83 7E F8 13           CMP    word ptr [bp - 8], 0x13      ; UNKNOWN
02E9C6  7D 08                 JGE    0x2e9d0                      ; UNKNOWN
02E9C8  39 46 F8              CMP    word ptr [bp - 8], ax        ; UNKNOWN
02E9CB  75 03                 JNE    0x2e9d0                      ; UNKNOWN
02E9CD  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02E9D0  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02E9D3  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E9D7  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E9DA  98                    CWDE                                ; UNKNOWN
02E9DB  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
02E9DE  7F CB                 JG     0x2e9ab                      ; UNKNOWN
