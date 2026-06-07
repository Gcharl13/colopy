; ============================================================================
; func_033B60_unknown
; Region   : load_image
; Bytes    : file 0x033B60..0x033BF6  (150 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033B60  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
033B64  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
033B67  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
033B6A  2B C9                 SUB    cx, cx                       ; UNKNOWN
033B6C  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
033B6F  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033B72  89 0F                 MOV    word ptr [bx], cx            ; UNKNOWN
033B74  83 F8 04              CMP    ax, 4                        ; UNKNOWN
033B77  7D 05                 JGE    0x33b7e                      ; UNKNOWN
033B79  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
033B7C  EB 2A                 JMP    0x33ba8                      ; UNKNOWN
033B7E  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033B81  FF 07                 INC    word ptr [bx]                ; UNKNOWN
033B83  83 6E FE 04           SUB    word ptr [bp - 2], 4         ; UNKNOWN
033B87  83 7E FE 08           CMP    word ptr [bp - 2], 8         ; UNKNOWN
033B8B  7D 05                 JGE    0x33b92                      ; UNKNOWN
033B8D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
033B90  EB E7                 JMP    0x33b79                      ; UNKNOWN
033B92  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033B95  FF 07                 INC    word ptr [bx]                ; UNKNOWN
033B97  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
033B9A  83 6E FE 08           SUB    word ptr [bp - 2], 8         ; UNKNOWN
033B9E  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
033BA1  7C EA                 JL     0x33b8d                      ; UNKNOWN
033BA3  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033BA6  FF 07                 INC    word ptr [bx]                ; UNKNOWN
033BA8  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033BAB  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
033BAD  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
033BB0  D3 F8                 SAR    ax, cl                       ; UNKNOWN
033BB2  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
033BB5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
033BB8  83 3F 00              CMP    word ptr [bx], 0             ; UNKNOWN
033BBB  75 06                 JNE    0x33bc3                      ; UNKNOWN
033BBD  03 46 0C              ADD    ax, word ptr [bp + 0xc]      ; UNKNOWN
033BC0  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
033BC3  83 3F 02              CMP    word ptr [bx], 2             ; UNKNOWN
033BC6  75 03                 JNE    0x33bcb                      ; UNKNOWN
033BC8  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
033BCB  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
033BCE  8B 5E 16              MOV    bx, word ptr [bp + 0x16]     ; UNKNOWN
033BD1  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
033BD3  8B 5E 14              MOV    bx, word ptr [bp + 0x14]     ; UNKNOWN
033BD6  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
033BD8  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
033BDB  F7 6E FC              IMUL   word ptr [bp - 4]            ; UNKNOWN
033BDE  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
033BE1  8B 5E 10              MOV    bx, word ptr [bp + 0x10]     ; UNKNOWN
033BE4  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
033BE6  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033BE9  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
033BEB  EB 31                 JMP    0x33c1e                      ; UNKNOWN
033BED  8B 5E 12              MOV    bx, word ptr [bp + 0x12]     ; UNKNOWN
033BF0  C7 07 92 00           MOV    word ptr [bx], 0x92          ; UNKNOWN
033BF4  C9                    LEAVE                               ; UNKNOWN
033BF5  CB                    RETF                                ; UNKNOWN
