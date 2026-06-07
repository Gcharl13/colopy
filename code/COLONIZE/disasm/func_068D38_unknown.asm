; ============================================================================
; func_068D38_unknown
; Region   : load_image
; Bytes    : file 0x068D38..0x068D5D  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068D38  55                    PUSH   bp                           ; UNKNOWN
068D39  8B EC                 MOV    bp, sp                       ; UNKNOWN
068D3B  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
068D3E  FF 4F 02              DEC    word ptr [bx + 2]            ; UNKNOWN
068D41  78 0E                 JS     0x68d51                      ; UNKNOWN
068D43  FF 07                 INC    word ptr [bx]                ; UNKNOWN
068D45  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
068D47  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
068D4A  88 47 FF              MOV    byte ptr [bx - 1], al        ; UNKNOWN
068D4D  32 E4                 XOR    ah, ah                       ; UNKNOWN
068D4F  EB 0A                 JMP    0x68d5b                      ; UNKNOWN
068D51  53                    PUSH   bx                           ; UNKNOWN
068D52  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
068D55  0E                    PUSH   cs                           ; UNKNOWN
068D56  E8 EF 11              CALL   0x69f48                      ; UNKNOWN
068D59  5B                    POP    bx                           ; UNKNOWN
068D5A  5B                    POP    bx                           ; UNKNOWN
068D5B  5D                    POP    bp                           ; UNKNOWN
068D5C  CB                    RETF                                ; UNKNOWN
