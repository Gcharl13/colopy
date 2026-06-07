; ============================================================================
; func_0092E0_unknown
; Region   : load_image
; Bytes    : file 0x0092E0..0x00930C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0092E0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0092E4  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
0092E7  80 E1 07              AND    cl, 7                        ; UNKNOWN
0092EA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0092ED  D3 E0                 SHL    ax, cl                       ; UNKNOWN
0092EF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0092F2  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
0092F5  C1 F9 03              SAR    cx, 3                        ; UNKNOWN
0092F8  03 0E 42 85           ADD    cx, word ptr [0x8542]        ; UNKNOWN
0092FC  81 C1 84 00           ADD    cx, 0x84                     ; UNKNOWN
009300  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
009304  74 06                 JE     0x930c                       ; UNKNOWN
009306  8B D9                 MOV    bx, cx                       ; UNKNOWN
009308  08 07                 OR     byte ptr [bx], al            ; UNKNOWN
00930A  C9                    LEAVE                               ; UNKNOWN
00930B  CB                    RETF                                ; UNKNOWN
