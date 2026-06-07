; ============================================================================
; func_01748A_unknown
; Region   : load_image
; Bytes    : file 0x01748A..0x01754B  (193 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01748A  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
01748E  56                    PUSH   si                           ; UNKNOWN
01748F  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
017493  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
017496  D1 E3                 SHL    bx, 1                        ; UNKNOWN
017498  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01749C  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
01749F  50                    PUSH   ax                           ; UNKNOWN
0174A0  8B F3                 MOV    si, bx                       ; UNKNOWN
0174A2  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0174A7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0174AA  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174AD  50                    PUSH   ax                           ; UNKNOWN
0174AE  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0174B3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0174B6  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174B9  50                    PUSH   ax                           ; UNKNOWN
0174BA  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
0174BF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0174C2  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0174C6  FF B0 9A 00           PUSH   word ptr [bx + si + 0x9a]    ; UNKNOWN
0174CA  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174CD  16                    PUSH   ss                           ; UNKNOWN
0174CE  50                    PUSH   ax                           ; UNKNOWN
0174CF  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
0174D4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0174D7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174DA  50                    PUSH   ax                           ; UNKNOWN
0174DB  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0174E0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0174E3  FF 36 6E 33           PUSH   word ptr [0x336e]            ; UNKNOWN
0174E7  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174EA  50                    PUSH   ax                           ; UNKNOWN
0174EB  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0174F0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0174F3  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0174F6  50                    PUSH   ax                           ; UNKNOWN
0174F7  9A 8D 00 13 24        LCALL  0x2413, 0x8d                 ; UNKNOWN
0174FC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0174FF  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1      ; UNKNOWN
017504  C7 46 AC B5 00        MOV    word ptr [bp - 0x54], 0xb5   ; UNKNOWN
017509  6B 46 06 13           IMUL   ax, word ptr [bp + 6], 0x13  ; UNKNOWN
01750D  83 C0 0A              ADD    ax, 0xa                      ; UNKNOWN
017510  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
017513  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
017517  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
01751B  8D 4E B0              LEA    cx, [bp - 0x50]              ; UNKNOWN
01751E  16                    PUSH   ss                           ; UNKNOWN
01751F  51                    PUSH   cx                           ; UNKNOWN
017520  8B F0                 MOV    si, ax                       ; UNKNOWN
017522  2B C0                 SUB    ax, ax                       ; UNKNOWN
017524  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
017529  48                    DEC    ax                           ; UNKNOWN
01752A  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
01752D  40                    INC    ax                           ; UNKNOWN
01752E  40                    INC    ax                           ; UNKNOWN
01752F  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
017532  8B C8                 MOV    cx, ax                       ; UNKNOWN
017534  2D 31 01              SUB    ax, 0x131                    ; UNKNOWN
017537  F7 D8                 NEG    ax                           ; UNKNOWN
017539  50                    PUSH   ax                           ; UNKNOWN
01753A  6A 00                 PUSH   0                            ; UNKNOWN
01753C  8B C1                 MOV    ax, cx                       ; UNKNOWN
01753E  D1 F9                 SAR    cx, 1                        ; UNKNOWN
017540  2B F1                 SUB    si, cx                       ; UNKNOWN
017542  56                    PUSH   si                           ; UNKNOWN
017543  8B F0                 MOV    si, ax                       ; UNKNOWN
017545  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
01754A  83                    DB     0x83                         ; UNKNOWN (raw)
