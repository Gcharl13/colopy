; ============================================================================
; func_04208D_unknown
; Region   : load_image
; Bytes    : file 0x04208D..0x04211B  (142 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04208D  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
042091  53                    PUSH   bx                           ; UNKNOWN
042092  52                    PUSH   dx                           ; UNKNOWN
042093  50                    PUSH   ax                           ; UNKNOWN
042094  56                    PUSH   si                           ; UNKNOWN
042095  2B C0                 SUB    ax, ax                       ; UNKNOWN
042097  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
04209A  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
04209D  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
0420A0  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
0420A3  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0420A6  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
0420A9  EB 1A                 JMP    0x420c5                      ; UNKNOWN
0420AB  8B D8                 MOV    bx, ax                       ; UNKNOWN
0420AD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0420AF  8B 87 62 C1           MOV    ax, word ptr [bx - 0x3e9e]   ; UNKNOWN
0420B3  01 46 DC              ADD    word ptr [bp - 0x24], ax     ; UNKNOWN
0420B6  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0420B9  7E 07                 JLE    0x420c2                      ; UNKNOWN
0420BB  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
0420BE  48                    DEC    ax                           ; UNKNOWN
0420BF  01 46 F6              ADD    word ptr [bp - 0xa], ax      ; UNKNOWN
0420C2  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
0420C5  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
0420C8  39 06 74 C1           CMP    word ptr [0xc174], ax        ; UNKNOWN
0420CC  7F DD                 JG     0x420ab                      ; UNKNOWN
0420CE  2B C0                 SUB    ax, ax                       ; UNKNOWN
0420D0  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
0420D3  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
0420D6  EB 23                 JMP    0x420fb                      ; UNKNOWN
0420D8  8B D8                 MOV    bx, ax                       ; UNKNOWN
0420DA  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0420DC  8B B7 88 C1           MOV    si, word ptr [bx - 0x3e78]   ; UNKNOWN
0420E0  81 E6 FF 0F           AND    si, 0xfff                    ; UNKNOWN
0420E4  8B C6                 MOV    ax, si                       ; UNKNOWN
0420E6  D1 E6                 SHL    si, 1                        ; UNKNOWN
0420E8  03 F0                 ADD    si, ax                       ; UNKNOWN
0420EA  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0420ED  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
0420F1  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
0420F5  01 46 F4              ADD    word ptr [bp - 0xc], ax      ; UNKNOWN
0420F8  FF 46 EA              INC    word ptr [bp - 0x16]         ; UNKNOWN
0420FB  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
0420FE  39 06 74 C1           CMP    word ptr [0xc174], ax        ; UNKNOWN
042102  7F D4                 JG     0x420d8                      ; UNKNOWN
042104  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
042109  A1 74 C1              MOV    ax, word ptr [0xc174]        ; UNKNOWN
04210C  F7 6E F2              IMUL   word ptr [bp - 0xe]          ; UNKNOWN
04210F  2B 46 F4              SUB    ax, word ptr [bp - 0xc]      ; UNKNOWN
042112  F7 D8                 NEG    ax                           ; UNKNOWN
042114  0B C0                 OR     ax, ax                       ; UNKNOWN
042116  7D 02                 JGE    0x4211a                      ; UNKNOWN
042118  2B C0                 SUB    ax, ax                       ; UNKNOWN
04211A  8B                    DB     0x8B                         ; UNKNOWN (raw)
