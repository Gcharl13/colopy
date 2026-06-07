; ============================================================================
; func_0430DF_unknown
; Region   : load_image
; Bytes    : file 0x0430DF..0x0431A5  (198 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0430DF  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
0430E3  57                    PUSH   di                           ; UNKNOWN
0430E4  56                    PUSH   si                           ; UNKNOWN
0430E5  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
0430E8  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0430EB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0430EE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0430F1  0B FF                 OR     di, di                       ; UNKNOWN
0430F3  74 06                 JE     0x430fb                      ; UNKNOWN
0430F5  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0430F9  75 1F                 JNE    0x4311a                      ; UNKNOWN
0430FB  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0430FF  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
043103  2A E4                 SUB    ah, ah                       ; UNKNOWN
043105  50                    PUSH   ax                           ; UNKNOWN
043106  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04310A  50                    PUSH   ax                           ; UNKNOWN
04310B  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
043110  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043113  0B C0                 OR     ax, ax                       ; UNKNOWN
043115  7C 03                 JL     0x4311a                      ; UNKNOWN
043117  E9 82 00              JMP    0x4319c                      ; UNKNOWN
04311A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04311D  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
043122  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
043125  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04312A  0B C0                 OR     ax, ax                       ; UNKNOWN
04312C  7C 05                 JL     0x43133                      ; UNKNOWN
04312E  B8 01 00              MOV    ax, 1                        ; UNKNOWN
043131  EB 02                 JMP    0x43135                      ; UNKNOWN
043133  2B C0                 SUB    ax, ax                       ; UNKNOWN
043135  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
043138  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
04313A  0B FF                 OR     di, di                       ; UNKNOWN
04313C  75 51                 JNE    0x4318f                      ; UNKNOWN
04313E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
043141  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
043144  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
043147  0B F6                 OR     si, si                       ; UNKNOWN
043149  7C 4C                 JL     0x43197                      ; UNKNOWN
04314B  8B 7E FC              MOV    di, word ptr [bp - 4]        ; UNKNOWN
04314E  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
043151  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
043155  3C 0D                 CMP    al, 0xd                      ; UNKNOWN
043157  72 06                 JB     0x4315f                      ; UNKNOWN
043159  3C 11                 CMP    al, 0x11                     ; UNKNOWN
04315B  77 02                 JA     0x4315f                      ; UNKNOWN
04315D  8B FE                 MOV    di, si                       ; UNKNOWN
04315F  8B C6                 MOV    ax, si                       ; UNKNOWN
043161  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
043166  8B F0                 MOV    si, ax                       ; UNKNOWN
043168  0B F6                 OR     si, si                       ; UNKNOWN
04316A  7D E2                 JGE    0x4314e                      ; UNKNOWN
04316C  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
043170  74 14                 JE     0x43186                      ; UNKNOWN
043172  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
043176  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
04317A  3C 0D                 CMP    al, 0xd                      ; UNKNOWN
04317C  72 04                 JB     0x43182                      ; UNKNOWN
04317E  3C 11                 CMP    al, 0x11                     ; UNKNOWN
043180  76 1A                 JBE    0x4319c                      ; UNKNOWN
043182  0B FF                 OR     di, di                       ; UNKNOWN
043184  7C 16                 JL     0x4319c                      ; UNKNOWN
043186  0B FF                 OR     di, di                       ; UNKNOWN
043188  7C 1B                 JL     0x431a5                      ; UNKNOWN
04318A  6B DF 1C              IMUL   bx, di, 0x1c                 ; UNKNOWN
04318D  EB 1A                 JMP    0x431a9                      ; UNKNOWN
04318F  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
043193  74 AF                 JE     0x43144                      ; UNKNOWN
043195  EB 0E                 JMP    0x431a5                      ; UNKNOWN
043197  8B 7E FC              MOV    di, word ptr [bp - 4]        ; UNKNOWN
04319A  EB D0                 JMP    0x4316c                      ; UNKNOWN
04319C  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
04319F  8B C6                 MOV    ax, si                       ; UNKNOWN
0431A1  5E                    POP    si                           ; UNKNOWN
0431A2  5F                    POP    di                           ; UNKNOWN
0431A3  C9                    LEAVE                               ; UNKNOWN
0431A4  CB                    RETF                                ; UNKNOWN
