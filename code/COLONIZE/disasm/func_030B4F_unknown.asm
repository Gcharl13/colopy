; ============================================================================
; func_030B4F_unknown
; Region   : load_image
; Bytes    : file 0x030B4F..0x030B9F  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030B4F  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
030B53  56                    PUSH   si                           ; UNKNOWN
030B54  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
030B57  D1 E6                 SHL    si, 1                        ; UNKNOWN
030B59  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030B5D  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; UNKNOWN
030B61  83 F8 64              CMP    ax, 0x64                     ; UNKNOWN
030B64  7E 03                 JLE    0x30b69                      ; UNKNOWN
030B66  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
030B69  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
030B6C  7E 03                 JLE    0x30b71                      ; UNKNOWN
030B6E  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
030B71  A3 84 73              MOV    word ptr [0x7384], ax        ; UNKNOWN
030B74  29 80 9A 00           SUB    word ptr [bx + si + 0x9a], ax ; UNKNOWN
030B78  FF 36 84 73           PUSH   word ptr [0x7384]            ; UNKNOWN
030B7C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
030B7F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030B82  0E                    PUSH   cs                           ; UNKNOWN
030B83  E8 BF FA              CALL   0x30645                      ; UNKNOWN
030B86  83 C4 06              ADD    sp, 6                        ; UNKNOWN
030B89  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
030B8D  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
030B92  74 05                 JE     0x30b99                      ; UNKNOWN
030B94  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
030B99  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
030B9C  5E                    POP    si                           ; UNKNOWN
030B9D  C9                    LEAVE                               ; UNKNOWN
030B9E  CB                    RETF                                ; UNKNOWN
