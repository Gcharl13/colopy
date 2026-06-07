; ============================================================================
; func_018A24_unknown
; Region   : load_image
; Bytes    : file 0x018A24..0x018A5C  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018A24  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
018A28  56                    PUSH   si                           ; UNKNOWN
018A29  A0 03 09              MOV    al, byte ptr [0x903]         ; UNKNOWN
018A2C  2A E4                 SUB    ah, ah                       ; UNKNOWN
018A2E  A3 96 0B              MOV    word ptr [0xb96], ax         ; UNKNOWN
018A31  C7 46 FC 86 00        MOV    word ptr [bp - 4], 0x86      ; UNKNOWN
018A36  9A 6D 06 D0 38        LCALL  0x38d0, 0x66d                ; UNKNOWN
018A3B  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
018A40  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
018A43  8B D8                 MOV    bx, ax                       ; UNKNOWN
018A45  D1 E3                 SHL    bx, 1                        ; UNKNOWN
018A47  83 BF 88 73 00        CMP    word ptr [bx + 0x7388], 0    ; UNKNOWN
018A4C  74 1F                 JE     0x18a6d                      ; UNKNOWN
018A4E  83 F8 05              CMP    ax, 5                        ; UNKNOWN
018A51  74 1A                 JE     0x18a6d                      ; UNKNOWN
018A53  0B C0                 OR     ax, ax                       ; UNKNOWN
018A55  74 16                 JE     0x18a6d                      ; UNKNOWN
018A57  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
018A5A  8B CB                 MOV    cx, bx                       ; UNKNOWN
