; ============================================================================
; func_04B1EB_unknown
; Region   : load_image
; Bytes    : file 0x04B1EB..0x04B22F  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04B1EB  55                    PUSH   bp                           ; UNKNOWN
04B1EC  8B EC                 MOV    bp, sp                       ; UNKNOWN
04B1EE  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
04B1F2  7D 05                 JGE    0x4b1f9                      ; UNKNOWN
04B1F4  C7 46 08 B8 00        MOV    word ptr [bp + 8], 0xb8      ; UNKNOWN
04B1F9  83 7E 06 FF           CMP    word ptr [bp + 6], -1        ; UNKNOWN
04B1FD  75 05                 JNE    0x4b204                      ; UNKNOWN
04B1FF  C7 46 06 91 00        MOV    word ptr [bp + 6], 0x91      ; UNKNOWN
04B204  83 7E 06 FE           CMP    word ptr [bp + 6], -2        ; UNKNOWN
04B208  75 05                 JNE    0x4b20f                      ; UNKNOWN
04B20A  C7 46 06 1E 01        MOV    word ptr [bp + 6], 0x11e     ; UNKNOWN
04B20F  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04B213  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04B217  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04B21B  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04B21F  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04B222  83 C0 0D              ADD    ax, 0xd                      ; UNKNOWN
04B225  50                    PUSH   ax                           ; UNKNOWN
04B226  6A 77                 PUSH   0x77                         ; UNKNOWN
04B228  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04B22B  8B D8                 MOV    bx, ax                       ; UNKNOWN
04B22D  83                    DB     0x83                         ; UNKNOWN (raw)
04B22E  C3                    DB     0xC3                         ; UNKNOWN (raw)
