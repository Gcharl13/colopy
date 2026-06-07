; ============================================================================
; func_06A72E_unknown
; Region   : load_image
; Bytes    : file 0x06A72E..0x06A7A8  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A72E  55                    PUSH   bp                           ; UNKNOWN
06A72F  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A731  83 EC 04              SUB    sp, 4                        ; UNKNOWN
06A734  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06A737  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
06A73B  72 05                 JB     0x6a742                      ; UNKNOWN
06A73D  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
06A740  EB 2A                 JMP    0x6a76c                      ; UNKNOWN
06A742  F7 46 0A 00 80        TEST   word ptr [bp + 0xa], 0x8000  ; UNKNOWN
06A747  74 48                 JE     0x6a791                      ; UNKNOWN
06A749  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
06A74D  74 1A                 JE     0x6a769                      ; UNKNOWN
06A74F  33 C9                 XOR    cx, cx                       ; UNKNOWN
06A751  8B D1                 MOV    dx, cx                       ; UNKNOWN
06A753  B8 01 42              MOV    ax, 0x4201                   ; UNKNOWN
06A756  CD 21                 INT    0x21                         ; UNKNOWN
06A758  72 4B                 JB     0x6a7a5                      ; UNKNOWN
06A75A  F7 46 0C 02 00        TEST   word ptr [bp + 0xc], 2       ; UNKNOWN
06A75F  75 0E                 JNE    0x6a76f                      ; UNKNOWN
06A761  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
06A764  13 56 0A              ADC    dx, word ptr [bp + 0xa]      ; UNKNOWN
06A767  79 28                 JNS    0x6a791                      ; UNKNOWN
06A769  B8 00 16              MOV    ax, 0x1600                   ; UNKNOWN
06A76C  F9                    STC                                 ; UNKNOWN
06A76D  EB 36                 JMP    0x6a7a5                      ; UNKNOWN
06A76F  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
06A772  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06A775  8B D1                 MOV    dx, cx                       ; UNKNOWN
06A777  B8 02 42              MOV    ax, 0x4202                   ; UNKNOWN
06A77A  CD 21                 INT    0x21                         ; UNKNOWN
06A77C  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
06A77F  13 56 0A              ADC    dx, word ptr [bp + 0xa]      ; UNKNOWN
06A782  79 0D                 JNS    0x6a791                      ; UNKNOWN
06A784  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
06A787  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
06A78A  B8 00 42              MOV    ax, 0x4200                   ; UNKNOWN
06A78D  CD 21                 INT    0x21                         ; UNKNOWN
06A78F  EB D8                 JMP    0x6a769                      ; UNKNOWN
06A791  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06A794  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06A797  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
06A79A  B4 42                 MOV    ah, 0x42                     ; UNKNOWN
06A79C  CD 21                 INT    0x21                         ; UNKNOWN
06A79E  72 05                 JB     0x6a7a5                      ; UNKNOWN
06A7A0  80 A7 47 12 FD        AND    byte ptr [bx + 0x1247], 0xfd ; UNKNOWN
06A7A5  E9 C9 F6              JMP    0x69e71                      ; UNKNOWN
