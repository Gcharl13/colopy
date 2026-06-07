; ============================================================================
; func_033650_unknown
; Region   : load_image
; Bytes    : file 0x033650..0x033686  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033650  55                    PUSH   bp                           ; UNKNOWN
033651  8B EC                 MOV    bp, sp                       ; UNKNOWN
033653  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
033657  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
03365B  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
03365F  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
033663  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
033667  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
03366B  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
03366F  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
033673  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
033676  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
033679  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
03367C  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
03367F  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
033684  C9                    LEAVE                               ; UNKNOWN
033685  CB                    RETF                                ; UNKNOWN
