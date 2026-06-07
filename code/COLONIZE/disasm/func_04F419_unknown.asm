; ============================================================================
; func_04F419_unknown
; Region   : load_image
; Bytes    : file 0x04F419..0x04F4A2  (137 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F419  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F41D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F420  9A 9C 10 B7 36        LCALL  0x36b7, 0x109c               ; UNKNOWN
04F425  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F428  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F42C  8A 87 8A 88           MOV    al, byte ptr [bx - 0x7776]   ; UNKNOWN
04F430  2A E4                 SUB    ah, ah                       ; UNKNOWN
04F432  50                    PUSH   ax                           ; UNKNOWN
04F433  8A 87 89 88           MOV    al, byte ptr [bx - 0x7777]   ; UNKNOWN
04F437  50                    PUSH   ax                           ; UNKNOWN
04F438  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F43B  0E                    PUSH   cs                           ; UNKNOWN
04F43C  E8 9B FC              CALL   0x4f0da                      ; UNKNOWN
04F43F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04F442  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F445  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04F448  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
04F44D  EB 32                 JMP    0x4f481                      ; UNKNOWN
04F44F  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
04F452  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
04F457  72 07                 JB     0x4f460                      ; UNKNOWN
04F459  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
04F45E  76 0E                 JBE    0x4f46e                      ; UNKNOWN
04F460  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
04F463  8A 9F 83 88           MOV    bl, byte ptr [bx - 0x777d]   ; UNKNOWN
04F467  83 E3 0F              AND    bx, 0xf                      ; UNKNOWN
04F46A  FE 8F 03 87           DEC    byte ptr [bx - 0x78fd]       ; UNKNOWN
04F46E  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
04F471  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
04F475  88 87 96 88           MOV    byte ptr [bx - 0x776a], al   ; UNKNOWN
04F479  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04F47C  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F481  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F484  0B C0                 OR     ax, ax                       ; UNKNOWN
04F486  7D C7                 JGE    0x4f44f                      ; UNKNOWN
04F488  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F48C  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04F490  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04F493  83 E8 18              SUB    ax, 0x18                     ; UNKNOWN
04F496  50                    PUSH   ax                           ; UNKNOWN
04F497  50                    PUSH   ax                           ; UNKNOWN
04F498  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04F49B  9A 0A 04 B7 36        LCALL  0x36b7, 0x40a                ; UNKNOWN
04F4A0  C9                    LEAVE                               ; UNKNOWN
04F4A1  CB                    RETF                                ; UNKNOWN
