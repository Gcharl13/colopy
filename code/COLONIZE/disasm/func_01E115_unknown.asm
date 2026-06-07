; ============================================================================
; func_01E115_unknown
; Region   : load_image
; Bytes    : file 0x01E115..0x01E18F  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E115  C8 48 00 00           ENTER  0x48, 0                      ; UNKNOWN
01E119  56                    PUSH   si                           ; UNKNOWN
01E11A  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
01E11D  89 46 C8              MOV    word ptr [bp - 0x38], ax     ; UNKNOWN
01E120  89 46 D0              MOV    word ptr [bp - 0x30], ax     ; UNKNOWN
01E123  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
01E127  8A 87 DC 79           MOV    al, byte ptr [bx + 0x79dc]   ; UNKNOWN
01E12B  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E12D  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
01E130  8A 8F DD 79           MOV    cl, byte ptr [bx + 0x79dd]   ; UNKNOWN
01E134  2A ED                 SUB    ch, ch                       ; UNKNOWN
01E136  89 4E D4              MOV    word ptr [bp - 0x2c], cx     ; UNKNOWN
01E139  51                    PUSH   cx                           ; UNKNOWN
01E13A  50                    PUSH   ax                           ; UNKNOWN
01E13B  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
01E140  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01E143  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01E146  2B C0                 SUB    ax, ax                       ; UNKNOWN
01E148  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
01E14B  89 46 C0              MOV    word ptr [bp - 0x40], ax     ; UNKNOWN
01E14E  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
01E151  EB 0D                 JMP    0x1e160                      ; UNKNOWN
01E153  8B 76 D2              MOV    si, word ptr [bp - 0x2e]     ; UNKNOWN
01E156  D1 E6                 SHL    si, 1                        ; UNKNOWN
01E158  C7 42 E2 00 00        MOV    word ptr [bp + si - 0x1e], 0 ; UNKNOWN
01E15D  FF 46 D2              INC    word ptr [bp - 0x2e]         ; UNKNOWN
01E160  83 7E D2 04           CMP    word ptr [bp - 0x2e], 4      ; UNKNOWN
01E164  7C ED                 JL     0x1e153                      ; UNKNOWN
01E166  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
01E16A  8A 87 DE 79           MOV    al, byte ptr [bx + 0x79de]   ; UNKNOWN
01E16E  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E170  6B F0 4E              IMUL   si, ax, 0x4e                 ; UNKNOWN
01E173  8A 84 8E 7E           MOV    al, byte ptr [si + 0x7e8e]   ; UNKNOWN
01E177  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
01E17A  8A 87 E1 79           MOV    al, byte ptr [bx + 0x79e1]   ; UNKNOWN
01E17E  98                    CWDE                                ; UNKNOWN
01E17F  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01E182  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; UNKNOWN
01E187  E9 A8 00              JMP    0x1e232                      ; UNKNOWN
01E18A  6B 5E CA 1C           IMUL   bx, word ptr [bp - 0x36], 0x1c ; UNKNOWN
01E18E  80                    DB     0x80                         ; UNKNOWN (raw)
