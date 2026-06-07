; ============================================================================
; func_03A939_unknown
; Region   : load_image
; Bytes    : file 0x03A939..0x03A984  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A939  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
03A93D  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A940  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
03A943  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A946  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A94A  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A94C  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
03A950  2A ED                 SUB    ch, ch                       ; UNKNOWN
03A952  51                    PUSH   cx                           ; UNKNOWN
03A953  50                    PUSH   ax                           ; UNKNOWN
03A954  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
03A959  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A95C  0B C0                 OR     ax, ax                       ; UNKNOWN
03A95E  7C 22                 JL     0x3a982                      ; UNKNOWN
03A960  50                    PUSH   ax                           ; UNKNOWN
03A961  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
03A966  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A969  6A 00                 PUSH   0                            ; UNKNOWN
03A96B  FF 76 DA              PUSH   word ptr [bp - 0x26]         ; UNKNOWN
03A96E  9A 4F 0F 6D 3E        LCALL  0x3e6d, 0xf4f                ; UNKNOWN
03A973  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A976  0B C0                 OR     ax, ax                       ; UNKNOWN
03A978  75 08                 JNE    0x3a982                      ; UNKNOWN
03A97A  50                    PUSH   ax                           ; UNKNOWN
03A97B  6A 01                 PUSH   1                            ; UNKNOWN
03A97D  9A 44 04 10 0C        LCALL  0xc10, 0x444                 ; UNKNOWN
03A982  C9                    LEAVE                               ; UNKNOWN
03A983  CB                    RETF                                ; UNKNOWN
