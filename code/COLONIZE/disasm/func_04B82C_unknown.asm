; ============================================================================
; func_04B82C_unknown
; Region   : load_image
; Bytes    : file 0x04B82C..0x04B8B7  (139 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04B82C  C8 6E 00 00           ENTER  0x6e, 0                      ; UNKNOWN
04B830  56                    PUSH   si                           ; UNKNOWN
04B831  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04B834  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04B839  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B83C  6A 03                 PUSH   3                            ; UNKNOWN
04B83E  0E                    PUSH   cs                           ; UNKNOWN
04B83F  E8 20 F9              CALL   0x4b162                      ; UNKNOWN
04B842  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B845  68 90 00              PUSH   0x90                         ; UNKNOWN
04B848  6A 05                 PUSH   5                            ; UNKNOWN
04B84A  68 40 01              PUSH   0x140                        ; UNKNOWN
04B84D  6A 00                 PUSH   0                            ; UNKNOWN
04B84F  FF 36 44 33           PUSH   word ptr [0x3344]            ; UNKNOWN
04B853  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04B858  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B85B  52                    PUSH   dx                           ; UNKNOWN
04B85C  50                    PUSH   ax                           ; UNKNOWN
04B85D  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04B862  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04B865  C7 46 AA 04 00        MOV    word ptr [bp - 0x56], 4      ; UNKNOWN
04B86A  C7 46 A6 19 00        MOV    word ptr [bp - 0x5a], 0x19   ; UNKNOWN
04B86F  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
04B873  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
04B878  75 5E                 JNE    0x4b8d8                      ; UNKNOWN
04B87A  FF 36 DA 33           PUSH   word ptr [0x33da]            ; UNKNOWN
04B87E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B881  50                    PUSH   ax                           ; UNKNOWN
04B882  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
04B887  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04B88A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B88D  50                    PUSH   ax                           ; UNKNOWN
04B88E  9A 4D 00 13 24        LCALL  0x2413, 0x4d                 ; UNKNOWN
04B893  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B896  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
04B89A  83 7F 12 00           CMP    word ptr [bx + 0x12], 0      ; UNKNOWN
04B89E  7D 02                 JGE    0x4b8a2                      ; UNKNOWN
04B8A0  EB 7E                 JMP    0x4b920                      ; UNKNOWN
04B8A2  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04B8A5  50                    PUSH   ax                           ; UNKNOWN
04B8A6  9A 7D 00 13 24        LCALL  0x2413, 0x7d                 ; UNKNOWN
04B8AB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04B8AE  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
04B8B2  8B 5F 12              MOV    bx, word ptr [bx + 0x12]     ; UNKNOWN
04B8B5  8B C3                 MOV    ax, bx                       ; UNKNOWN
