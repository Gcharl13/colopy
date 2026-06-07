; ============================================================================
; func_00ED86_unknown
; Region   : load_image
; Bytes    : file 0x00ED86..0x00EE02  (124 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00ED86  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
00ED8A  53                    PUSH   bx                           ; UNKNOWN
00ED8B  52                    PUSH   dx                           ; UNKNOWN
00ED8C  50                    PUSH   ax                           ; UNKNOWN
00ED8D  57                    PUSH   di                           ; UNKNOWN
00ED8E  56                    PUSH   si                           ; UNKNOWN
00ED8F  6A 0A                 PUSH   0xa                          ; UNKNOWN
00ED91  8D 4E D8              LEA    cx, [bp - 0x28]              ; UNKNOWN
00ED94  51                    PUSH   cx                           ; UNKNOWN
00ED95  50                    PUSH   ax                           ; UNKNOWN
00ED96  8B F0                 MOV    si, ax                       ; UNKNOWN
00ED98  8B FA                 MOV    di, dx                       ; UNKNOWN
00ED9A  89 5E 96              MOV    word ptr [bp - 0x6a], bx     ; UNKNOWN
00ED9D  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
00EDA2  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00EDA5  6A 0A                 PUSH   0xa                          ; UNKNOWN
00EDA7  8B C5                 MOV    ax, bp                       ; UNKNOWN
00EDA9  50                    PUSH   ax                           ; UNKNOWN
00EDAA  FF 76 96              PUSH   word ptr [bp - 0x6a]         ; UNKNOWN
00EDAD  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
00EDB2  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00EDB5  6A 0A                 PUSH   0xa                          ; UNKNOWN
00EDB7  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
00EDBA  50                    PUSH   ax                           ; UNKNOWN
00EDBB  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
00EDBE  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
00EDC1  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
00EDC6  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00EDC9  6A 0A                 PUSH   0xa                          ; UNKNOWN
00EDCB  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
00EDCE  50                    PUSH   ax                           ; UNKNOWN
00EDCF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00EDD2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00EDD5  9A A6 08 65 5F        LCALL  0x5f65, 0x8a6                ; UNKNOWN
00EDDA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00EDDD  8B D6                 MOV    dx, si                       ; UNKNOWN
00EDDF  F7 D2                 NOT    dx                           ; UNKNOWN
00EDE1  42                    INC    dx                           ; UNKNOWN
00EDE2  8D 5E D8              LEA    bx, [bp - 0x28]              ; UNKNOWN
00EDE5  8D 06 B3 06           LEA    ax, [0x6b3]                  ; UNKNOWN
00EDE9  E8 42 FD              CALL   0xeb2e                       ; UNKNOWN
00EDEC  8B DD                 MOV    bx, bp                       ; UNKNOWN
00EDEE  8D 06 BE 06           LEA    ax, [0x6be]                  ; UNKNOWN
00EDF2  8B 56 96              MOV    dx, word ptr [bp - 0x6a]     ; UNKNOWN
00EDF5  E8 36 FD              CALL   0xeb2e                       ; UNKNOWN
00EDF8  3B 3E DE 05           CMP    di, word ptr [0x5de]         ; UNKNOWN
00EDFC  7D 2C                 JGE    0xee2a                       ; UNKNOWN
00EDFE  68 CA 06              PUSH   0x6ca                        ; UNKNOWN
00EE01  9A                    DB     0x9A                         ; UNKNOWN (raw)
