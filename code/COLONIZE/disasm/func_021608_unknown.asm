; ============================================================================
; func_021608_unknown
; Region   : load_image
; Bytes    : file 0x021608..0x021672  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021608  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02160C  57                    PUSH   di                           ; UNKNOWN
02160D  56                    PUSH   si                           ; UNKNOWN
02160E  8B F0                 MOV    si, ax                       ; UNKNOWN
021610  BF 01 00              MOV    di, 1                        ; UNKNOWN
021613  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
021616  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
021619  80 BF 82 88 0F        CMP    byte ptr [bx - 0x777e], 0xf  ; UNKNOWN
02161E  74 0E                 JE     0x2162e                      ; UNKNOWN
021620  80 BF 82 88 10        CMP    byte ptr [bx - 0x777e], 0x10 ; UNKNOWN
021625  74 07                 JE     0x2162e                      ; UNKNOWN
021627  80 BF 82 88 11        CMP    byte ptr [bx - 0x777e], 0x11 ; UNKNOWN
02162C  75 03                 JNE    0x21631                      ; UNKNOWN
02162E  BF 02 00              MOV    di, 2                        ; UNKNOWN
021631  6A 07                 PUSH   7                            ; UNKNOWN
021633  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
021637  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
02163A  50                    PUSH   ax                           ; UNKNOWN
02163B  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
021640  83 C4 04              ADD    sp, 4                        ; UNKNOWN
021643  0B C0                 OR     ax, ax                       ; UNKNOWN
021645  74 14                 JE     0x2165b                      ; UNKNOWN
021647  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
02164A  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
02164F  72 07                 JB     0x21658                      ; UNKNOWN
021651  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
021656  76 03                 JBE    0x2165b                      ; UNKNOWN
021658  BF 02 00              MOV    di, 2                        ; UNKNOWN
02165B  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
02165E  80 BF 82 88 05        CMP    byte ptr [bx - 0x777e], 5    ; UNKNOWN
021663  75 01                 JNE    0x21666                      ; UNKNOWN
021665  47                    INC    di                           ; UNKNOWN
021666  8B C6                 MOV    ax, si                       ; UNKNOWN
021668  8B D7                 MOV    dx, di                       ; UNKNOWN
02166A  0E                    PUSH   cs                           ; UNKNOWN
02166B  E8 58 FF              CALL   0x215c6                      ; UNKNOWN
02166E  5E                    POP    si                           ; UNKNOWN
02166F  5F                    POP    di                           ; UNKNOWN
021670  C9                    LEAVE                               ; UNKNOWN
021671  CB                    RETF                                ; UNKNOWN
