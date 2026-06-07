; ============================================================================
; func_04861F_unknown
; Region   : load_image
; Bytes    : file 0x04861F..0x048652  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04861F  C8 22 00 00           ENTER  0x22, 0                      ; UNKNOWN
048623  56                    PUSH   si                           ; UNKNOWN
048624  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
048629  C7 46 EC FF FF        MOV    word ptr [bp - 0x14], 0xffff ; UNKNOWN
04862E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
048632  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
048636  2A E4                 SUB    ah, ah                       ; UNKNOWN
048638  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
04863B  83 F8 01              CMP    ax, 1                        ; UNKNOWN
04863E  7D 12                 JGE    0x48652                      ; UNKNOWN
048640  6A 03                 PUSH   3                            ; UNKNOWN
048642  6A 16                 PUSH   0x16                         ; UNKNOWN
048644  9A 69 04 0B 38        LCALL  0x380b, 0x469                ; UNKNOWN
048649  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04864C  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
04864F  5E                    POP    si                           ; UNKNOWN
048650  C9                    LEAVE                               ; UNKNOWN
048651  CB                    RETF                                ; UNKNOWN
