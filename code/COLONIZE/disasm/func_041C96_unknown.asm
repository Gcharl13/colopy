; ============================================================================
; func_041C96_unknown
; Region   : load_image
; Bytes    : file 0x041C96..0x041CE2  (76 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041C96  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
041C9A  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041C9D  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
041CA0  FF 06 14 3E           INC    word ptr [0x3e14]            ; UNKNOWN
041CA4  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041CA7  50                    PUSH   ax                           ; UNKNOWN
041CA8  9A 0C 0D B7 36        LCALL  0x36b7, 0xd0c                ; UNKNOWN
041CAD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041CB0  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
041CB2  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
041CB6  88 87 80 88           MOV    byte ptr [bx - 0x7780], al   ; UNKNOWN
041CBA  88 87 81 88           MOV    byte ptr [bx - 0x777f], al   ; UNKNOWN
041CBE  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; UNKNOWN
041CC2  F5                    CMC                                 ; UNKNOWN
041CC3  1A C0                 SBB    al, al                       ; UNKNOWN
041CC5  24 0D                 AND    al, 0xd                      ; UNKNOWN
041CC7  88 87 82 88           MOV    byte ptr [bx - 0x777e], al   ; UNKNOWN
041CCB  C6 87 86 88 FF        MOV    byte ptr [bx - 0x777a], 0xff ; UNKNOWN
041CD0  C6 87 8C 88 00        MOV    byte ptr [bx - 0x7774], 0    ; UNKNOWN
041CD5  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
041CD8  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
041CDB  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
041CDE  9A                    DB     0x9A                         ; UNKNOWN (raw)
041CDF  CA                    DB     0xCA                         ; UNKNOWN (raw)
041CE0  02                    DB     0x02                         ; UNKNOWN (raw)
041CE1  B7                    DB     0xB7                         ; UNKNOWN (raw)
