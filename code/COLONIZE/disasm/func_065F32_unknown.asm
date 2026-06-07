; ============================================================================
; func_065F32_unknown
; Region   : load_image
; Bytes    : file 0x065F32..0x065FB8  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065F32  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
065F36  06                    PUSH   es                           ; UNKNOWN
065F37  1E                    PUSH   ds                           ; UNKNOWN
065F38  56                    PUSH   si                           ; UNKNOWN
065F39  57                    PUSH   di                           ; UNKNOWN
065F3A  33 C0                 XOR    ax, ax                       ; UNKNOWN
065F3C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
065F3F  BB FF FF              MOV    bx, 0xffff                   ; UNKNOWN
065F42  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
065F44  CD 21                 INT    0x21                         ; UNKNOWN
065F46  72 02                 JB     0x65f4a                      ; UNKNOWN
065F48  EB 7E                 JMP    0x65fc8                      ; UNKNOWN
065F4A  83 EB 02              SUB    bx, 2                        ; UNKNOWN
065F4D  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
065F50  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
065F52  CD 21                 INT    0x21                         ; UNKNOWN
065F54  73 02                 JAE    0x65f58                      ; UNKNOWN
065F56  EB 7D                 JMP    0x65fd5                      ; UNKNOWN
065F58  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
065F5B  50                    PUSH   ax                           ; UNKNOWN
065F5C  48                    DEC    ax                           ; UNKNOWN
065F5D  8E C0                 MOV    es, ax                       ; UNKNOWN
065F5F  BF 08 00              MOV    di, 8                        ; UNKNOWN
065F62  BE C4 30              MOV    si, 0x30c4                   ; UNKNOWN
065F65  B9 08 00              MOV    cx, 8                        ; UNKNOWN
065F68  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
065F6A  58                    POP    ax                           ; UNKNOWN
065F6B  55                    PUSH   bp                           ; UNKNOWN
065F6C  8C D1                 MOV    cx, ss                       ; UNKNOWN
065F6E  89 0E FF 0E           MOV    word ptr [0xeff], cx         ; UNKNOWN
065F72  89 26 01 0F           MOV    word ptr [0xf01], sp         ; UNKNOWN
065F76  1E                    PUSH   ds                           ; UNKNOWN
065F77  07                    POP    es                           ; UNKNOWN
065F78  BB 03 0F              MOV    bx, 0xf03                    ; UNKNOWN
065F7B  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
065F7D  89 47 02              MOV    word ptr [bx + 2], ax        ; UNKNOWN
065F80  C5 56 06              LDS    dx, ptr [bp + 6]             ; UNKNOWN
065F83  B0 03                 MOV    al, 3                        ; UNKNOWN
065F85  B4 4B                 MOV    ah, 0x4b                     ; UNKNOWN
065F87  CD 21                 INT    0x21                         ; UNKNOWN
065F89  BA F7 62              MOV    dx, 0x62f7                   ; UNKNOWN
065F8C  8E DA                 MOV    ds, dx                       ; UNKNOWN
065F8E  8B 16 FF 0E           MOV    dx, word ptr [0xeff]         ; UNKNOWN
065F92  8E D2                 MOV    ss, dx                       ; UNKNOWN
065F94  8B 26 01 0F           MOV    sp, word ptr [0xf01]         ; UNKNOWN
065F98  5D                    POP    bp                           ; UNKNOWN
065F99  72 2D                 JB     0x65fc8                      ; UNKNOWN
065F9B  8E 06 03 0F           MOV    es, word ptr [0xf03]         ; UNKNOWN
065F9F  26 8B 1E 2A 00        MOV    bx, word ptr es:[0x2a]       ; UNKNOWN
065FA4  26 A1 2C 00           MOV    ax, word ptr es:[0x2c]       ; UNKNOWN
065FA8  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
065FAB  D1 D8                 RCR    ax, 1                        ; UNKNOWN
065FAD  C1 E8 03              SHR    ax, 3                        ; UNKNOWN
065FB0  03 D8                 ADD    bx, ax                       ; UNKNOWN
065FB2  8C C0                 MOV    ax, es                       ; UNKNOWN
065FB4  2B D8                 SUB    bx, ax                       ; UNKNOWN
065FB6  83                    DB     0x83                         ; UNKNOWN (raw)
065FB7  C3                    DB     0xC3                         ; UNKNOWN (raw)
