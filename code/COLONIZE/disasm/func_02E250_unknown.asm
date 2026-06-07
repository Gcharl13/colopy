; ============================================================================
; func_02E250_unknown
; Region   : load_image
; Bytes    : file 0x02E250..0x02E285  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E250  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E254  56                    PUSH   si                           ; UNKNOWN
02E255  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E259  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E25C  98                    CWDE                                ; UNKNOWN
02E25D  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E260  7E 23                 JLE    0x2e285                      ; UNKNOWN
02E262  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E265  D1 FE                 SAR    si, 1                        ; UNKNOWN
02E267  8A 40 60              MOV    al, byte ptr [bx + si + 0x60] ; UNKNOWN
02E26A  2A E4                 SUB    ah, ah                       ; UNKNOWN
02E26C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E26F  F6 46 06 01           TEST   byte ptr [bp + 6], 1         ; UNKNOWN
02E273  74 06                 JE     0x2e27b                      ; UNKNOWN
02E275  C1 F8 04              SAR    ax, 4                        ; UNKNOWN
02E278  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02E27B  83 66 FE 0F           AND    word ptr [bp - 2], 0xf       ; UNKNOWN
02E27F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E282  5E                    POP    si                           ; UNKNOWN
02E283  C9                    LEAVE                               ; UNKNOWN
02E284  CB                    RETF                                ; UNKNOWN
