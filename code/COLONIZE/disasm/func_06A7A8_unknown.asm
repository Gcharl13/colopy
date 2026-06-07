; ============================================================================
; func_06A7A8_unknown
; Region   : load_image
; Bytes    : file 0x06A7A8..0x06A825  (125 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A7A8  55                    PUSH   bp                           ; UNKNOWN
06A7A9  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A7AB  83 EC 02              SUB    sp, 2                        ; UNKNOWN
06A7AE  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06A7B1  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
06A7B5  72 06                 JB     0x6a7bd                      ; UNKNOWN
06A7B7  F9                    STC                                 ; UNKNOWN
06A7B8  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
06A7BB  EB 68                 JMP    0x6a825                      ; UNKNOWN
06A7BD  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A7BF  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06A7C2  E3 61                 JCXZ   0x6a825                      ; UNKNOWN
06A7C4  F6 87 47 12 02        TEST   byte ptr [bx + 0x1247], 2    ; UNKNOWN
06A7C9  75 5A                 JNE    0x6a825                      ; UNKNOWN
06A7CB  81 3E A0 15 D6 D6     CMP    word ptr [0x15a0], 0xd6d6    ; UNKNOWN
06A7D1  75 04                 JNE    0x6a7d7                      ; UNKNOWN
06A7D3  FF 16 A2 15           CALL   word ptr [0x15a2]            ; UNKNOWN
06A7D7  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
06A7DA  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06A7DD  B4 3F                 MOV    ah, 0x3f                     ; UNKNOWN
06A7DF  CD 21                 INT    0x21                         ; UNKNOWN
06A7E1  73 04                 JAE    0x6a7e7                      ; UNKNOWN
06A7E3  B4 09                 MOV    ah, 9                        ; UNKNOWN
06A7E5  EB 3E                 JMP    0x6a825                      ; UNKNOWN
06A7E7  F6 87 47 12 80        TEST   byte ptr [bx + 0x1247], 0x80 ; UNKNOWN
06A7EC  74 37                 JE     0x6a825                      ; UNKNOWN
06A7EE  80 A7 47 12 FB        AND    byte ptr [bx + 0x1247], 0xfb ; UNKNOWN
06A7F3  56                    PUSH   si                           ; UNKNOWN
06A7F4  57                    PUSH   di                           ; UNKNOWN
06A7F5  FC                    CLD                                 ; UNKNOWN
06A7F6  8B F2                 MOV    si, dx                       ; UNKNOWN
06A7F8  8B FA                 MOV    di, dx                       ; UNKNOWN
06A7FA  8B C8                 MOV    cx, ax                       ; UNKNOWN
06A7FC  E3 25                 JCXZ   0x6a823                      ; UNKNOWN
06A7FE  B4 0D                 MOV    ah, 0xd                      ; UNKNOWN
06A800  80 3C 0A              CMP    byte ptr [si], 0xa           ; UNKNOWN
06A803  75 05                 JNE    0x6a80a                      ; UNKNOWN
06A805  80 8F 47 12 04        OR     byte ptr [bx + 0x1247], 4    ; UNKNOWN
06A80A  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06A80B  3A C4                 CMP    al, ah                       ; UNKNOWN
06A80D  74 19                 JE     0x6a828                      ; UNKNOWN
06A80F  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
06A811  75 07                 JNE    0x6a81a                      ; UNKNOWN
06A813  80 8F 47 12 02        OR     byte ptr [bx + 0x1247], 2    ; UNKNOWN
06A818  EB 05                 JMP    0x6a81f                      ; UNKNOWN
06A81A  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
06A81C  47                    INC    di                           ; UNKNOWN
06A81D  E2 EB                 LOOP   0x6a80a                      ; UNKNOWN
06A81F  8B C7                 MOV    ax, di                       ; UNKNOWN
06A821  2B C2                 SUB    ax, dx                       ; UNKNOWN
06A823  5F                    POP    di                           ; UNKNOWN
06A824  5E                    POP    si                           ; UNKNOWN
