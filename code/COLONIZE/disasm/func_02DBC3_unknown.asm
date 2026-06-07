; ============================================================================
; func_02DBC3_unknown
; Region   : load_image
; Bytes    : file 0x02DBC3..0x02DC01  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DBC3  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02DBC7  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02DBCC  83 6E 06 02           SUB    word ptr [bp + 6], 2         ; UNKNOWN
02DBD0  83 6E 08 02           SUB    word ptr [bp + 8], 2         ; UNKNOWN
02DBD4  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02DBD9  EB 03                 JMP    0x2dbde                      ; UNKNOWN
02DBDB  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02DBDE  83 7E FC 14           CMP    word ptr [bp - 4], 0x14      ; UNKNOWN
02DBE2  7D 18                 JGE    0x2dbfc                      ; UNKNOWN
02DBE4  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02DBE7  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
02DBEA  38 87 38 09           CMP    byte ptr [bx + 0x938], al    ; UNKNOWN
02DBEE  75 EB                 JNE    0x2dbdb                      ; UNKNOWN
02DBF0  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
02DBF3  38 87 4D 09           CMP    byte ptr [bx + 0x94d], al    ; UNKNOWN
02DBF7  75 E2                 JNE    0x2dbdb                      ; UNKNOWN
02DBF9  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
02DBFC  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DBFF  C9                    LEAVE                               ; UNKNOWN
02DC00  CB                    RETF                                ; UNKNOWN
