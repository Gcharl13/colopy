; ============================================================================
; func_02E9E5_unknown
; Region   : load_image
; Bytes    : file 0x02E9E5..0x02EA2F  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E9E5  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02E9E9  56                    PUSH   si                           ; UNKNOWN
02E9EA  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02E9ED  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02E9F0  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E9F3  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02E9F8  EB 29                 JMP    0x2ea23                      ; UNKNOWN
02E9FA  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E9FE  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02EA01  98                    CWDE                                ; UNKNOWN
02EA02  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
02EA05  7E 22                 JLE    0x2ea29                      ; UNKNOWN
02EA07  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02EA0A  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
02EA0D  38 40 20              CMP    byte ptr [bx + si + 0x20], al ; UNKNOWN
02EA10  75 0E                 JNE    0x2ea20                      ; UNKNOWN
02EA12  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02EA15  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02EA18  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
02EA1B  75 03                 JNE    0x2ea20                      ; UNKNOWN
02EA1D  89 76 FA              MOV    word ptr [bp - 6], si        ; UNKNOWN
02EA20  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02EA23  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
02EA27  7C D1                 JL     0x2e9fa                      ; UNKNOWN
02EA29  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02EA2C  5E                    POP    si                           ; UNKNOWN
02EA2D  C9                    LEAVE                               ; UNKNOWN
02EA2E  CB                    RETF                                ; UNKNOWN
