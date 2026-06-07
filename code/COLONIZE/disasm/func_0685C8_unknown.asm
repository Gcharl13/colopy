; ============================================================================
; func_0685C8_unknown
; Region   : load_image
; Bytes    : file 0x0685C8..0x068617  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0685C8  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0685CC  56                    PUSH   si                           ; UNKNOWN
0685CD  83 3E EA CE 00        CMP    word ptr [0xceea], 0         ; UNKNOWN
0685D2  7C 21                 JL     0x685f5                      ; UNKNOWN
0685D4  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0685D7  26 8B 07              MOV    ax, word ptr es:[bx]         ; UNKNOWN
0685DA  2B D2                 SUB    dx, dx                       ; UNKNOWN
0685DC  3B 16 EA CE           CMP    dx, word ptr [0xceea]        ; UNKNOWN
0685E0  7C 0F                 JL     0x685f1                      ; UNKNOWN
0685E2  7F 06                 JG     0x685ea                      ; UNKNOWN
0685E4  3B 06 E8 CE           CMP    ax, word ptr [0xcee8]        ; UNKNOWN
0685E8  76 07                 JBE    0x685f1                      ; UNKNOWN
0685EA  8B 16 EA CE           MOV    dx, word ptr [0xceea]        ; UNKNOWN
0685EE  A1 E8 CE              MOV    ax, word ptr [0xcee8]        ; UNKNOWN
0685F1  8B F0                 MOV    si, ax                       ; UNKNOWN
0685F3  EB 06                 JMP    0x685fb                      ; UNKNOWN
0685F5  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0685F8  26 8B 37              MOV    si, word ptr es:[bx]         ; UNKNOWN
0685FB  0B F6                 OR     si, si                       ; UNKNOWN
0685FD  74 51                 JE     0x68650                      ; UNKNOWN
0685FF  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
068602  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
068605  6A 00                 PUSH   0                            ; UNKNOWN
068607  6A 01                 PUSH   1                            ; UNKNOWN
068609  8B C6                 MOV    ax, si                       ; UNKNOWN
06860B  2B D2                 SUB    dx, dx                       ; UNKNOWN
06860D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068610  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
068613  8B 1E 06 CF           MOV    bx, word ptr [0xcf06]        ; UNKNOWN
