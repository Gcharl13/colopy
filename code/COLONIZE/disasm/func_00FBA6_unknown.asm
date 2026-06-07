; ============================================================================
; func_00FBA6_unknown
; Region   : load_image
; Bytes    : file 0x00FBA6..0x00FC1F  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FBA6  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
00FBAA  57                    PUSH   di                           ; UNKNOWN
00FBAB  56                    PUSH   si                           ; UNKNOWN
00FBAC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00FBAF  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
00FBB4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FBB7  6A 00                 PUSH   0                            ; UNKNOWN
00FBB9  6A 02                 PUSH   2                            ; UNKNOWN
00FBBB  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
00FBBF  8A 87 DD 79           MOV    al, byte ptr [bx + 0x79dd]   ; UNKNOWN
00FBC3  2A E4                 SUB    ah, ah                       ; UNKNOWN
00FBC5  50                    PUSH   ax                           ; UNKNOWN
00FBC6  8A 87 DC 79           MOV    al, byte ptr [bx + 0x79dc]   ; UNKNOWN
00FBCA  50                    PUSH   ax                           ; UNKNOWN
00FBCB  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
00FBD0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00FBD3  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
00FBD6  48                    DEC    ax                           ; UNKNOWN
00FBD7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00FBDA  0B C0                 OR     ax, ax                       ; UNKNOWN
00FBDC  7C 3F                 JL     0xfc1d                       ; UNKNOWN
00FBDE  6B C0 1C              IMUL   ax, ax, 0x1c                 ; UNKNOWN
00FBE1  05 86 88              ADD    ax, 0x8886                   ; UNKNOWN
00FBE4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00FBE7  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
00FBEA  8A 47 FD              MOV    al, byte ptr [bx - 3]        ; UNKNOWN
00FBED  24 0F                 AND    al, 0xf                      ; UNKNOWN
00FBEF  3C 04                 CMP    al, 4                        ; UNKNOWN
00FBF1  72 21                 JB     0xfc14                       ; UNKNOWN
00FBF3  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
00FBF5  88 46 F2              MOV    byte ptr [bp - 0xe], al      ; UNKNOWN
00FBF8  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
00FBFB  75 0D                 JNE    0xfc0a                       ; UNKNOWN
00FBFD  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
00FC00  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
00FC05  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FC08  EB 0A                 JMP    0xfc14                       ; UNKNOWN
00FC0A  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
00FC0D  38 46 F2              CMP    byte ptr [bp - 0xe], al      ; UNKNOWN
00FC10  7E 02                 JLE    0xfc14                       ; UNKNOWN
00FC12  FE 0F                 DEC    byte ptr [bx]                ; UNKNOWN
00FC14  83 6E FC 1C           SUB    word ptr [bp - 4], 0x1c      ; UNKNOWN
00FC18  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
00FC1B  79 CA                 JNS    0xfbe7                       ; UNKNOWN
00FC1D  8B                    DB     0x8B                         ; UNKNOWN (raw)
00FC1E  46                    DB     0x46                         ; UNKNOWN (raw)
