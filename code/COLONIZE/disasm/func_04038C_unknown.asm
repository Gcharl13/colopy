; ============================================================================
; func_04038C_unknown
; Region   : load_image
; Bytes    : file 0x04038C..0x040410  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04038C  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
040390  57                    PUSH   di                           ; UNKNOWN
040391  56                    PUSH   si                           ; UNKNOWN
040392  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
040395  0B FF                 OR     di, di                       ; UNKNOWN
040397  7D 03                 JGE    0x4039c                      ; UNKNOWN
040399  E9 B2 00              JMP    0x4044e                      ; UNKNOWN
04039C  6B DF 1C              IMUL   bx, di, 0x1c                 ; UNKNOWN
04039F  89 5E F8              MOV    word ptr [bp - 8], bx        ; UNKNOWN
0403A2  8A 9F 83 88           MOV    bl, byte ptr [bx - 0x777d]   ; UNKNOWN
0403A6  83 E3 0F              AND    bx, 0xf                      ; UNKNOWN
0403A9  7C 10                 JL     0x403bb                      ; UNKNOWN
0403AB  83 FB 04              CMP    bx, 4                        ; UNKNOWN
0403AE  7D 0B                 JGE    0x403bb                      ; UNKNOWN
0403B0  80 BF 92 85 00        CMP    byte ptr [bx - 0x7a6e], 0    ; UNKNOWN
0403B5  74 04                 JE     0x403bb                      ; UNKNOWN
0403B7  FE 8F 92 85           DEC    byte ptr [bx - 0x7a6e]       ; UNKNOWN
0403BB  83 FB 04              CMP    bx, 4                        ; UNKNOWN
0403BE  7C 17                 JL     0x403d7                      ; UNKNOWN
0403C0  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0403C3  80 BF 86 88 00        CMP    byte ptr [bx - 0x777a], 0    ; UNKNOWN
0403C8  7C 0D                 JL     0x403d7                      ; UNKNOWN
0403CA  8A 87 86 88           MOV    al, byte ptr [bx - 0x777a]   ; UNKNOWN
0403CE  98                    CWDE                                ; UNKNOWN
0403CF  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
0403D2  80 8F DF 79 01        OR     byte ptr [bx + 0x79df], 1    ; UNKNOWN
0403D7  8B C7                 MOV    ax, di                       ; UNKNOWN
0403D9  0E                    PUSH   cs                           ; UNKNOWN
0403DA  E8 CE F9              CALL   0x3fdab                      ; UNKNOWN
0403DD  8B F7                 MOV    si, di                       ; UNKNOWN
0403DF  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0403E2  48                    DEC    ax                           ; UNKNOWN
0403E3  3B C7                 CMP    ax, di                       ; UNKNOWN
0403E5  7E 30                 JLE    0x40417                      ; UNKNOWN
0403E7  6B C6 1C              IMUL   ax, si, 0x1c                 ; UNKNOWN
0403EA  05 80 88              ADD    ax, 0x8880                   ; UNKNOWN
0403ED  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0403F0  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
0403F3  2B C6                 SUB    ax, si                       ; UNKNOWN
0403F5  48                    DEC    ax                           ; UNKNOWN
0403F6  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0403F9  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
0403FC  8B DA                 MOV    bx, dx                       ; UNKNOWN
0403FE  8B FA                 MOV    di, dx                       ; UNKNOWN
040400  8D 77 1C              LEA    si, [bx + 0x1c]              ; UNKNOWN
040403  8C D8                 MOV    ax, ds                       ; UNKNOWN
040405  8E C0                 MOV    es, ax                       ; UNKNOWN
040407  B9 0E 00              MOV    cx, 0xe                      ; UNKNOWN
04040A  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
04040C  83 C2 1C              ADD    dx, 0x1c                     ; UNKNOWN
04040F  FF                    DB     0xFF                         ; UNKNOWN (raw)
