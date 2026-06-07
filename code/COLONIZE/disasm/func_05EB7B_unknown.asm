; ============================================================================
; func_05EB7B_unknown
; Region   : load_image
; Bytes    : file 0x05EB7B..0x05EBE9  (110 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EB7B  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
05EB7F  56                    PUSH   si                           ; UNKNOWN
05EB80  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
05EB85  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05EB88  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
05EB8B  8A 87 F6 0B           MOV    al, byte ptr [bx + 0xbf6]    ; UNKNOWN
05EB8F  2A E4                 SUB    ah, ah                       ; UNKNOWN
05EB91  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
05EB94  8A 87 F4 0B           MOV    al, byte ptr [bx + 0xbf4]    ; UNKNOWN
05EB98  50                    PUSH   ax                           ; UNKNOWN
05EB99  9A 98 03 5F 24        LCALL  0x245f, 0x398                ; UNKNOWN
05EB9E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05EBA1  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
05EBA4  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
05EBA7  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05EBA9  83 BF 88 73 03        CMP    word ptr [bx + 0x7388], 3    ; UNKNOWN
05EBAE  72 05                 JB     0x5ebb5                      ; UNKNOWN
05EBB0  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2         ; UNKNOWN
05EBB5  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
05EBB8  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05EBBA  83 BF 88 73 08        CMP    word ptr [bx + 0x7388], 8    ; UNKNOWN
05EBBF  72 05                 JB     0x5ebc6                      ; UNKNOWN
05EBC1  C7 46 F8 03 00        MOV    word ptr [bp - 8], 3         ; UNKNOWN
05EBC6  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
05EBC9  D1 E6                 SHL    si, 1                        ; UNKNOWN
05EBCB  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EBCF  83 B8 9A 00 64        CMP    word ptr [bx + si + 0x9a], 0x64 ; UNKNOWN
05EBD4  7C 05                 JL     0x5ebdb                      ; UNKNOWN
05EBD6  C7 46 F8 03 00        MOV    word ptr [bp - 8], 3         ; UNKNOWN
05EBDB  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
05EBDE  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
05EBE1  7D 06                 JGE    0x5ebe9                      ; UNKNOWN
05EBE3  B8 01 00              MOV    ax, 1                        ; UNKNOWN
05EBE6  5E                    POP    si                           ; UNKNOWN
05EBE7  C9                    LEAVE                               ; UNKNOWN
05EBE8  CB                    RETF                                ; UNKNOWN
