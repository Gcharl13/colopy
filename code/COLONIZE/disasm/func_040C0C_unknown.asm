; ============================================================================
; func_040C0C_unknown
; Region   : load_image
; Bytes    : file 0x040C0C..0x040C9F  (147 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040C0C  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
040C10  57                    PUSH   di                           ; UNKNOWN
040C11  56                    PUSH   si                           ; UNKNOWN
040C12  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
040C17  A1 86 0B              MOV    ax, word ptr [0xb86]         ; UNKNOWN
040C1A  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
040C1D  B8 01 00              MOV    ax, 1                        ; UNKNOWN
040C20  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
040C23  A3 86 0B              MOV    word ptr [0xb86], ax         ; UNKNOWN
040C26  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040C29  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
040C2D  74 03                 JE     0x40c32                      ; UNKNOWN
040C2F  E9 8B 00              JMP    0x40cbd                      ; UNKNOWN
040C32  6A 00                 PUSH   0                            ; UNKNOWN
040C34  56                    PUSH   si                           ; UNKNOWN
040C35  0E                    PUSH   cs                           ; UNKNOWN
040C36  E8 0A F4              CALL   0x40043                      ; UNKNOWN
040C39  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040C3C  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040C3F  89 5E F2              MOV    word ptr [bp - 0xe], bx      ; UNKNOWN
040C42  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
040C47  75 74                 JNE    0x40cbd                      ; UNKNOWN
040C49  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
040C4E  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
040C52  24 0F                 AND    al, 0xf                      ; UNKNOWN
040C54  2A 87 80 88           SUB    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040C58  3C 14                 CMP    al, 0x14                     ; UNKNOWN
040C5A  74 61                 JE     0x40cbd                      ; UNKNOWN
040C5C  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040C60  2A E4                 SUB    ah, ah                       ; UNKNOWN
040C62  50                    PUSH   ax                           ; UNKNOWN
040C63  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040C67  50                    PUSH   ax                           ; UNKNOWN
040C68  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
040C6D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040C70  0B C0                 OR     ax, ax                       ; UNKNOWN
040C72  7D 49                 JGE    0x40cbd                      ; UNKNOWN
040C74  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
040C77  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040C7B  2A E4                 SUB    ah, ah                       ; UNKNOWN
040C7D  8B F8                 MOV    di, ax                       ; UNKNOWN
040C7F  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040C83  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
040C86  6A FC                 PUSH   -4                           ; UNKNOWN
040C88  6A FC                 PUSH   -4                           ; UNKNOWN
040C8A  56                    PUSH   si                           ; UNKNOWN
040C8B  0E                    PUSH   cs                           ; UNKNOWN
040C8C  E8 42 F2              CALL   0x3fed1                      ; UNKNOWN
040C8F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
040C92  8B C7                 MOV    ax, di                       ; UNKNOWN
040C94  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
040C97  0E                    PUSH   cs                           ; UNKNOWN
040C98  E8 35 EF              CALL   0x3fbd0                      ; UNKNOWN
040C9B  50                    PUSH   ax                           ; UNKNOWN
040C9C  0E                    PUSH   cs                           ; UNKNOWN
040C9D  E8                    DB     0xE8                         ; UNKNOWN (raw)
040C9E  CB                    DB     0xCB                         ; UNKNOWN (raw)
