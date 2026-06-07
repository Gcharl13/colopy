; ============================================================================
; func_00EA66_unknown
; Region   : load_image
; Bytes    : file 0x00EA66..0x00EAE1  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EA66  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
00EA6A  56                    PUSH   si                           ; UNKNOWN
00EA6B  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
00EA6F  75 07                 JNE    0xea78                       ; UNKNOWN
00EA71  C6 46 FE 00           MOV    byte ptr [bp - 2], 0         ; UNKNOWN
00EA75  EB 05                 JMP    0xea7c                       ; UNKNOWN
00EA77  90                    NOP                                 ; UNKNOWN
00EA78  C6 46 FE 01           MOV    byte ptr [bp - 2], 1         ; UNKNOWN
00EA7C  83 7E 10 00           CMP    word ptr [bp + 0x10], 0      ; UNKNOWN
00EA80  75 06                 JNE    0xea88                       ; UNKNOWN
00EA82  C6 46 FC 00           MOV    byte ptr [bp - 4], 0         ; UNKNOWN
00EA86  EB 04                 JMP    0xea8c                       ; UNKNOWN
00EA88  C6 46 FC 01           MOV    byte ptr [bp - 4], 1         ; UNKNOWN
00EA8C  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00EA8F  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
00EA92  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
00EA95  89 56 EC              MOV    word ptr [bp - 0x14], dx     ; UNKNOWN
00EA98  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
00EA9B  88 46 EE              MOV    byte ptr [bp - 0x12], al     ; UNKNOWN
00EA9E  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
00EAA1  89 46 EF              MOV    word ptr [bp - 0x11], ax     ; UNKNOWN
00EAA4  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
00EAA7  89 46 F1              MOV    word ptr [bp - 0xf], ax      ; UNKNOWN
00EAAA  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
00EAAD  89 46 F3              MOV    word ptr [bp - 0xd], ax      ; UNKNOWN
00EAB0  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
00EAB3  88 46 F5              MOV    byte ptr [bp - 0xb], al      ; UNKNOWN
00EAB6  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
00EAB9  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00EABC  8B 46 14              MOV    ax, word ptr [bp + 0x14]     ; UNKNOWN
00EABF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00EAC2  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
00EAC5  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
00EAC8  B8 00 57              MOV    ax, 0x5700                   ; UNKNOWN
00EACB  8D 76 EA              LEA    si, [bp - 0x16]              ; UNKNOWN
00EACE  CD 67                 INT    0x67                         ; UNKNOWN
00EAD0  8A C4                 MOV    al, ah                       ; UNKNOWN
00EAD2  32 E4                 XOR    ah, ah                       ; UNKNOWN
00EAD4  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00EAD7  0B C0                 OR     ax, ax                       ; UNKNOWN
00EAD9  75 07                 JNE    0xeae2                       ; UNKNOWN
00EADB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EADE  5E                    POP    si                           ; UNKNOWN
00EADF  C9                    LEAVE                               ; UNKNOWN
00EAE0  CB                    RETF                                ; UNKNOWN
