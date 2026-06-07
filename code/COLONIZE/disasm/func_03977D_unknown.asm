; ============================================================================
; func_03977D_unknown
; Region   : load_image
; Bytes    : file 0x03977D..0x0397CA  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03977D  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
039781  56                    PUSH   si                           ; UNKNOWN
039782  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
039785  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
039788  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0      ; UNKNOWN
03978D  8B 5E AC              MOV    bx, word ptr [bp - 0x54]     ; UNKNOWN
039790  C1 E3 06              SHL    bx, 6                        ; UNKNOWN
039793  03 5E AE              ADD    bx, word ptr [bp - 0x52]     ; UNKNOWN
039796  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
039799  80 BF 2A C7 FF        CMP    byte ptr [bx - 0x38d6], 0xff ; UNKNOWN
03979E  74 21                 JE     0x397c1                      ; UNKNOWN
0397A0  8A 87 2A C7           MOV    al, byte ptr [bx - 0x38d6]   ; UNKNOWN
0397A4  98                    CWDE                                ; UNKNOWN
0397A5  40                    INC    ax                           ; UNKNOWN
0397A6  50                    PUSH   ax                           ; UNKNOWN
0397A7  8A 87 2B C7           MOV    al, byte ptr [bx - 0x38d5]   ; UNKNOWN
0397AB  98                    CWDE                                ; UNKNOWN
0397AC  50                    PUSH   ax                           ; UNKNOWN
0397AD  8A 87 29 C7           MOV    al, byte ptr [bx - 0x38d7]   ; UNKNOWN
0397B1  98                    CWDE                                ; UNKNOWN
0397B2  50                    PUSH   ax                           ; UNKNOWN
0397B3  8A 87 28 C7           MOV    al, byte ptr [bx - 0x38d8]   ; UNKNOWN
0397B7  98                    CWDE                                ; UNKNOWN
0397B8  50                    PUSH   ax                           ; UNKNOWN
0397B9  9A 04 00 AA 38        LCALL  0x38aa, 4                    ; UNKNOWN
0397BE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0397C1  FF 46 AE              INC    word ptr [bp - 0x52]         ; UNKNOWN
0397C4  83 7E AE 40           CMP    word ptr [bp - 0x52], 0x40   ; UNKNOWN
0397C8  7C C3                 JL     0x3978d                      ; UNKNOWN
