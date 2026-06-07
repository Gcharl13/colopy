; ============================================================================
; func_040896_unknown
; Region   : load_image
; Bytes    : file 0x040896..0x0408F8  (98 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040896  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
04089A  57                    PUSH   di                           ; UNKNOWN
04089B  56                    PUSH   si                           ; UNKNOWN
04089C  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04089F  2B FF                 SUB    di, di                       ; UNKNOWN
0408A1  8B C6                 MOV    ax, si                       ; UNKNOWN
0408A3  0E                    PUSH   cs                           ; UNKNOWN
0408A4  E8 D1 F2              CALL   0x3fb78                      ; UNKNOWN
0408A7  8B F0                 MOV    si, ax                       ; UNKNOWN
0408A9  0B F6                 OR     si, si                       ; UNKNOWN
0408AB  7D 03                 JGE    0x408b0                      ; UNKNOWN
0408AD  E9 AE 01              JMP    0x40a5e                      ; UNKNOWN
0408B0  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0408B3  89 5E FA              MOV    word ptr [bp - 6], bx        ; UNKNOWN
0408B6  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
0408BA  2A E4                 SUB    ah, ah                       ; UNKNOWN
0408BC  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0408BF  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0408C2  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0408C5  83 F8 0E              CMP    ax, 0xe                      ; UNKNOWN
0408C8  76 03                 JBE    0x408cd                      ; UNKNOWN
0408CA  E9 82 01              JMP    0x40a4f                      ; UNKNOWN
0408CD  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0408CF  93                    XCHG   bx, ax                       ; UNKNOWN
0408D0  2E FF A7 65 0D        JMP    word ptr cs:[bx + 0xd65]     ; UNKNOWN
0408D5  83 0D DF              OR     word ptr [di], 0xffdf        ; UNKNOWN
0408D8  0E                    PUSH   cs                           ; UNKNOWN
0408D9  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; UNKNOWN
0408DA  0D 9D 0D              OR     ax, 0xd9d                    ; UNKNOWN
0408DD  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
0408DE  0D CC 0D              OR     ax, 0xdcc                    ; UNKNOWN
0408E1  D2 0D                 ROR    byte ptr [di], cl            ; UNKNOWN
0408E3  DF 0E DF 0E           FISTTP word ptr [0xedf]             ; UNKNOWN
0408E7  DF 0E 01 0E           FISTTP word ptr [0xe01]             ; UNKNOWN
0408EB  31 0E 75 0E           XOR    word ptr [0xe75], cx         ; UNKNOWN
0408EF  7C 0E                 JL     0x408ff                      ; UNKNOWN
0408F1  A3 0E 8B              MOV    word ptr [0x8b0e], ax        ; UNKNOWN
0408F4  5E                    POP    si                           ; UNKNOWN
0408F5  FC                    CLD                                 ; UNKNOWN
0408F6  8B C3                 MOV    ax, bx                       ; UNKNOWN
