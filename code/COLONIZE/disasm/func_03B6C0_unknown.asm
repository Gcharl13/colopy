; ============================================================================
; func_03B6C0_unknown
; Region   : load_image
; Bytes    : file 0x03B6C0..0x03B78A  (202 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B6C0  C8 1E 00 00           ENTER  0x1e, 0                      ; UNKNOWN
03B6C4  2B C0                 SUB    ax, ax                       ; UNKNOWN
03B6C6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03B6C9  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03B6CC  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03B6CF  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
03B6D2  74 30                 JE     0x3b704                      ; UNKNOWN
03B6D4  7E 03                 JLE    0x3b6d9                      ; UNKNOWN
03B6D6  E9 A3 07              JMP    0x3be7c                      ; UNKNOWN
03B6D9  48                    DEC    ax                           ; UNKNOWN
03B6DA  74 0C                 JE     0x3b6e8                      ; UNKNOWN
03B6DC  48                    DEC    ax                           ; UNKNOWN
03B6DD  74 10                 JE     0x3b6ef                      ; UNKNOWN
03B6DF  48                    DEC    ax                           ; UNKNOWN
03B6E0  74 14                 JE     0x3b6f6                      ; UNKNOWN
03B6E2  48                    DEC    ax                           ; UNKNOWN
03B6E3  74 18                 JE     0x3b6fd                      ; UNKNOWN
03B6E5  E9 E2 08              JMP    0x3bfca                      ; UNKNOWN
03B6E8  0E                    PUSH   cs                           ; UNKNOWN
03B6E9  E8 E5 F9              CALL   0x3b0d1                      ; UNKNOWN
03B6EC  E9 DB 08              JMP    0x3bfca                      ; UNKNOWN
03B6EF  0E                    PUSH   cs                           ; UNKNOWN
03B6F0  E8 21 FB              CALL   0x3b214                      ; UNKNOWN
03B6F3  E9 D4 08              JMP    0x3bfca                      ; UNKNOWN
03B6F6  0E                    PUSH   cs                           ; UNKNOWN
03B6F7  E8 AD FC              CALL   0x3b3a7                      ; UNKNOWN
03B6FA  E9 CD 08              JMP    0x3bfca                      ; UNKNOWN
03B6FD  0E                    PUSH   cs                           ; UNKNOWN
03B6FE  E8 3C FD              CALL   0x3b43d                      ; UNKNOWN
03B701  E9 C6 08              JMP    0x3bfca                      ; UNKNOWN
03B704  9A 80 01 58 06        LCALL  0x658, 0x180                 ; UNKNOWN
03B709  E9 BE 08              JMP    0x3bfca                      ; UNKNOWN
03B70C  9A 4A 03 58 06        LCALL  0x658, 0x34a                 ; UNKNOWN
03B711  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03B714  0B C0                 OR     ax, ax                       ; UNKNOWN
03B716  75 03                 JNE    0x3b71b                      ; UNKNOWN
03B718  E9 C6 02              JMP    0x3b9e1                      ; UNKNOWN
03B71B  48                    DEC    ax                           ; UNKNOWN
03B71C  48                    DEC    ax                           ; UNKNOWN
03B71D  74 03                 JE     0x3b722                      ; UNKNOWN
03B71F  E9 A8 08              JMP    0x3bfca                      ; UNKNOWN
03B722  C7 06 3A 3E 00 00     MOV    word ptr [0x3e3a], 0         ; UNKNOWN
03B728  E9 9F 08              JMP    0x3bfca                      ; UNKNOWN
03B72B  9A 30 25 63 15        LCALL  0x1563, 0x2530               ; UNKNOWN
03B730  E9 97 08              JMP    0x3bfca                      ; UNKNOWN
03B733  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
03B737  8D 06 FE 23           LEA    ax, [0x23fe]                 ; UNKNOWN
03B73B  2B D2                 SUB    dx, dx                       ; UNKNOWN
03B73D  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
03B742  48                    DEC    ax                           ; UNKNOWN
03B743  74 03                 JE     0x3b748                      ; UNKNOWN
03B745  E9 82 08              JMP    0x3bfca                      ; UNKNOWN
03B748  F6 06 FA 3D 10        TEST   byte ptr [0x3dfa], 0x10      ; UNKNOWN
03B74D  75 D3                 JNE    0x3b722                      ; UNKNOWN
03B74F  9A 87 14 81 20        LCALL  0x2081, 0x1487               ; UNKNOWN
03B754  EB CC                 JMP    0x3b722                      ; UNKNOWN
03B756  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
03B75A  8D 06 05 24           LEA    ax, [0x2405]                 ; UNKNOWN
03B75E  2B D2                 SUB    dx, dx                       ; UNKNOWN
03B760  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
03B765  EB B5                 JMP    0x3b71c                      ; UNKNOWN
03B767  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03B76C  75 15                 JNE    0x3b783                      ; UNKNOWN
03B76E  6A 01                 PUSH   1                            ; UNKNOWN
03B770  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
03B774  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
03B778  9A 9C 02 0B 38        LCALL  0x380b, 0x29c                ; UNKNOWN
03B77D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03B780  E9 47 08              JMP    0x3bfca                      ; UNKNOWN
03B783  6A 00                 PUSH   0                            ; UNKNOWN
03B785  0E                    PUSH   cs                           ; UNKNOWN
03B786  E8 C2 E6              CALL   0x39e4b                      ; UNKNOWN
03B789  E9                    DB     0xE9                         ; UNKNOWN (raw)
