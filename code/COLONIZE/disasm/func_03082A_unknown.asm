; ============================================================================
; func_03082A_unknown
; Region   : load_image
; Bytes    : file 0x03082A..0x030882  (88 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03082A  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03082E  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
030833  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
030838  EB 2A                 JMP    0x30864                      ; UNKNOWN
03083A  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
03083E  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
030842  2A E4                 SUB    ah, ah                       ; UNKNOWN
030844  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
030847  7E 21                 JLE    0x3086a                      ; UNKNOWN
030849  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03084C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03084F  0E                    PUSH   cs                           ; UNKNOWN
030850  E8 2F FD              CALL   0x30582                      ; UNKNOWN
030853  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030856  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
030859  75 06                 JNE    0x30861                      ; UNKNOWN
03085B  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03085E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030861  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
030864  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
030868  7C D0                 JL     0x3083a                      ; UNKNOWN
03086A  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
03086E  7C 0D                 JL     0x3087d                      ; UNKNOWN
030870  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030873  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030876  0E                    PUSH   cs                           ; UNKNOWN
030877  E8 55 FD              CALL   0x305cf                      ; UNKNOWN
03087A  A3 84 73              MOV    word ptr [0x7384], ax        ; UNKNOWN
03087D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
030880  C9                    LEAVE                               ; UNKNOWN
030881  CB                    RETF                                ; UNKNOWN
