; ============================================================================
; func_040844_unknown
; Region   : load_image
; Bytes    : file 0x040844..0x04087C  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040844  55                    PUSH   bp                           ; UNKNOWN
040845  8B EC                 MOV    bp, sp                       ; UNKNOWN
040847  57                    PUSH   di                           ; UNKNOWN
040848  56                    PUSH   si                           ; UNKNOWN
040849  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
04084C  2B F6                 SUB    si, si                       ; UNKNOWN
04084E  56                    PUSH   si                           ; UNKNOWN
04084F  6B DF 1C              IMUL   bx, di, 0x1c                 ; UNKNOWN
040852  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040856  2A E4                 SUB    ah, ah                       ; UNKNOWN
040858  50                    PUSH   ax                           ; UNKNOWN
040859  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04085D  50                    PUSH   ax                           ; UNKNOWN
04085E  0E                    PUSH   cs                           ; UNKNOWN
04085F  E8 FD FE              CALL   0x4075f                      ; UNKNOWN
040862  83 C4 06              ADD    sp, 6                        ; UNKNOWN
040865  0B C0                 OR     ax, ax                       ; UNKNOWN
040867  74 09                 JE     0x40872                      ; UNKNOWN
040869  56                    PUSH   si                           ; UNKNOWN
04086A  57                    PUSH   di                           ; UNKNOWN
04086B  0E                    PUSH   cs                           ; UNKNOWN
04086C  E8 A4 FC              CALL   0x40513                      ; UNKNOWN
04086F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040872  46                    INC    si                           ; UNKNOWN
040873  83 FE 04              CMP    si, 4                        ; UNKNOWN
040876  7C D6                 JL     0x4084e                      ; UNKNOWN
040878  5E                    POP    si                           ; UNKNOWN
040879  5F                    POP    di                           ; UNKNOWN
04087A  C9                    LEAVE                               ; UNKNOWN
04087B  CB                    RETF                                ; UNKNOWN
