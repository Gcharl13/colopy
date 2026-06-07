; ============================================================================
; func_03C780_unknown
; Region   : load_image
; Bytes    : file 0x03C780..0x03C7C3  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C780  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03C784  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
03C789  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03C78E  75 06                 JNE    0x3c796                      ; UNKNOWN
03C790  C7 06 D0 79 01 00     MOV    word ptr [0x79d0], 1         ; UNKNOWN
03C796  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
03C79B  83 C0 14              ADD    ax, 0x14                     ; UNKNOWN
03C79E  83 D2 00              ADC    dx, 0                        ; UNKNOWN
03C7A1  A3 D6 79              MOV    word ptr [0x79d6], ax        ; UNKNOWN
03C7A4  89 16 D8 79           MOV    word ptr [0x79d8], dx        ; UNKNOWN
03C7A8  83 3E 08 3E 01        CMP    word ptr [0x3e08], 1         ; UNKNOWN
03C7AD  1B C0                 SBB    ax, ax                       ; UNKNOWN
03C7AF  F7 D8                 NEG    ax                           ; UNKNOWN
03C7B1  A3 56 C1              MOV    word ptr [0xc156], ax        ; UNKNOWN
03C7B4  9A 08 01 0B 38        LCALL  0x380b, 0x108                ; UNKNOWN
03C7B9  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
03C7BE  BB 40 00              MOV    bx, 0x40                     ; UNKNOWN
03C7C1  8E C3                 MOV    es, bx                       ; UNKNOWN
