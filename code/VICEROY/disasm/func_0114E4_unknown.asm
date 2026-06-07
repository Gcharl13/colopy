; ============================================================================
; func_0114E4_unknown
; Region   : load_image
; Bytes    : file 0x0114E4..0x011561  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0114E4  55                    PUSH   bp                           ; UNKNOWN
0114E5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0114E7  83 EC 02              SUB    sp, 2                        ; UNKNOWN
0114EA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0114ED  3B 1E B9 27           CMP    bx, word ptr [0x27b9]        ; UNKNOWN
0114F1  72 06                 JB     0x114f9                      ; UNKNOWN
0114F3  F9                    STC                                 ; UNKNOWN
0114F4  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
0114F7  EB 68                 JMP    0x11561                      ; UNKNOWN
0114F9  33 C0                 XOR    ax, ax                       ; UNKNOWN
0114FB  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; LOCAL_LOAD
0114FE  E3 61                 JCXZ   0x11561                      ; UNKNOWN
011500  F6 87 BB 27 02        TEST   byte ptr [bx + 0x27bb], 2    ; LOGIC
011505  75 5A                 JNE    0x11561                      ; UNKNOWN
011507  81 3E 16 2B D6 D6     CMP    word ptr [0x2b16], 0xd6d6    ; CMP
01150D  75 04                 JNE    0x11513                      ; UNKNOWN
01150F  FF 16 18 2B           CALL   word ptr [0x2b18]            ; UNKNOWN
011513  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; LOCAL_LOAD
011516  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
011519  B4 3F                 MOV    ah, 0x3f                     ; UNKNOWN
01151B  CD 21                 INT    0x21                         ; UNKNOWN
01151D  73 04                 JAE    0x11523                      ; UNKNOWN
01151F  B4 09                 MOV    ah, 9                        ; UNKNOWN
011521  EB 3E                 JMP    0x11561                      ; UNKNOWN
011523  F6 87 BB 27 80        TEST   byte ptr [bx + 0x27bb], 0x80 ; LOGIC
011528  74 37                 JE     0x11561                      ; UNKNOWN
01152A  80 A7 BB 27 FB        AND    byte ptr [bx + 0x27bb], 0xfb ; LOGIC
01152F  56                    PUSH   si                           ; UNKNOWN
011530  57                    PUSH   di                           ; UNKNOWN
011531  FC                    CLD                                 ; UNKNOWN
011532  8B F2                 MOV    si, dx                       ; UNKNOWN
011534  8B FA                 MOV    di, dx                       ; UNKNOWN
011536  8B C8                 MOV    cx, ax                       ; UNKNOWN
011538  E3 25                 JCXZ   0x1155f                      ; UNKNOWN
01153A  B4 0D                 MOV    ah, 0xd                      ; UNKNOWN
01153C  80 3C 0A              CMP    byte ptr [si], 0xa           ; UNKNOWN
01153F  75 05                 JNE    0x11546                      ; UNKNOWN
011541  80 8F BB 27 04        OR     byte ptr [bx + 0x27bb], 4    ; LOGIC
011546  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
011547  3A C4                 CMP    al, ah                       ; UNKNOWN
011549  74 19                 JE     0x11564                      ; UNKNOWN
01154B  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
01154D  75 07                 JNE    0x11556                      ; UNKNOWN
01154F  80 8F BB 27 02        OR     byte ptr [bx + 0x27bb], 2    ; LOGIC
011554  EB 05                 JMP    0x1155b                      ; UNKNOWN
011556  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
011558  47                    INC    di                           ; UNKNOWN
011559  E2 EB                 LOOP   0x11546                      ; UNKNOWN
01155B  8B C7                 MOV    ax, di                       ; UNKNOWN
01155D  2B C2                 SUB    ax, dx                       ; UNKNOWN
01155F  5F                    POP    di                           ; UNKNOWN
011560  5E                    POP    si                           ; UNKNOWN
