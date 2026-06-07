; ============================================================================
; func_04F506_unknown
; Region   : load_image
; Bytes    : file 0x04F506..0x04F55F  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F506  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F50A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04F50F  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04F512  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04F515  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
04F51A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F51D  0B C0                 OR     ax, ax                       ; UNKNOWN
04F51F  74 39                 JE     0x4f55a                      ; UNKNOWN
04F521  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04F524  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04F527  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04F52C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F52F  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
04F532  75 26                 JNE    0x4f55a                      ; UNKNOWN
04F534  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04F537  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04F53A  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04F53F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04F542  0B C0                 OR     ax, ax                       ; UNKNOWN
04F544  7C 0F                 JL     0x4f555                      ; UNKNOWN
04F546  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04F54A  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
04F54E  83 E1 0F              AND    cx, 0xf                      ; UNKNOWN
04F551  3B C8                 CMP    cx, ax                       ; UNKNOWN
04F553  75 05                 JNE    0x4f55a                      ; UNKNOWN
04F555  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
04F55A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F55D  C9                    LEAVE                               ; UNKNOWN
04F55E  CB                    RETF                                ; UNKNOWN
