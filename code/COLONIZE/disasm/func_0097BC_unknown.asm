; ============================================================================
; func_0097BC_unknown
; Region   : load_image
; Bytes    : file 0x0097BC..0x009816  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0097BC  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0097C0  50                    PUSH   ax                           ; UNKNOWN
0097C1  53                    PUSH   bx                           ; UNKNOWN
0097C2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0097C7  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
0097C9  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
0097CC  74 18                 JE     0x97e6                       ; UNKNOWN
0097CE  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
0097D1  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0097D4  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
0097D6  38 07                 CMP    byte ptr [bx], al            ; UNKNOWN
0097D8  74 0C                 JE     0x97e6                       ; UNKNOWN
0097DA  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0097DD  FF 07                 INC    word ptr [bx]                ; UNKNOWN
0097DF  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
0097E1  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
0097E4  75 E8                 JNE    0x97ce                       ; UNKNOWN
0097E6  80 7E FC 00           CMP    byte ptr [bp - 4], 0         ; UNKNOWN
0097EA  74 16                 JE     0x9802                       ; UNKNOWN
0097EC  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
0097EF  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0097F2  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
0097F4  38 07                 CMP    byte ptr [bx], al            ; UNKNOWN
0097F6  75 0A                 JNE    0x9802                       ; UNKNOWN
0097F8  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0097FB  FF 07                 INC    word ptr [bx]                ; UNKNOWN
0097FD  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
009802  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
009805  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
009807  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
00980A  75 05                 JNE    0x9811                       ; UNKNOWN
00980C  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00980F  FF 0F                 DEC    word ptr [bx]                ; UNKNOWN
009811  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
009814  C9                    LEAVE                               ; UNKNOWN
009815  CB                    RETF                                ; UNKNOWN
