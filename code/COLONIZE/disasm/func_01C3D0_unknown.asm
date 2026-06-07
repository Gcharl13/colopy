; ============================================================================
; func_01C3D0_unknown
; Region   : load_image
; Bytes    : file 0x01C3D0..0x01C42C  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C3D0  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01C3D4  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
01C3D9  74 11                 JE     0x1c3ec                      ; UNKNOWN
01C3DB  83 3E FB 08 02        CMP    word ptr [0x8fb], 2          ; UNKNOWN
01C3E0  74 0A                 JE     0x1c3ec                      ; UNKNOWN
01C3E2  C7 06 FB 08 02 00     MOV    word ptr [0x8fb], 2          ; UNKNOWN
01C3E8  0E                    PUSH   cs                           ; UNKNOWN
01C3E9  E8 7F D7              CALL   0x19b6b                      ; UNKNOWN
01C3EC  6A 16                 PUSH   0x16                         ; UNKNOWN
01C3EE  6A 48                 PUSH   0x48                         ; UNKNOWN
01C3F0  68 A5 00              PUSH   0xa5                         ; UNKNOWN
01C3F3  6A 7F                 PUSH   0x7f                         ; UNKNOWN
01C3F5  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
01C3FA  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01C3FD  0B C0                 OR     ax, ax                       ; UNKNOWN
01C3FF  74 06                 JE     0x1c407                      ; UNKNOWN
01C401  C6 46 FE 01           MOV    byte ptr [bp - 2], 1         ; UNKNOWN
01C405  EB 04                 JMP    0x1c40b                      ; UNKNOWN
01C407  C6 46 FE 00           MOV    byte ptr [bp - 2], 0         ; UNKNOWN
01C40B  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
01C410  75 07                 JNE    0x1c419                      ; UNKNOWN
01C412  83 3E C6 32 07        CMP    word ptr [0x32c6], 7         ; UNKNOWN
01C417  75 06                 JNE    0x1c41f                      ; UNKNOWN
01C419  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
01C41C  A2 EA 32              MOV    byte ptr [0x32ea], al        ; UNKNOWN
01C41F  A0 EA 32              MOV    al, byte ptr [0x32ea]        ; UNKNOWN
01C422  2A E4                 SUB    ah, ah                       ; UNKNOWN
01C424  EB 15                 JMP    0x1c43b                      ; UNKNOWN
01C426  0E                    PUSH   cs                           ; UNKNOWN
01C427  E8 6A FD              CALL   0x1c194                      ; UNKNOWN
01C42A  C9                    LEAVE                               ; UNKNOWN
01C42B  CB                    RETF                                ; UNKNOWN
