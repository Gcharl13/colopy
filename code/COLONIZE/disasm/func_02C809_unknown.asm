; ============================================================================
; func_02C809_unknown
; Region   : load_image
; Bytes    : file 0x02C809..0x02C8AE  (165 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C809  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
02C80D  57                    PUSH   di                           ; UNKNOWN
02C80E  56                    PUSH   si                           ; UNKNOWN
02C80F  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
02C812  50                    PUSH   ax                           ; UNKNOWN
02C813  8D 4E AC              LEA    cx, [bp - 0x54]              ; UNKNOWN
02C816  51                    PUSH   cx                           ; UNKNOWN
02C817  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02C81A  0E                    PUSH   cs                           ; UNKNOWN
02C81B  E8 AA FF              CALL   0x2c7c8                      ; UNKNOWN
02C81E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02C821  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02C825  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02C829  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02C82D  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02C831  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02C835  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02C839  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02C83D  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02C841  6A 5A                 PUSH   0x5a                         ; UNKNOWN
02C843  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
02C846  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
02C849  BB 44 00              MOV    bx, 0x44                     ; UNKNOWN
02C84C  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02C851  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02C854  0B C0                 OR     ax, ax                       ; UNKNOWN
02C856  74 0B                 JE     0x2c863                      ; UNKNOWN
02C858  48                    DEC    ax                           ; UNKNOWN
02C859  74 0E                 JE     0x2c869                      ; UNKNOWN
02C85B  48                    DEC    ax                           ; UNKNOWN
02C85C  74 11                 JE     0x2c86f                      ; UNKNOWN
02C85E  48                    DEC    ax                           ; UNKNOWN
02C85F  74 14                 JE     0x2c875                      ; UNKNOWN
02C861  EB 18                 JMP    0x2c87b                      ; UNKNOWN
02C863  C6 46 A8 0A           MOV    byte ptr [bp - 0x58], 0xa    ; UNKNOWN
02C867  EB 16                 JMP    0x2c87f                      ; UNKNOWN
02C869  C6 46 A8 09           MOV    byte ptr [bp - 0x58], 9      ; UNKNOWN
02C86D  EB 10                 JMP    0x2c87f                      ; UNKNOWN
02C86F  C6 46 A8 0E           MOV    byte ptr [bp - 0x58], 0xe    ; UNKNOWN
02C873  EB 0A                 JMP    0x2c87f                      ; UNKNOWN
02C875  C6 46 A8 0D           MOV    byte ptr [bp - 0x58], 0xd    ; UNKNOWN
02C879  EB 04                 JMP    0x2c87f                      ; UNKNOWN
02C87B  C6 46 A8 0C           MOV    byte ptr [bp - 0x58], 0xc    ; UNKNOWN
02C87F  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02C882  2A E4                 SUB    ah, ah                       ; UNKNOWN
02C884  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02C887  74 03                 JE     0x2c88c                      ; UNKNOWN
02C889  E9 F7 00              JMP    0x2c983                      ; UNKNOWN
02C88C  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02C890  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02C894  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02C898  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02C89C  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
02C89F  83 C0 59              ADD    ax, 0x59                     ; UNKNOWN
02C8A2  50                    PUSH   ax                           ; UNKNOWN
02C8A3  8A 46 A8              MOV    al, byte ptr [bp - 0x58]     ; UNKNOWN
02C8A6  50                    PUSH   ax                           ; UNKNOWN
02C8A7  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
02C8AA  8B D8                 MOV    bx, ax                       ; UNKNOWN
02C8AC  83                    DB     0x83                         ; UNKNOWN (raw)
02C8AD  C3                    DB     0xC3                         ; UNKNOWN (raw)
