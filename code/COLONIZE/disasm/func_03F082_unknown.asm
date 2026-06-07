; ============================================================================
; func_03F082_unknown
; Region   : load_image
; Bytes    : file 0x03F082..0x03F101  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F082  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
03F086  53                    PUSH   bx                           ; UNKNOWN
03F087  52                    PUSH   dx                           ; UNKNOWN
03F088  50                    PUSH   ax                           ; UNKNOWN
03F089  57                    PUSH   di                           ; UNKNOWN
03F08A  56                    PUSH   si                           ; UNKNOWN
03F08B  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03F090  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff    ; UNKNOWN
03F095  8B F8                 MOV    di, ax                       ; UNKNOWN
03F097  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
03F09A  40                    INC    ax                           ; UNKNOWN
03F09B  3B C7                 CMP    ax, di                       ; UNKNOWN
03F09D  7C 59                 JL     0x3f0f8                      ; UNKNOWN
03F09F  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
03F0A2  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
03F0A6  75 49                 JNE    0x3f0f1                      ; UNKNOWN
03F0A8  8B F0                 MOV    si, ax                       ; UNKNOWN
03F0AA  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
03F0AD  40                    INC    ax                           ; UNKNOWN
03F0AE  3B C6                 CMP    ax, si                       ; UNKNOWN
03F0B0  7C 3F                 JL     0x3f0f1                      ; UNKNOWN
03F0B2  56                    PUSH   si                           ; UNKNOWN
03F0B3  57                    PUSH   di                           ; UNKNOWN
03F0B4  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
03F0B9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03F0BC  3B 46 04              CMP    ax, word ptr [bp + 4]        ; UNKNOWN
03F0BF  75 29                 JNE    0x3f0ea                      ; UNKNOWN
03F0C1  56                    PUSH   si                           ; UNKNOWN
03F0C2  57                    PUSH   di                           ; UNKNOWN
03F0C3  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
03F0C8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03F0CB  2A E4                 SUB    ah, ah                       ; UNKNOWN
03F0CD  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03F0D0  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
03F0D4  74 05                 JE     0x3f0db                      ; UNKNOWN
03F0D6  83 F8 01              CMP    ax, 1                        ; UNKNOWN
03F0D9  75 0F                 JNE    0x3f0ea                      ; UNKNOWN
03F0DB  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
03F0DE  89 3F                 MOV    word ptr [bx], di            ; UNKNOWN
03F0E0  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03F0E3  89 37                 MOV    word ptr [bx], si            ; UNKNOWN
03F0E5  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
03F0EA  46                    INC    si                           ; UNKNOWN
03F0EB  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
03F0EF  74 B9                 JE     0x3f0aa                      ; UNKNOWN
03F0F1  47                    INC    di                           ; UNKNOWN
03F0F2  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
03F0F6  74 9F                 JE     0x3f097                      ; UNKNOWN
03F0F8  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
03F0FB  5E                    POP    si                           ; UNKNOWN
03F0FC  5F                    POP    di                           ; UNKNOWN
03F0FD  C9                    LEAVE                               ; UNKNOWN
03F0FE  C2 04 00              RET    4                            ; UNKNOWN
