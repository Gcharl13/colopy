; ============================================================================
; func_0649D8_unknown
; Region   : load_image
; Bytes    : file 0x0649D8..0x064A17  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0649D8  55                    PUSH   bp                           ; UNKNOWN
0649D9  8B EC                 MOV    bp, sp                       ; UNKNOWN
0649DB  50                    PUSH   ax                           ; UNKNOWN
0649DC  8B D0                 MOV    dx, ax                       ; UNKNOWN
0649DE  2D 10 01              SUB    ax, 0x110                    ; UNKNOWN
0649E1  83 F8 22              CMP    ax, 0x22                     ; UNKNOWN
0649E4  77 4E                 JA     0x64a34                      ; UNKNOWN
0649E6  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0649E8  93                    XCHG   bx, ax                       ; UNKNOWN
0649E9  2E FF A7 1E 00        JMP    word ptr cs:[bx + 0x1e]      ; UNKNOWN
0649EE  7B 00                 JNP    0x649f0                      ; UNKNOWN
0649F0  80 00 85              ADD    byte ptr [bx + si], 0x85     ; UNKNOWN
0649F3  00 8A 00 8F           ADD    byte ptr [bp + si - 0x7100], cl ; UNKNOWN
0649F7  00 94 00 99           ADD    byte ptr [si - 0x6700], dl   ; UNKNOWN
0649FB  00 9E 00 A3           ADD    byte ptr [bp - 0x5d00], bl   ; UNKNOWN
0649FF  00 A8 00 64           ADD    byte ptr [bx + si + 0x6400], ch ; UNKNOWN
064A03  00 64 00              ADD    byte ptr [si], ah            ; UNKNOWN
064A06  64 00 64 00           ADD    byte ptr fs:[si], ah         ; UNKNOWN
064A0A  AD                    LODSW  ax, word ptr [si]            ; UNKNOWN
064A0B  00 B2 00 B7           ADD    byte ptr [bp + si - 0x4900], dh ; UNKNOWN
064A0F  00 BC 00 C1           ADD    byte ptr [si - 0x3f00], bh   ; UNKNOWN
064A13  00 C6                 ADD    dh, al                       ; UNKNOWN
064A15  00 CB                 ADD    bl, cl                       ; UNKNOWN
