; ============================================================================
; func_06A140_unknown
; Region   : load_image
; Bytes    : file 0x06A140..0x06A1B3  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A140  55                    PUSH   bp                           ; UNKNOWN
06A141  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A143  56                    PUSH   si                           ; UNKNOWN
06A144  57                    PUSH   di                           ; UNKNOWN
06A145  8B 76 04              MOV    si, word ptr [bp + 4]        ; UNKNOWN
06A148  BB DA 14              MOV    bx, 0x14da                   ; UNKNOWN
06A14B  81 FE 80 12           CMP    si, 0x1280                   ; UNKNOWN
06A14F  74 12                 JE     0x6a163                      ; UNKNOWN
06A151  BB DC 14              MOV    bx, 0x14dc                   ; UNKNOWN
06A154  81 FE 88 12           CMP    si, 0x1288                   ; UNKNOWN
06A158  74 09                 JE     0x6a163                      ; UNKNOWN
06A15A  BB DE 14              MOV    bx, 0x14de                   ; UNKNOWN
06A15D  81 FE 98 12           CMP    si, 0x1298                   ; UNKNOWN
06A161  75 4A                 JNE    0x6a1ad                      ; UNKNOWN
06A163  8B FE                 MOV    di, si                       ; UNKNOWN
06A165  81 EF 78 12           SUB    di, 0x1278                   ; UNKNOWN
06A169  81 C7 18 13           ADD    di, 0x1318                   ; UNKNOWN
06A16D  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc       ; UNKNOWN
06A171  75 3A                 JNE    0x6a1ad                      ; UNKNOWN
06A173  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
06A176  75 35                 JNE    0x6a1ad                      ; UNKNOWN
06A178  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
06A17A  0B C0                 OR     ax, ax                       ; UNKNOWN
06A17C  74 1B                 JE     0x6a199                      ; UNKNOWN
06A17E  89 44 04              MOV    word ptr [si + 4], ax        ; UNKNOWN
06A181  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
06A183  C7 44 02 00 02        MOV    word ptr [si + 2], 0x200     ; UNKNOWN
06A188  C7 45 02 00 02        MOV    word ptr [di + 2], 0x200     ; UNKNOWN
06A18D  80 4C 06 02           OR     byte ptr [si + 6], 2         ; UNKNOWN
06A191  C6 05 11              MOV    byte ptr [di], 0x11          ; UNKNOWN
06A194  B8 01 00              MOV    ax, 1                        ; UNKNOWN
06A197  EB 16                 JMP    0x6a1af                      ; UNKNOWN
06A199  53                    PUSH   bx                           ; UNKNOWN
06A19A  B8 00 02              MOV    ax, 0x200                    ; UNKNOWN
06A19D  50                    PUSH   ax                           ; UNKNOWN
06A19E  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06A1A3  5B                    POP    bx                           ; UNKNOWN
06A1A4  5B                    POP    bx                           ; UNKNOWN
06A1A5  0B C0                 OR     ax, ax                       ; UNKNOWN
06A1A7  74 04                 JE     0x6a1ad                      ; UNKNOWN
06A1A9  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
06A1AB  EB D1                 JMP    0x6a17e                      ; UNKNOWN
06A1AD  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A1AF  5F                    POP    di                           ; UNKNOWN
06A1B0  5E                    POP    si                           ; UNKNOWN
06A1B1  5D                    POP    bp                           ; UNKNOWN
06A1B2  C3                    RET                                 ; UNKNOWN
