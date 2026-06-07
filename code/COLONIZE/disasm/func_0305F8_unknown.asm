; ============================================================================
; func_0305F8_unknown
; Region   : load_image
; Bytes    : file 0x0305F8..0x030645  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0305F8  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0305FC  56                    PUSH   si                           ; UNKNOWN
0305FD  C7 46 FC F0 00        MOV    word ptr [bp - 4], 0xf0      ; UNKNOWN
030602  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
030605  D1 F8                 SAR    ax, 1                        ; UNKNOWN
030607  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03060A  8B F0                 MOV    si, ax                       ; UNKNOWN
03060C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
030610  8A 80 8D 88           MOV    al, byte ptr [bx + si - 0x7773] ; UNKNOWN
030614  2A E4                 SUB    ah, ah                       ; UNKNOWN
030616  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030619  F6 46 08 01           TEST   byte ptr [bp + 8], 1         ; UNKNOWN
03061D  74 09                 JE     0x30628                      ; UNKNOWN
03061F  C7 46 FC 0F 00        MOV    word ptr [bp - 4], 0xf       ; UNKNOWN
030624  C1 66 0A 04           SHL    word ptr [bp + 0xa], 4       ; UNKNOWN
030628  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03062B  23 46 FA              AND    ax, word ptr [bp - 6]        ; UNKNOWN
03062E  0B 46 0A              OR     ax, word ptr [bp + 0xa]      ; UNKNOWN
030631  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030634  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; UNKNOWN
030638  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
03063B  88 80 8D 88           MOV    byte ptr [bx + si - 0x7773], al ; UNKNOWN
03063F  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
030642  5E                    POP    si                           ; UNKNOWN
030643  C9                    LEAVE                               ; UNKNOWN
030644  CB                    RETF                                ; UNKNOWN
