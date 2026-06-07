; ============================================================================
; func_041DDB_unknown
; Region   : load_image
; Bytes    : file 0x041DDB..0x041E70  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041DDB  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
041DDF  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
041DE3  7F 03                 JG     0x41de8                      ; UNKNOWN
041DE5  E9 86 00              JMP    0x41e6e                      ; UNKNOWN
041DE8  83 46 0A 02           ADD    word ptr [bp + 0xa], 2       ; UNKNOWN
041DEC  6A 0A                 PUSH   0xa                          ; UNKNOWN
041DEE  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
041DF1  50                    PUSH   ax                           ; UNKNOWN
041DF2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041DF5  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
041DFA  83 C4 06              ADD    sp, 6                        ; UNKNOWN
041DFD  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
041E01  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
041E05  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
041E08  16                    PUSH   ss                           ; UNKNOWN
041E09  50                    PUSH   ax                           ; UNKNOWN
041E0A  2B C0                 SUB    ax, ax                       ; UNKNOWN
041E0C  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
041E11  48                    DEC    ax                           ; UNKNOWN
041E12  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041E15  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
041E19  74 23                 JE     0x41e3e                      ; UNKNOWN
041E1B  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
041E1F  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
041E23  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
041E27  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
041E2B  6A 07                 PUSH   7                            ; UNKNOWN
041E2D  6A 00                 PUSH   0                            ; UNKNOWN
041E2F  8B D8                 MOV    bx, ax                       ; UNKNOWN
041E31  43                    INC    bx                           ; UNKNOWN
041E32  43                    INC    bx                           ; UNKNOWN
041E33  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
041E36  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
041E39  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
041E3E  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041E41  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
041E44  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
041E47  8B DA                 MOV    bx, dx                       ; UNKNOWN
041E49  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
041E4E  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
041E52  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
041E56  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
041E59  16                    PUSH   ss                           ; UNKNOWN
041E5A  50                    PUSH   ax                           ; UNKNOWN
041E5B  6A 00                 PUSH   0                            ; UNKNOWN
041E5D  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
041E60  40                    INC    ax                           ; UNKNOWN
041E61  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
041E64  42                    INC    dx                           ; UNKNOWN
041E65  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
041E69  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
041E6E  C9                    LEAVE                               ; UNKNOWN
041E6F  CB                    RETF                                ; UNKNOWN
