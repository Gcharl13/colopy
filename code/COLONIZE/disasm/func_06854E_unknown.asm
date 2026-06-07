; ============================================================================
; func_06854E_unknown
; Region   : load_image
; Bytes    : file 0x06854E..0x068595  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06854E  55                    PUSH   bp                           ; UNKNOWN
06854F  8B EC                 MOV    bp, sp                       ; UNKNOWN
068551  56                    PUSH   si                           ; UNKNOWN
068552  83 3E EE CE 00        CMP    word ptr [0xceee], 0         ; UNKNOWN
068557  7C 21                 JL     0x6857a                      ; UNKNOWN
068559  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
06855C  26 8B 07              MOV    ax, word ptr es:[bx]         ; UNKNOWN
06855F  2B D2                 SUB    dx, dx                       ; UNKNOWN
068561  3B 16 EE CE           CMP    dx, word ptr [0xceee]        ; UNKNOWN
068565  7C 0F                 JL     0x68576                      ; UNKNOWN
068567  7F 06                 JG     0x6856f                      ; UNKNOWN
068569  3B 06 EC CE           CMP    ax, word ptr [0xceec]        ; UNKNOWN
06856D  76 07                 JBE    0x68576                      ; UNKNOWN
06856F  8B 16 EE CE           MOV    dx, word ptr [0xceee]        ; UNKNOWN
068573  A1 EC CE              MOV    ax, word ptr [0xceec]        ; UNKNOWN
068576  8B F0                 MOV    si, ax                       ; UNKNOWN
068578  EB 06                 JMP    0x68580                      ; UNKNOWN
06857A  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
06857D  26 8B 37              MOV    si, word ptr es:[bx]         ; UNKNOWN
068580  0B F6                 OR     si, si                       ; UNKNOWN
068582  74 3C                 JE     0x685c0                      ; UNKNOWN
068584  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
068587  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06858A  6A 00                 PUSH   0                            ; UNKNOWN
06858C  56                    PUSH   si                           ; UNKNOWN
06858D  B8 01 00              MOV    ax, 1                        ; UNKNOWN
068590  99                    CDQ                                 ; UNKNOWN
068591  8B 1E 04 CF           MOV    bx, word ptr [0xcf04]        ; UNKNOWN
