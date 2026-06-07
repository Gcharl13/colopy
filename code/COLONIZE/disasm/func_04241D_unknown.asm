; ============================================================================
; func_04241D_unknown
; Region   : load_image
; Bytes    : file 0x04241D..0x042446  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04241D  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
042421  56                    PUSH   si                           ; UNKNOWN
042422  2B C0                 SUB    ax, ax                       ; UNKNOWN
042424  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
042427  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04242A  EB 44                 JMP    0x42470                      ; UNKNOWN
04242C  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04242F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042432  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
042437  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04243A  0B C0                 OR     ax, ax                       ; UNKNOWN
04243C  75 2F                 JNE    0x4246d                      ; UNKNOWN
04243E  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
042441  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
042444  8B CB                 MOV    cx, bx                       ; UNKNOWN
