; ============================================================================
; func_0413A9_unknown
; Region   : load_image
; Bytes    : file 0x0413A9..0x04145F  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0413A9  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
0413AD  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0413B2  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0413B5  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
0413B8  7E 03                 JLE    0x413bd                      ; UNKNOWN
0413BA  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0413BD  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
0413C0  3B 4E 06              CMP    cx, word ptr [bp + 6]        ; UNKNOWN
0413C3  7D 03                 JGE    0x413c8                      ; UNKNOWN
0413C5  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
0413C8  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
0413CB  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
0413CE  3B 4E 08              CMP    cx, word ptr [bp + 8]        ; UNKNOWN
0413D1  7E 03                 JLE    0x413d6                      ; UNKNOWN
0413D3  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
0413D6  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
0413D9  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
0413DC  3B 4E 08              CMP    cx, word ptr [bp + 8]        ; UNKNOWN
0413DF  7D 03                 JGE    0x413e4                      ; UNKNOWN
0413E1  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
0413E4  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
0413E7  8B 0E 80 82           MOV    cx, word ptr [0x8280]        ; UNKNOWN
0413EB  41                    INC    cx                           ; UNKNOWN
0413EC  41                    INC    cx                           ; UNKNOWN
0413ED  3B C1                 CMP    ax, cx                       ; UNKNOWN
0413EF  7D 0C                 JGE    0x413fd                      ; UNKNOWN
0413F1  83 3E 80 82 01        CMP    word ptr [0x8280], 1         ; UNKNOWN
0413F6  7E 05                 JLE    0x413fd                      ; UNKNOWN
0413F8  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0413FD  A1 86 82              MOV    ax, word ptr [0x8286]        ; UNKNOWN
041400  40                    INC    ax                           ; UNKNOWN
041401  40                    INC    ax                           ; UNKNOWN
041402  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
041405  7E 0C                 JLE    0x41413                      ; UNKNOWN
041407  83 3E 86 82 01        CMP    word ptr [0x8286], 1         ; UNKNOWN
04140C  7E 05                 JLE    0x41413                      ; UNKNOWN
04140E  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
041413  A1 50 85              MOV    ax, word ptr [0x8550]        ; UNKNOWN
041416  48                    DEC    ax                           ; UNKNOWN
041417  48                    DEC    ax                           ; UNKNOWN
041418  3B 46 F8              CMP    ax, word ptr [bp - 8]        ; UNKNOWN
04141B  7D 10                 JGE    0x4142d                      ; UNKNOWN
04141D  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
041420  48                    DEC    ax                           ; UNKNOWN
041421  48                    DEC    ax                           ; UNKNOWN
041422  3B 06 50 85           CMP    ax, word ptr [0x8550]        ; UNKNOWN
041426  7E 05                 JLE    0x4142d                      ; UNKNOWN
041428  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04142D  A1 52 85              MOV    ax, word ptr [0x8552]        ; UNKNOWN
041430  48                    DEC    ax                           ; UNKNOWN
041431  48                    DEC    ax                           ; UNKNOWN
041432  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
041435  7D 10                 JGE    0x41447                      ; UNKNOWN
041437  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
04143A  48                    DEC    ax                           ; UNKNOWN
04143B  48                    DEC    ax                           ; UNKNOWN
04143C  3B 06 52 85           CMP    ax, word ptr [0x8552]        ; UNKNOWN
041440  7E 05                 JLE    0x41447                      ; UNKNOWN
041442  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
041447  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04144B  74 0D                 JE     0x4145a                      ; UNKNOWN
04144D  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
041450  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041453  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041456  0E                    PUSH   cs                           ; UNKNOWN
041457  E8 F2 FE              CALL   0x4134c                      ; UNKNOWN
04145A  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04145D  C9                    LEAVE                               ; UNKNOWN
04145E  CB                    RETF                                ; UNKNOWN
