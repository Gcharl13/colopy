; ============================================================================
; func_01EB3C_unknown
; Region   : load_image
; Bytes    : file 0x01EB3C..0x01EB9B  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01EB3C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01EB40  57                    PUSH   di                           ; UNKNOWN
01EB41  56                    PUSH   si                           ; UNKNOWN
01EB42  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
01EB45  48                    DEC    ax                           ; UNKNOWN
01EB46  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01EB49  EB 1B                 JMP    0x1eb66                      ; UNKNOWN
01EB4B  6A 01                 PUSH   1                            ; UNKNOWN
01EB4D  68 9C 17              PUSH   0x179c                       ; UNKNOWN
01EB50  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01EB55  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01EB58  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01EB5B  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
01EB60  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01EB63  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
01EB66  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
01EB6A  7D 03                 JGE    0x1eb6f                      ; UNKNOWN
01EB6C  E9 A0 00              JMP    0x1ec0f                      ; UNKNOWN
01EB6F  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
01EB72  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01EB76  38 87 80 88           CMP    byte ptr [bx - 0x7780], al   ; UNKNOWN
01EB7A  75 E7                 JNE    0x1eb63                      ; UNKNOWN
01EB7C  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
01EB7F  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01EB83  38 87 81 88           CMP    byte ptr [bx - 0x777f], al   ; UNKNOWN
01EB87  75 DA                 JNE    0x1eb63                      ; UNKNOWN
01EB89  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01EB8D  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
01EB91  24 0F                 AND    al, 0xf                      ; UNKNOWN
01EB93  3A 06 4A 3E           CMP    al, byte ptr [0x3e4a]        ; UNKNOWN
01EB97  74 CA                 JE     0x1eb63                      ; UNKNOWN
01EB99  6B                    DB     0x6B                         ; UNKNOWN (raw)
01EB9A  5E                    DB     0x5E                         ; UNKNOWN (raw)
