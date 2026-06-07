; ============================================================================
; func_0587FC_unknown
; Region   : load_image
; Bytes    : file 0x0587FC..0x05883B  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0587FC  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
058800  56                    PUSH   si                           ; UNKNOWN
058801  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
058805  80 BF 82 88 01        CMP    byte ptr [bx - 0x777e], 1    ; UNKNOWN
05880A  74 0A                 JE     0x58816                      ; UNKNOWN
05880C  80 BF 82 88 04        CMP    byte ptr [bx - 0x777e], 4    ; UNKNOWN
058811  74 03                 JE     0x58816                      ; UNKNOWN
058813  E9 B7 01              JMP    0x589cd                      ; UNKNOWN
058816  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
05881A  80 BF 97 88 15        CMP    byte ptr [bx - 0x7769], 0x15 ; UNKNOWN
05881F  75 1A                 JNE    0x5883b                      ; UNKNOWN
058821  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
058826  75 03                 JNE    0x5882b                      ; UNKNOWN
058828  E9 A2 01              JMP    0x589cd                      ; UNKNOWN
05882B  69 1E 10 3E 3C 01     IMUL   bx, word ptr [0x3e10], 0x13c ; UNKNOWN
058831  F6 87 AA 74 08        TEST   byte ptr [bx + 0x74aa], 8    ; UNKNOWN
058836  75 1C                 JNE    0x58854                      ; UNKNOWN
058838  5E                    POP    si                           ; UNKNOWN
058839  C9                    LEAVE                               ; UNKNOWN
05883A  CB                    RETF                                ; UNKNOWN
