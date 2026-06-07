; ============================================================================
; func_039E4B_unknown
; Region   : load_image
; Bytes    : file 0x039E4B..0x039F8B  (320 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039E4B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
039E4F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
039E54  83 3E 08 3E 01        CMP    word ptr [0x3e08], 1         ; UNKNOWN
039E59  1B C0                 SBB    ax, ax                       ; UNKNOWN
039E5B  40                    INC    ax                           ; UNKNOWN
039E5C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
039E5F  83 3E 0A 3E 00        CMP    word ptr [0x3e0a], 0         ; UNKNOWN
039E64  7C 33                 JL     0x39e99                      ; UNKNOWN
039E66  C7 06 FF 0A 00 00     MOV    word ptr [0xaff], 0          ; UNKNOWN
039E6C  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
039E6F  9A E8 02 32 18        LCALL  0x1832, 0x2e8                ; UNKNOWN
039E74  6A 01                 PUSH   1                            ; UNKNOWN
039E76  6A 01                 PUSH   1                            ; UNKNOWN
039E78  6A 01                 PUSH   1                            ; UNKNOWN
039E7A  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039E7F  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
039E83  2A E4                 SUB    ah, ah                       ; UNKNOWN
039E85  50                    PUSH   ax                           ; UNKNOWN
039E86  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
039E8A  50                    PUSH   ax                           ; UNKNOWN
039E8B  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
039E90  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
039E93  C7 06 FF 0A 01 00     MOV    word ptr [0xaff], 1          ; UNKNOWN
039E99  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
039E9C  9A EA 13 B7 36        LCALL  0x36b7, 0x13ea               ; UNKNOWN
039EA1  0B C0                 OR     ax, ax                       ; UNKNOWN
039EA3  74 06                 JE     0x39eab                      ; UNKNOWN
039EA5  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
039EA9  74 3C                 JE     0x39ee7                      ; UNKNOWN
039EAB  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
039EAE  9A 79 14 B7 36        LCALL  0x36b7, 0x1479               ; UNKNOWN
039EB3  50                    PUSH   ax                           ; UNKNOWN
039EB4  9A E2 08 B7 36        LCALL  0x36b7, 0x8e2                ; UNKNOWN
039EB9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
039EBC  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039EC1  8A 87 88 88           MOV    al, byte ptr [bx - 0x7778]   ; UNKNOWN
039EC5  2A E4                 SUB    ah, ah                       ; UNKNOWN
039EC7  83 E8 05              SUB    ax, 5                        ; UNKNOWN
039ECA  7C 0A                 JL     0x39ed6                      ; UNKNOWN
039ECC  48                    DEC    ax                           ; UNKNOWN
039ECD  7E 0E                 JLE    0x39edd                      ; UNKNOWN
039ECF  48                    DEC    ax                           ; UNKNOWN
039ED0  48                    DEC    ax                           ; UNKNOWN
039ED1  7C 03                 JL     0x39ed6                      ; UNKNOWN
039ED3  48                    DEC    ax                           ; UNKNOWN
039ED4  7E 07                 JLE    0x39edd                      ; UNKNOWN
039ED6  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
039EDB  EB 0A                 JMP    0x39ee7                      ; UNKNOWN
039EDD  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
039EE2  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
039EE7  83 3E 0A 3E 00        CMP    word ptr [0x3e0a], 0         ; UNKNOWN
039EEC  7C 69                 JL     0x39f57                      ; UNKNOWN
039EEE  2B C0                 SUB    ax, ax                       ; UNKNOWN
039EF0  A3 08 3E              MOV    word ptr [0x3e08], ax        ; UNKNOWN
039EF3  A3 3E 3E              MOV    word ptr [0x3e3e], ax        ; UNKNOWN
039EF6  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
039EF9  75 56                 JNE    0x39f51                      ; UNKNOWN
039EFB  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039F00  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
039F04  2A E4                 SUB    ah, ah                       ; UNKNOWN
039F06  50                    PUSH   ax                           ; UNKNOWN
039F07  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
039F0B  50                    PUSH   ax                           ; UNKNOWN
039F0C  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
039F11  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039F14  0B C0                 OR     ax, ax                       ; UNKNOWN
039F16  74 39                 JE     0x39f51                      ; UNKNOWN
039F18  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
039F1D  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
039F21  2A E4                 SUB    ah, ah                       ; UNKNOWN
039F23  50                    PUSH   ax                           ; UNKNOWN
039F24  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
039F28  50                    PUSH   ax                           ; UNKNOWN
039F29  9A E6 00 0B 38        LCALL  0x380b, 0xe6                 ; UNKNOWN
039F2E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
039F31  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
039F35  74 1A                 JE     0x39f51                      ; UNKNOWN
039F37  6A 00                 PUSH   0                            ; UNKNOWN
039F39  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
039F3D  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
039F41  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
039F45  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
039F49  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
039F4E  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
039F51  0E                    PUSH   cs                           ; UNKNOWN
039F52  E8 DC FB              CALL   0x39b31                      ; UNKNOWN
039F55  EB 1E                 JMP    0x39f75                      ; UNKNOWN
039F57  C7 06 3E 3E 01 00     MOV    word ptr [0x3e3e], 1         ; UNKNOWN
039F5D  0E                    PUSH   cs                           ; UNKNOWN
039F5E  E8 9E F9              CALL   0x398ff                      ; UNKNOWN
039F61  83 3E D0 79 00        CMP    word ptr [0x79d0], 0         ; UNKNOWN
039F66  74 0D                 JE     0x39f75                      ; UNKNOWN
039F68  F6 06 FB 3D 08        TEST   byte ptr [0x3dfb], 8         ; UNKNOWN
039F6D  75 06                 JNE    0x39f75                      ; UNKNOWN
039F6F  C7 06 3C 3E 00 00     MOV    word ptr [0x3e3c], 0         ; UNKNOWN
039F75  83 3E 0A 3E 00        CMP    word ptr [0x3e0a], 0         ; UNKNOWN
039F7A  7C 0A                 JL     0x39f86                      ; UNKNOWN
039F7C  F6 06 FA 3D 80        TEST   byte ptr [0x3dfa], 0x80      ; UNKNOWN
039F81  74 03                 JE     0x39f86                      ; UNKNOWN
039F83  E8 FE F0              CALL   0x39084                      ; UNKNOWN
039F86  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
039F89  C9                    LEAVE                               ; UNKNOWN
039F8A  CB                    RETF                                ; UNKNOWN
