; ============================================================================
; func_060822_unknown
; Region   : load_image
; Bytes    : file 0x060822..0x060879  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060822  C8 FE 05 00           ENTER  0x5fe, 0                     ; UNKNOWN
060826  83 BE C8 FE 00        CMP    word ptr [bp - 0x138], 0     ; UNKNOWN
06082B  7C 24                 JL     0x60851                      ; UNKNOWN
06082D  8B B6 C8 FE           MOV    si, word ptr [bp - 0x138]    ; UNKNOWN
060831  D1 E6                 SHL    si, 1                        ; UNKNOWN
060833  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
060837  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; UNKNOWN
06083B  2B 84 C9 73           SUB    ax, word ptr [si + 0x73c9]   ; UNKNOWN
06083F  03 84 88 73           ADD    ax, word ptr [si + 0x7388]   ; UNKNOWN
060843  89 46 8A              MOV    word ptr [bp - 0x76], ax     ; UNKNOWN
060846  0B C0                 OR     ax, ax                       ; UNKNOWN
060848  7C 81                 JL     0x607cb                      ; UNKNOWN
06084A  0B C0                 OR     ax, ax                       ; UNKNOWN
06084C  75 03                 JNE    0x60851                      ; UNKNOWN
06084E  FF 46 8A              INC    word ptr [bp - 0x76]         ; UNKNOWN
060851  8D 46 CE              LEA    ax, [bp - 0x32]              ; UNKNOWN
060854  50                    PUSH   ax                           ; UNKNOWN
060855  FF B6 56 FF           PUSH   word ptr [bp - 0xaa]         ; UNKNOWN
060859  9A 08 1D 5F 24        LCALL  0x245f, 0x1d08               ; UNKNOWN
06085E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
060861  89 86 BE FE           MOV    word ptr [bp - 0x142], ax    ; UNKNOWN
060865  3B 46 8A              CMP    ax, word ptr [bp - 0x76]     ; UNKNOWN
060868  7E 03                 JLE    0x6086d                      ; UNKNOWN
06086A  8B 46 8A              MOV    ax, word ptr [bp - 0x76]     ; UNKNOWN
06086D  89 86 BE FE           MOV    word ptr [bp - 0x142], ax    ; UNKNOWN
060871  83 7E CE 10           CMP    word ptr [bp - 0x32], 0x10   ; UNKNOWN
060875  7D 03                 JGE    0x6087a                      ; UNKNOWN
060877  E9                    DB     0xE9                         ; UNKNOWN (raw)
060878  CF                    DB     0xCF                         ; UNKNOWN (raw)
