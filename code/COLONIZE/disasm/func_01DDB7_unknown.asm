; ============================================================================
; func_01DDB7_unknown
; Region   : load_image
; Bytes    : file 0x01DDB7..0x01DE16  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01DDB7  55                    PUSH   bp                           ; UNKNOWN
01DDB8  8B EC                 MOV    bp, sp                       ; UNKNOWN
01DDBA  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4       ; UNKNOWN
01DDBE  7D 37                 JGE    0x1ddf7                      ; UNKNOWN
01DDC0  6B 5E 0A 34           IMUL   bx, word ptr [bp + 0xa], 0x34 ; UNKNOWN
01DDC4  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
01DDC9  75 2C                 JNE    0x1ddf7                      ; UNKNOWN
01DDCB  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01DDCF  74 26                 JE     0x1ddf7                      ; UNKNOWN
01DDD1  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
01DDD4  83 C0 04              ADD    ax, 4                        ; UNKNOWN
01DDD7  50                    PUSH   ax                           ; UNKNOWN
01DDD8  9A 94 01 49 22        LCALL  0x2249, 0x194                ; UNKNOWN
01DDDD  8B E5                 MOV    sp, bp                       ; UNKNOWN
01DDDF  50                    PUSH   ax                           ; UNKNOWN
01DDE0  6A 00                 PUSH   0                            ; UNKNOWN
01DDE2  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01DDE7  8B E5                 MOV    sp, bp                       ; UNKNOWN
01DDE9  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
01DDED  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
01DDF0  2B D2                 SUB    dx, dx                       ; UNKNOWN
01DDF2  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
01DDF7  6A 40                 PUSH   0x40                         ; UNKNOWN
01DDF9  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01DDFC  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
01DDFF  83 C0 04              ADD    ax, 4                        ; UNKNOWN
01DE02  50                    PUSH   ax                           ; UNKNOWN
01DE03  9A CE 00 49 22        LCALL  0x2249, 0xce                 ; UNKNOWN
01DE08  8B E5                 MOV    sp, bp                       ; UNKNOWN
01DE0A  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01DE0D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01DE10  0E                    PUSH   cs                           ; UNKNOWN
01DE11  E8 12 FF              CALL   0x1dd26                      ; UNKNOWN
01DE14  C9                    LEAVE                               ; UNKNOWN
01DE15  CB                    RETF                                ; UNKNOWN
