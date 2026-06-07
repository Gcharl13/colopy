; ============================================================================
; func_01287A_unknown
; Region   : load_image
; Bytes    : file 0x01287A..0x012902  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01287A  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
01287E  06                    PUSH   es                           ; UNKNOWN
01287F  1E                    PUSH   ds                           ; UNKNOWN
012880  56                    PUSH   si                           ; UNKNOWN
012881  57                    PUSH   di                           ; UNKNOWN
012882  33 C0                 XOR    ax, ax                       ; UNKNOWN
012884  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
012887  BB FF FF              MOV    bx, 0xffff                   ; UNKNOWN
01288A  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
01288C  CD 21                 INT    0x21                         ; UNKNOWN
01288E  72 03                 JB     0x12893                      ; UNKNOWN
012890  E9 80 00              JMP    0x12913                      ; UNKNOWN
012893  83 EB 02              SUB    bx, 2                        ; UNKNOWN
012896  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
012899  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
01289B  CD 21                 INT    0x21                         ; UNKNOWN
01289D  73 03                 JAE    0x128a2                      ; UNKNOWN
01289F  EB 7F                 JMP    0x12920                      ; UNKNOWN
0128A1  90                    NOP                                 ; UNKNOWN
0128A2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0128A5  50                    PUSH   ax                           ; UNKNOWN
0128A6  48                    DEC    ax                           ; UNKNOWN
0128A7  8E C0                 MOV    es, ax                       ; UNKNOWN
0128A9  BF 08 00              MOV    di, 8                        ; UNKNOWN
0128AC  BE AB 26              MOV    si, 0x26ab                   ; UNKNOWN
0128AF  B9 08 00              MOV    cx, 8                        ; UNKNOWN
0128B2  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; STR
0128B4  58                    POP    ax                           ; UNKNOWN
0128B5  55                    PUSH   bp                           ; UNKNOWN
0128B6  8C D1                 MOV    cx, ss                       ; UNKNOWN
0128B8  89 0E A3 26           MOV    word ptr [0x26a3], cx        ; UNKNOWN
0128BC  89 26 A5 26           MOV    word ptr [0x26a5], sp        ; UNKNOWN
0128C0  1E                    PUSH   ds                           ; UNKNOWN
0128C1  07                    POP    es                           ; UNKNOWN
0128C2  BB A7 26              MOV    bx, 0x26a7                   ; UNKNOWN
0128C5  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0128C7  89 47 02              MOV    word ptr [bx + 2], ax        ; UNKNOWN
0128CA  C5 56 06              LDS    dx, ptr [bp + 6]             ; UNKNOWN
0128CD  B0 03                 MOV    al, 3                        ; UNKNOWN
0128CF  B4 4B                 MOV    ah, 0x4b                     ; UNKNOWN
0128D1  CD 21                 INT    0x21                         ; UNKNOWN
0128D3  BA 5A 1B              MOV    dx, 0x1b5a                   ; UNKNOWN
0128D6  8E DA                 MOV    ds, dx                       ; UNKNOWN
0128D8  8B 16 A3 26           MOV    dx, word ptr [0x26a3]        ; UNKNOWN
0128DC  8E D2                 MOV    ss, dx                       ; UNKNOWN
0128DE  8B 26 A5 26           MOV    sp, word ptr [0x26a5]        ; UNKNOWN
0128E2  5D                    POP    bp                           ; UNKNOWN
0128E3  72 2E                 JB     0x12913                      ; UNKNOWN
0128E5  8E 06 A7 26           MOV    es, word ptr [0x26a7]        ; UNKNOWN
0128E9  26 8B 1E 2A 00        MOV    bx, word ptr es:[0x2a]       ; GLOBAL_LOAD
0128EE  26 A1 2C 00           MOV    ax, word ptr es:[0x2c]       ; GLOBAL_LOAD
0128F2  05 0F 00              ADD    ax, 0xf                      ; UNKNOWN
0128F5  D1 D8                 RCR    ax, 1                        ; UNKNOWN
0128F7  C1 E8 03              SHR    ax, 3                        ; UNKNOWN
0128FA  03 D8                 ADD    bx, ax                       ; UNKNOWN
0128FC  8C C0                 MOV    ax, es                       ; UNKNOWN
0128FE  2B D8                 SUB    bx, ax                       ; UNKNOWN
012900  83                    DB     0x83                         ; UNKNOWN (raw)
012901  C3                    DB     0xC3                         ; UNKNOWN (raw)
