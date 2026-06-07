; ============================================================================
; func_04599D_unknown
; Region   : load_image
; Bytes    : file 0x04599D..0x0459EC  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04599D  C8 46 00 00           ENTER  0x46, 0                      ; UNKNOWN
0459A1  50                    PUSH   ax                           ; UNKNOWN
0459A2  56                    PUSH   si                           ; UNKNOWN
0459A3  C7 46 E6 FF FF        MOV    word ptr [bp - 0x1a], 0xffff ; UNKNOWN
0459A8  C7 46 D0 00 00        MOV    word ptr [bp - 0x30], 0      ; UNKNOWN
0459AD  F6 06 A8 09 40        TEST   byte ptr [0x9a8], 0x40       ; UNKNOWN
0459B2  74 1B                 JE     0x459cf                      ; UNKNOWN
0459B4  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
0459B9  75 0F                 JNE    0x459ca                      ; UNKNOWN
0459BB  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0459BE  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0459C2  24 0F                 AND    al, 0xf                      ; UNKNOWN
0459C4  3A 06 0E 3E           CMP    al, byte ptr [0x3e0e]        ; UNKNOWN
0459C8  75 05                 JNE    0x459cf                      ; UNKNOWN
0459CA  C7 46 D0 01 00        MOV    word ptr [bp - 0x30], 1      ; UNKNOWN
0459CF  6B 5E B8 1C           IMUL   bx, word ptr [bp - 0x48], 0x1c ; UNKNOWN
0459D3  8A 87 89 88           MOV    al, byte ptr [bx - 0x7777]   ; UNKNOWN
0459D7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0459D9  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
0459DC  8A 87 8A 88           MOV    al, byte ptr [bx - 0x7776]   ; UNKNOWN
0459E0  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
0459E3  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0459E7  89 46 CA              MOV    word ptr [bp - 0x36], ax     ; UNKNOWN
0459EA  8A                    DB     0x8A                         ; UNKNOWN (raw)
0459EB  87                    DB     0x87                         ; UNKNOWN (raw)
