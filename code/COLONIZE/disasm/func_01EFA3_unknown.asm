; ============================================================================
; func_01EFA3_unknown
; Region   : load_image
; Bytes    : file 0x01EFA3..0x01F0B3  (272 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01EFA3  C8 82 00 00           ENTER  0x82, 0                      ; UNKNOWN
01EFA7  56                    PUSH   si                           ; UNKNOWN
01EFA8  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01EFAD  83 3E 56 3E 00        CMP    word ptr [0x3e56], 0         ; UNKNOWN
01EFB2  74 35                 JE     0x1efe9                      ; UNKNOWN
01EFB4  A1 52 3E              MOV    ax, word ptr [0x3e52]        ; UNKNOWN
01EFB7  03 06 54 3E           ADD    ax, word ptr [0x3e54]        ; UNKNOWN
01EFBB  03 06 58 3E           ADD    ax, word ptr [0x3e58]        ; UNKNOWN
01EFBF  03 06 56 3E           ADD    ax, word ptr [0x3e56]        ; UNKNOWN
01EFC3  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01EFC6  83 F8 04              CMP    ax, 4                        ; UNKNOWN
01EFC9  7E 06                 JLE    0x1efd1                      ; UNKNOWN
01EFCB  3B 06 56 3E           CMP    ax, word ptr [0x3e56]        ; UNKNOWN
01EFCF  75 05                 JNE    0x1efd6                      ; UNKNOWN
01EFD1  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
01EFD6  39 06 56 3E           CMP    word ptr [0x3e56], ax        ; UNKNOWN
01EFDA  75 03                 JNE    0x1efdf                      ; UNKNOWN
01EFDC  E9 08 07              JMP    0x1f6e7                      ; UNKNOWN
01EFDF  2B C0                 SUB    ax, ax                       ; UNKNOWN
01EFE1  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
01EFE4  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
01EFE7  EB 19                 JMP    0x1f002                      ; UNKNOWN
01EFE9  6B 1E 4A 3E 13        IMUL   bx, word ptr [0x3e4a], 0x13  ; UNKNOWN
01EFEE  80 BF 74 86 00        CMP    byte ptr [bx - 0x798c], 0    ; UNKNOWN
01EFF3  74 03                 JE     0x1eff8                      ; UNKNOWN
01EFF5  E9 EF 06              JMP    0x1f6e7                      ; UNKNOWN
01EFF8  FF 06 56 3E           INC    word ptr [0x3e56]            ; UNKNOWN
01EFFC  E9 E8 06              JMP    0x1f6e7                      ; UNKNOWN
01EFFF  FF 46 98              INC    word ptr [bp - 0x68]         ; UNKNOWN
01F002  8B 46 98              MOV    ax, word ptr [bp - 0x68]     ; UNKNOWN
01F005  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
01F009  7F 03                 JG     0x1f00e                      ; UNKNOWN
01F00B  E9 88 00              JMP    0x1f096                      ; UNKNOWN
01F00E  50                    PUSH   ax                           ; UNKNOWN
01F00F  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01F014  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01F017  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
01F01A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01F01E  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
01F021  75 DC                 JNE    0x1efff                      ; UNKNOWN
01F023  F6 47 1C 40           TEST   byte ptr [bx + 0x1c], 0x40   ; UNKNOWN
01F027  74 D6                 JE     0x1efff                      ; UNKNOWN
01F029  83 7E D8 0A           CMP    word ptr [bp - 0x28], 0xa    ; UNKNOWN
01F02D  7D D0                 JGE    0x1efff                      ; UNKNOWN
01F02F  9A 71 02 5F 24        LCALL  0x245f, 0x271                ; UNKNOWN
01F034  83 E8 64              SUB    ax, 0x64                     ; UNKNOWN
01F037  F7 D8                 NEG    ax                           ; UNKNOWN
01F039  89 46 BC              MOV    word ptr [bp - 0x44], ax     ; UNKNOWN
01F03C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01F040  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01F043  98                    CWDE                                ; UNKNOWN
01F044  8B 4E BC              MOV    cx, word ptr [bp - 0x44]     ; UNKNOWN
01F047  83 C1 19              ADD    cx, 0x19                     ; UNKNOWN
01F04A  F7 E9                 IMUL   cx                           ; UNKNOWN
01F04C  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01F04F  6A 0A                 PUSH   0xa                          ; UNKNOWN
01F051  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01F053  2A E4                 SUB    ah, ah                       ; UNKNOWN
01F055  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
01F058  2A F6                 SUB    dh, dh                       ; UNKNOWN
01F05A  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
01F05F  89 46 B6              MOV    word ptr [bp - 0x4a], ax     ; UNKNOWN
01F062  50                    PUSH   ax                           ; UNKNOWN
01F063  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
01F068  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01F06B  6B C0 B5              IMUL   ax, ax, -0x4b                ; UNKNOWN
01F06E  01 46 CE              ADD    word ptr [bp - 0x32], ax     ; UNKNOWN
01F071  8B 46 CE              MOV    ax, word ptr [bp - 0x32]     ; UNKNOWN
01F074  3B 46 BC              CMP    ax, word ptr [bp - 0x44]     ; UNKNOWN
01F077  7D 03                 JGE    0x1f07c                      ; UNKNOWN
01F079  8B 46 BC              MOV    ax, word ptr [bp - 0x44]     ; UNKNOWN
01F07C  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
01F07F  8B 76 D8              MOV    si, word ptr [bp - 0x28]     ; UNKNOWN
01F082  D1 E6                 SHL    si, 1                        ; UNKNOWN
01F084  89 42 A2              MOV    word ptr [bp + si - 0x5e], ax ; UNKNOWN
01F087  8A 46 98              MOV    al, byte ptr [bp - 0x68]     ; UNKNOWN
01F08A  8B 76 D8              MOV    si, word ptr [bp - 0x28]     ; UNKNOWN
01F08D  88 42 C0              MOV    byte ptr [bp + si - 0x40], al ; UNKNOWN
01F090  FF 46 D8              INC    word ptr [bp - 0x28]         ; UNKNOWN
01F093  E9 69 FF              JMP    0x1efff                      ; UNKNOWN
01F096  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; UNKNOWN
01F09A  74 12                 JE     0x1f0ae                      ; UNKNOWN
01F09C  8D 46 C0              LEA    ax, [bp - 0x40]              ; UNKNOWN
01F09F  16                    PUSH   ss                           ; UNKNOWN
01F0A0  50                    PUSH   ax                           ; UNKNOWN
01F0A1  8D 46 A2              LEA    ax, [bp - 0x5e]              ; UNKNOWN
01F0A4  16                    PUSH   ss                           ; UNKNOWN
01F0A5  50                    PUSH   ax                           ; UNKNOWN
01F0A6  8B 46 D8              MOV    ax, word ptr [bp - 0x28]     ; UNKNOWN
01F0A9  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
01F0AE  C7 46 CA 00 00        MOV    word ptr [bp - 0x36], 0      ; UNKNOWN
