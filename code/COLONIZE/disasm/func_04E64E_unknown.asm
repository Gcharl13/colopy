; ============================================================================
; func_04E64E_unknown
; Region   : load_image
; Bytes    : file 0x04E64E..0x04E6C2  (116 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E64E  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
04E652  57                    PUSH   di                           ; UNKNOWN
04E653  56                    PUSH   si                           ; UNKNOWN
04E654  A1 0C 3E              MOV    ax, word ptr [0x3e0c]        ; UNKNOWN
04E657  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04E65A  8B D8                 MOV    bx, ax                       ; UNKNOWN
04E65C  8A 87 7A 09           MOV    al, byte ptr [bx + 0x97a]    ; UNKNOWN
04E660  2A E4                 SUB    ah, ah                       ; UNKNOWN
04E662  50                    PUSH   ax                           ; UNKNOWN
04E663  9A A9 00 0B 38        LCALL  0x380b, 0xa9                 ; UNKNOWN
04E668  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E66B  2B C0                 SUB    ax, ax                       ; UNKNOWN
04E66D  A3 E2 0B              MOV    word ptr [0xbe2], ax         ; UNKNOWN
04E670  C7 06 E4 0B FF FF     MOV    word ptr [0xbe4], 0xffff     ; UNKNOWN
04E676  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
04E679  48                    DEC    ax                           ; UNKNOWN
04E67A  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04E67D  EB 15                 JMP    0x4e694                      ; UNKNOWN
04E67F  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c  ; UNKNOWN
04E683  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
04E688  74 07                 JE     0x4e691                      ; UNKNOWN
04E68A  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
04E68F  75 45                 JNE    0x4e6d6                      ; UNKNOWN
04E691  FF 4E FA              DEC    word ptr [bp - 6]            ; UNKNOWN
04E694  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
04E698  7D 03                 JGE    0x4e69d                      ; UNKNOWN
04E69A  E9 66 01              JMP    0x4e803                      ; UNKNOWN
04E69D  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c  ; UNKNOWN
04E6A1  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04E6A5  24 0F                 AND    al, 0xf                      ; UNKNOWN
04E6A7  3A 46 F8              CMP    al, byte ptr [bp - 8]        ; UNKNOWN
04E6AA  75 E5                 JNE    0x4e691                      ; UNKNOWN
04E6AC  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04E6AF  9A E8 02 32 18        LCALL  0x1832, 0x2e8                ; UNKNOWN
04E6B4  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
04E6B7  0E                    PUSH   cs                           ; UNKNOWN
04E6B8  E8 A7 FE              CALL   0x4e562                      ; UNKNOWN
04E6BB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E6BE  0B C0                 OR     ax, ax                       ; UNKNOWN
04E6C0  74 CF                 JE     0x4e691                      ; UNKNOWN
