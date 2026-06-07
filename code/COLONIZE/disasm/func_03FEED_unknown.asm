; ============================================================================
; func_03FEED_unknown
; Region   : load_image
; Bytes    : file 0x03FEED..0x03FF0E  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FEED  55                    PUSH   bp                           ; UNKNOWN
03FEEE  8B EC                 MOV    bp, sp                       ; UNKNOWN
03FEF0  56                    PUSH   si                           ; UNKNOWN
03FEF1  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FEF4  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
03FEF7  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03FEFB  2A E4                 SUB    ah, ah                       ; UNKNOWN
03FEFD  50                    PUSH   ax                           ; UNKNOWN
03FEFE  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03FF02  50                    PUSH   ax                           ; UNKNOWN
03FF03  56                    PUSH   si                           ; UNKNOWN
03FF04  0E                    PUSH   cs                           ; UNKNOWN
03FF05  E8 C9 FF              CALL   0x3fed1                      ; UNKNOWN
03FF08  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03FF0B  5E                    POP    si                           ; UNKNOWN
03FF0C  C9                    LEAVE                               ; UNKNOWN
03FF0D  CB                    RETF                                ; UNKNOWN
