; ============================================================================
; func_04DC45_unknown
; Region   : load_image
; Bytes    : file 0x04DC45..0x04DC5A  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DC45  55                    PUSH   bp                           ; UNKNOWN
04DC46  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DC48  57                    PUSH   di                           ; UNKNOWN
04DC49  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
04DC4C  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
04DC4F  8B 15                 MOV    dx, word ptr [di]            ; UNKNOWN
04DC51  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
04DC53  89 05                 MOV    word ptr [di], ax            ; UNKNOWN
04DC55  89 17                 MOV    word ptr [bx], dx            ; UNKNOWN
04DC57  5F                    POP    di                           ; UNKNOWN
04DC58  C9                    LEAVE                               ; UNKNOWN
04DC59  CB                    RETF                                ; UNKNOWN
