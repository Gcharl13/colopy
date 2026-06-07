; ============================================================================
; func_050285_unknown
; Region   : load_image
; Bytes    : file 0x050285..0x0502AD  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050285  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
050289  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05028C  8A 87 BA 86           MOV    al, byte ptr [bx - 0x7946]   ; UNKNOWN
050290  2A E4                 SUB    ah, ah                       ; UNKNOWN
050292  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
050295  8A 87 AE 86           MOV    al, byte ptr [bx - 0x7952]   ; UNKNOWN
050299  83 3E 16 3E 40        CMP    word ptr [0x3e16], 0x40      ; UNKNOWN
05029E  7C 03                 JL     0x502a3                      ; UNKNOWN
0502A0  E9 A0 00              JMP    0x50343                      ; UNKNOWN
0502A3  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0502A6  7D 05                 JGE    0x502ad                      ; UNKNOWN
0502A8  B8 08 00              MOV    ax, 8                        ; UNKNOWN
0502AB  C9                    LEAVE                               ; UNKNOWN
0502AC  CB                    RETF                                ; UNKNOWN
