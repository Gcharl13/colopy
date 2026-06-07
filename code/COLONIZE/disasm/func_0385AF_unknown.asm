; ============================================================================
; func_0385AF_unknown
; Region   : load_image
; Bytes    : file 0x0385AF..0x0385C9  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0385AF  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0385B3  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0385B6  C7 07 02 00           MOV    word ptr [bx], 2             ; UNKNOWN
0385BA  2B C0                 SUB    ax, ax                       ; UNKNOWN
0385BC  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0385BF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0385C2  EB 18                 JMP    0x385dc                      ; UNKNOWN
0385C4  69 D8 CA 00           IMUL   bx, ax, 0xca                 ; UNKNOWN
0385C8  8A                    DB     0x8A                         ; UNKNOWN (raw)
