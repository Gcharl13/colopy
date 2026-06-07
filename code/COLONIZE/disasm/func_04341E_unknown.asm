; ============================================================================
; func_04341E_unknown
; Region   : load_image
; Bytes    : file 0x04341E..0x043499  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04341E  C8 2E 00 00           ENTER  0x2e, 0                      ; UNKNOWN
043422  56                    PUSH   si                           ; UNKNOWN
043423  2B C0                 SUB    ax, ax                       ; UNKNOWN
043425  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
043428  A1 26 0A              MOV    ax, word ptr [0xa26]         ; UNKNOWN
04342B  8B 16 28 0A           MOV    dx, word ptr [0xa28]         ; UNKNOWN
04342F  89 46 DC              MOV    word ptr [bp - 0x24], ax     ; UNKNOWN
043432  89 56 DE              MOV    word ptr [bp - 0x22], dx     ; UNKNOWN
043435  80 C4 80              ADD    ah, 0x80                     ; UNKNOWN
043438  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
04343B  89 56 D6              MOV    word ptr [bp - 0x2a], dx     ; UNKNOWN
04343E  FF 36 0A 83           PUSH   word ptr [0x830a]            ; UNKNOWN
043442  FF 36 08 83           PUSH   word ptr [0x8308]            ; UNKNOWN
043446  FF 36 06 83           PUSH   word ptr [0x8306]            ; UNKNOWN
04344A  FF 36 04 83           PUSH   word ptr [0x8304]            ; UNKNOWN
04344E  2A C0                 SUB    al, al                       ; UNKNOWN
043450  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
043455  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1      ; UNKNOWN
04345A  E9 9F 02              JMP    0x436fc                      ; UNKNOWN
04345D  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff  ; UNKNOWN
043462  EB 53                 JMP    0x434b7                      ; UNKNOWN
043464  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
043467  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
04346A  39 06 88 82           CMP    word ptr [0x8288], ax        ; UNKNOWN
04346E  7C 29                 JL     0x43499                      ; UNKNOWN
043470  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
043473  F7 6E F8              IMUL   word ptr [bp - 8]            ; UNKNOWN
043476  8B D8                 MOV    bx, ax                       ; UNKNOWN
043478  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
04347B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04347D  03 5E D4              ADD    bx, word ptr [bp - 0x2c]     ; UNKNOWN
043480  8E 46 D6              MOV    es, word ptr [bp - 0x2a]     ; UNKNOWN
043483  89 5E E0              MOV    word ptr [bp - 0x20], bx     ; UNKNOWN
043486  8C 46 E2              MOV    word ptr [bp - 0x1e], es     ; UNKNOWN
043489  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
04348C  26 39 07              CMP    word ptr es:[bx], ax         ; UNKNOWN
04348F  75 D3                 JNE    0x43464                      ; UNKNOWN
043491  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
043494  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
043497  EB CB                 JMP    0x43464                      ; UNKNOWN
