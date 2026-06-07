; ============================================================================
; func_00954C_unknown
; Region   : load_image
; Bytes    : file 0x00954C..0x0095EB  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00954C  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
009550  52                    PUSH   dx                           ; UNKNOWN
009551  50                    PUSH   ax                           ; UNKNOWN
009552  57                    PUSH   di                           ; UNKNOWN
009553  56                    PUSH   si                           ; UNKNOWN
009554  2B C9                 SUB    cx, cx                       ; UNKNOWN
009556  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
009559  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
00955C  A3 34 01              MOV    word ptr [0x134], ax         ; UNKNOWN
00955F  89 16 36 01           MOV    word ptr [0x136], dx         ; UNKNOWN
009563  8B F0                 MOV    si, ax                       ; UNKNOWN
009565  8B FA                 MOV    di, dx                       ; UNKNOWN
009567  9A B8 00 64 00        LCALL  0x64, 0xb8                   ; UNKNOWN
00956C  A3 38 01              MOV    word ptr [0x138], ax         ; UNKNOWN
00956F  89 16 3A 01           MOV    word ptr [0x13a], dx         ; UNKNOWN
009573  0B FF                 OR     di, di                       ; UNKNOWN
009575  7C 56                 JL     0x95cd                       ; UNKNOWN
009577  7F 04                 JG     0x957d                       ; UNKNOWN
009579  0B F6                 OR     si, si                       ; UNKNOWN
00957B  74 50                 JE     0x95cd                       ; UNKNOWN
00957D  83 7E F4 0F           CMP    word ptr [bp - 0xc], 0xf     ; UNKNOWN
009581  7F 4A                 JG     0x95cd                       ; UNKNOWN
009583  7C 06                 JL     0x958b                       ; UNKNOWN
009585  83 7E F2 F0           CMP    word ptr [bp - 0xe], -0x10   ; UNKNOWN
009589  77 42                 JA     0x95cd                       ; UNKNOWN
00958B  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
00958E  8B 56 F4              MOV    dx, word ptr [bp - 0xc]      ; UNKNOWN
009591  05 0F 00              ADD    ax, 0xf                      ; UNKNOWN
009594  83 D2 00              ADC    dx, 0                        ; UNKNOWN
009597  D1 FA                 SAR    dx, 1                        ; UNKNOWN
009599  D1 D8                 RCR    ax, 1                        ; UNKNOWN
00959B  D1 FA                 SAR    dx, 1                        ; UNKNOWN
00959D  D1 D8                 RCR    ax, 1                        ; UNKNOWN
00959F  D1 FA                 SAR    dx, 1                        ; UNKNOWN
0095A1  D1 D8                 RCR    ax, 1                        ; UNKNOWN
0095A3  D1 FA                 SAR    dx, 1                        ; UNKNOWN
0095A5  D1 D8                 RCR    ax, 1                        ; UNKNOWN
0095A7  50                    PUSH   ax                           ; UNKNOWN
0095A8  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
0095AB  50                    PUSH   ax                           ; UNKNOWN
0095AC  E8 4F FF              CALL   0x94fe                       ; UNKNOWN
0095AF  0B C0                 OR     ax, ax                       ; UNKNOWN
0095B1  74 1A                 JE     0x95cd                       ; UNKNOWN
0095B3  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0095B6  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0095BB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0095BE  3D FF 9F              CMP    ax, 0x9fff                   ; UNKNOWN
0095C1  76 05                 JBE    0x95c8                       ; UNKNOWN
0095C3  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0095C6  EB 02                 JMP    0x95ca                       ; UNKNOWN
0095C8  2B C0                 SUB    ax, ax                       ; UNKNOWN
0095CA  A3 3C 01              MOV    word ptr [0x13c], ax         ; UNKNOWN
0095CD  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0095D0  0B 46 FC              OR     ax, word ptr [bp - 4]        ; UNKNOWN
0095D3  75 05                 JNE    0x95da                       ; UNKNOWN
0095D5  B0 01                 MOV    al, 1                        ; UNKNOWN
0095D7  EB 03                 JMP    0x95dc                       ; UNKNOWN
0095D9  90                    NOP                                 ; UNKNOWN
0095DA  2A C0                 SUB    al, al                       ; UNKNOWN
0095DC  A2 31 01              MOV    byte ptr [0x131], al         ; UNKNOWN
0095DF  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0095E2  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
0095E5  5E                    POP    si                           ; UNKNOWN
0095E6  5F                    POP    di                           ; UNKNOWN
0095E7  C9                    LEAVE                               ; UNKNOWN
0095E8  CA 04 00              RETF   4                            ; UNKNOWN
