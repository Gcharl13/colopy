; ============================================================================
; func_04F0DA_unknown
; Region   : load_image
; Bytes    : file 0x04F0DA..0x04F114  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F0DA  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
04F0DE  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
04F0E2  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
04F0E7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F0EA  6A 64                 PUSH   0x64                         ; UNKNOWN
04F0EC  6A 01                 PUSH   1                            ; UNKNOWN
04F0EE  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
04F0F3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F0F6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04F0F9  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F0FD  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04F101  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04F104  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04F107  83 7E FE 5A           CMP    word ptr [bp - 2], 0x5a      ; UNKNOWN
04F10B  7C 18                 JL     0x4f125                      ; UNKNOWN
04F10D  8B D8                 MOV    bx, ax                       ; UNKNOWN
04F10F  80 BF C2 86 03        CMP    byte ptr [bx - 0x793e], 3    ; UNKNOWN
