; ============================================================================
; func_02C226_unknown
; Region   : load_image
; Bytes    : file 0x02C226..0x02C2D7  (177 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C226  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
02C22A  57                    PUSH   di                           ; UNKNOWN
02C22B  56                    PUSH   si                           ; UNKNOWN
02C22C  2B C0                 SUB    ax, ax                       ; UNKNOWN
02C22E  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
02C231  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02C234  B8 0C 00              MOV    ax, 0xc                      ; UNKNOWN
02C237  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02C23A  50                    PUSH   ax                           ; UNKNOWN
02C23B  9A 04 00 2D 45        LCALL  0x452d, 4                    ; UNKNOWN
02C240  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02C243  8B F0                 MOV    si, ax                       ; UNKNOWN
02C245  89 56 E6              MOV    word ptr [bp - 0x1a], dx     ; UNKNOWN
02C248  0B D0                 OR     dx, ax                       ; UNKNOWN
02C24A  75 08                 JNE    0x2c254                      ; UNKNOWN
02C24C  C7 06 9C 09 21 03     MOV    word ptr [0x99c], 0x321      ; UNKNOWN
02C252  EB 79                 JMP    0x2c2cd                      ; UNKNOWN
02C254  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02C257  B8 00 40              MOV    ax, 0x4000                   ; UNKNOWN
02C25A  9A 04 00 61 5D        LCALL  0x5d61, 4                    ; UNKNOWN
02C25F  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
02C262  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
02C265  0B D0                 OR     dx, ax                       ; UNKNOWN
02C267  75 08                 JNE    0x2c271                      ; UNKNOWN
02C269  C7 06 9C 09 22 03     MOV    word ptr [0x99c], 0x322      ; UNKNOWN
02C26F  EB 5C                 JMP    0x2c2cd                      ; UNKNOWN
02C271  89 76 E4              MOV    word ptr [bp - 0x1c], si     ; UNKNOWN
02C274  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
02C277  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
02C27A  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
02C27D  2B F6                 SUB    si, si                       ; UNKNOWN
02C27F  8B 4E E4              MOV    cx, word ptr [bp - 0x1c]     ; UNKNOWN
02C282  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
02C285  8B F9                 MOV    di, cx                       ; UNKNOWN
02C287  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02C28A  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02C28D  89 7E E0              MOV    word ptr [bp - 0x20], di     ; UNKNOWN
02C290  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
02C293  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
02C296  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
02C299  6A 00                 PUSH   0                            ; UNKNOWN
02C29B  8D 44 01              LEA    ax, [si + 1]                 ; UNKNOWN
02C29E  8D 5E DC              LEA    bx, [bp - 0x24]              ; UNKNOWN
02C2A1  2B D2                 SUB    dx, dx                       ; UNKNOWN
02C2A3  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
02C2A8  81 C7 00 01           ADD    di, 0x100                    ; UNKNOWN
02C2AC  8D 44 01              LEA    ax, [si + 1]                 ; UNKNOWN
02C2AF  8B F0                 MOV    si, ax                       ; UNKNOWN
02C2B1  83 FE 0C              CMP    si, 0xc                      ; UNKNOWN
02C2B4  7C D4                 JL     0x2c28a                      ; UNKNOWN
02C2B6  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
02C2B9  FF 76 E8              PUSH   word ptr [bp - 0x18]         ; UNKNOWN
02C2BC  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
02C2C1  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
02C2C4  8B 56 E6              MOV    dx, word ptr [bp - 0x1a]     ; UNKNOWN
02C2C7  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02C2CA  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
02C2CD  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
02C2D0  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
02C2D3  5E                    POP    si                           ; UNKNOWN
02C2D4  5F                    POP    di                           ; UNKNOWN
02C2D5  C9                    LEAVE                               ; UNKNOWN
02C2D6  CB                    RETF                                ; UNKNOWN
