; ============================================================================
; func_0446C5_unknown
; Region   : load_image
; Bytes    : file 0x0446C5..0x04475D  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0446C5  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
0446C9  53                    PUSH   bx                           ; UNKNOWN
0446CA  52                    PUSH   dx                           ; UNKNOWN
0446CB  50                    PUSH   ax                           ; UNKNOWN
0446CC  56                    PUSH   si                           ; UNKNOWN
0446CD  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0      ; UNKNOWN
0446D2  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0446D6  7C 0F                 JL     0x446e7                      ; UNKNOWN
0446D8  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
0446DB  80 C1 04              ADD    cl, 4                        ; UNKNOWN
0446DE  B0 01                 MOV    al, 1                        ; UNKNOWN
0446E0  D2 E0                 SHL    al, cl                       ; UNKNOWN
0446E2  A2 B4 C1              MOV    byte ptr [0xc1b4], al        ; UNKNOWN
0446E5  EB 05                 JMP    0x446ec                      ; UNKNOWN
0446E7  C6 06 B4 C1 00        MOV    byte ptr [0xc1b4], 0         ; UNKNOWN
0446EC  0E                    PUSH   cs                           ; UNKNOWN
0446ED  E8 96 F2              CALL   0x43986                      ; UNKNOWN
0446F0  8B 46 D2              MOV    ax, word ptr [bp - 0x2e]     ; UNKNOWN
0446F3  39 06 50 85           CMP    word ptr [0x8550], ax        ; UNKNOWN
0446F7  7D 03                 JGE    0x446fc                      ; UNKNOWN
0446F9  E9 7B 02              JMP    0x44977                      ; UNKNOWN
0446FC  8B 46 D4              MOV    ax, word ptr [bp - 0x2c]     ; UNKNOWN
0446FF  39 06 52 85           CMP    word ptr [0x8552], ax        ; UNKNOWN
044703  7D 03                 JGE    0x44708                      ; UNKNOWN
044705  E9 6F 02              JMP    0x44977                      ; UNKNOWN
044708  8B 46 D6              MOV    ax, word ptr [bp - 0x2a]     ; UNKNOWN
04470B  03 46 D2              ADD    ax, word ptr [bp - 0x2e]     ; UNKNOWN
04470E  48                    DEC    ax                           ; UNKNOWN
04470F  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
044712  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
044715  03 46 D4              ADD    ax, word ptr [bp - 0x2c]     ; UNKNOWN
044718  48                    DEC    ax                           ; UNKNOWN
044719  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
04471C  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
04471F  3B 06 50 85           CMP    ax, word ptr [0x8550]        ; UNKNOWN
044723  7E 03                 JLE    0x44728                      ; UNKNOWN
044725  A1 50 85              MOV    ax, word ptr [0x8550]        ; UNKNOWN
044728  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
04472B  8B 4E D2              MOV    cx, word ptr [bp - 0x2e]     ; UNKNOWN
04472E  3B 0E 80 82           CMP    cx, word ptr [0x8280]        ; UNKNOWN
044732  7D 04                 JGE    0x44738                      ; UNKNOWN
044734  8B 0E 80 82           MOV    cx, word ptr [0x8280]        ; UNKNOWN
044738  89 4E D2              MOV    word ptr [bp - 0x2e], cx     ; UNKNOWN
04473B  A1 52 85              MOV    ax, word ptr [0x8552]        ; UNKNOWN
04473E  3B 46 DE              CMP    ax, word ptr [bp - 0x22]     ; UNKNOWN
044741  7E 03                 JLE    0x44746                      ; UNKNOWN
044743  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
044746  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
044749  8B 56 D4              MOV    dx, word ptr [bp - 0x2c]     ; UNKNOWN
04474C  3B 16 86 82           CMP    dx, word ptr [0x8286]        ; UNKNOWN
044750  7D 04                 JGE    0x44756                      ; UNKNOWN
044752  8B 16 86 82           MOV    dx, word ptr [0x8286]        ; UNKNOWN
044756  89 56 D4              MOV    word ptr [bp - 0x2c], dx     ; UNKNOWN
044759  2B C2                 SUB    ax, dx                       ; UNKNOWN
04475B  40                    INC    ax                           ; UNKNOWN
04475C  89                    DB     0x89                         ; UNKNOWN (raw)
