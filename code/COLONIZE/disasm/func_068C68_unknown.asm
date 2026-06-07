; ============================================================================
; func_068C68_unknown
; Region   : load_image
; Bytes    : file 0x068C68..0x068CDC  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068C68  55                    PUSH   bp                           ; UNKNOWN
068C69  8B EC                 MOV    bp, sp                       ; UNKNOWN
068C6B  83 EC 02              SUB    sp, 2                        ; UNKNOWN
068C6E  57                    PUSH   di                           ; UNKNOWN
068C6F  56                    PUSH   si                           ; UNKNOWN
068C70  2B FF                 SUB    di, di                       ; UNKNOWN
068C72  39 7E 06              CMP    word ptr [bp + 6], di        ; UNKNOWN
068C75  75 09                 JNE    0x68c80                      ; UNKNOWN
068C77  2B C0                 SUB    ax, ax                       ; UNKNOWN
068C79  50                    PUSH   ax                           ; UNKNOWN
068C7A  E8 67 00              CALL   0x68ce4                      ; UNKNOWN
068C7D  EB 57                 JMP    0x68cd6                      ; UNKNOWN
068C7F  90                    NOP                                 ; UNKNOWN
068C80  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
068C83  8A 44 06              MOV    al, byte ptr [si + 6]        ; UNKNOWN
068C86  8B C8                 MOV    cx, ax                       ; UNKNOWN
068C88  24 03                 AND    al, 3                        ; UNKNOWN
068C8A  3C 02                 CMP    al, 2                        ; UNKNOWN
068C8C  75 3C                 JNE    0x68cca                      ; UNKNOWN
068C8E  F6 C1 08              TEST   cl, 8                        ; UNKNOWN
068C91  75 0D                 JNE    0x68ca0                      ; UNKNOWN
068C93  8B DE                 MOV    bx, si                       ; UNKNOWN
068C95  81 EB 78 12           SUB    bx, 0x1278                   ; UNKNOWN
068C99  F6 87 18 13 01        TEST   byte ptr [bx + 0x1318], 1    ; UNKNOWN
068C9E  74 2A                 JE     0x68cca                      ; UNKNOWN
068CA0  8B 04                 MOV    ax, word ptr [si]            ; UNKNOWN
068CA2  2B 44 04              SUB    ax, word ptr [si + 4]        ; UNKNOWN
068CA5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
068CA8  0B C0                 OR     ax, ax                       ; UNKNOWN
068CAA  7E 1E                 JLE    0x68cca                      ; UNKNOWN
068CAC  50                    PUSH   ax                           ; UNKNOWN
068CAD  FF 74 04              PUSH   word ptr [si + 4]            ; UNKNOWN
068CB0  8A 4C 07              MOV    cl, byte ptr [si + 7]        ; UNKNOWN
068CB3  2A ED                 SUB    ch, ch                       ; UNKNOWN
068CB5  51                    PUSH   cx                           ; UNKNOWN
068CB6  9A 42 22 65 5F        LCALL  0x5f65, 0x2242               ; UNKNOWN
068CBB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
068CBE  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
068CC1  74 07                 JE     0x68cca                      ; UNKNOWN
068CC3  80 4C 06 20           OR     byte ptr [si + 6], 0x20      ; UNKNOWN
068CC7  BF FF FF              MOV    di, 0xffff                   ; UNKNOWN
068CCA  8B 44 04              MOV    ax, word ptr [si + 4]        ; UNKNOWN
068CCD  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
068CCF  C7 44 02 00 00        MOV    word ptr [si + 2], 0         ; UNKNOWN
068CD4  8B C7                 MOV    ax, di                       ; UNKNOWN
068CD6  5E                    POP    si                           ; UNKNOWN
068CD7  5F                    POP    di                           ; UNKNOWN
068CD8  8B E5                 MOV    sp, bp                       ; UNKNOWN
068CDA  5D                    POP    bp                           ; UNKNOWN
068CDB  CB                    RETF                                ; UNKNOWN
