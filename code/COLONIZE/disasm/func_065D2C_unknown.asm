; ============================================================================
; func_065D2C_unknown
; Region   : load_image
; Bytes    : file 0x065D2C..0x065D90  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065D2C  C8 02 03 00           ENTER  0x302, 0                     ; UNKNOWN
065D30  53                    PUSH   bx                           ; UNKNOWN
065D31  56                    PUSH   si                           ; UNKNOWN
065D32  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
065D37  1E                    PUSH   ds                           ; UNKNOWN
065D38  53                    PUSH   bx                           ; UNKNOWN
065D39  8D 1E C0 30           LEA    bx, [0x30c0]                 ; UNKNOWN
065D3D  9A FC 00 E9 5A        LCALL  0x5ae9, 0xfc                 ; UNKNOWN
065D42  8B F0                 MOV    si, ax                       ; UNKNOWN
065D44  0B F6                 OR     si, si                       ; UNKNOWN
065D46  74 33                 JE     0x65d7b                      ; UNKNOWN
065D48  56                    PUSH   si                           ; UNKNOWN
065D49  6A 01                 PUSH   1                            ; UNKNOWN
065D4B  68 00 03              PUSH   0x300                        ; UNKNOWN
065D4E  8D 86 FE FC           LEA    ax, [bp - 0x302]             ; UNKNOWN
065D52  50                    PUSH   ax                           ; UNKNOWN
065D53  9A F0 03 65 5F        LCALL  0x5f65, 0x3f0                ; UNKNOWN
065D58  83 C4 08              ADD    sp, 8                        ; UNKNOWN
065D5B  0B C0                 OR     ax, ax                       ; UNKNOWN
065D5D  74 1C                 JE     0x65d7b                      ; UNKNOWN
065D5F  68 00 03              PUSH   0x300                        ; UNKNOWN
065D62  8D 86 FE FC           LEA    ax, [bp - 0x302]             ; UNKNOWN
065D66  16                    PUSH   ss                           ; UNKNOWN
065D67  50                    PUSH   ax                           ; UNKNOWN
065D68  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
065D6B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
065D6E  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
065D73  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
065D76  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
065D7B  0B F6                 OR     si, si                       ; UNKNOWN
065D7D  74 09                 JE     0x65d88                      ; UNKNOWN
065D7F  56                    PUSH   si                           ; UNKNOWN
065D80  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
065D85  83 C4 02              ADD    sp, 2                        ; UNKNOWN
065D88  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
065D8B  5E                    POP    si                           ; UNKNOWN
065D8C  C9                    LEAVE                               ; UNKNOWN
065D8D  CA 04 00              RETF   4                            ; UNKNOWN
