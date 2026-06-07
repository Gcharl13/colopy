; ============================================================================
; func_043B2B_unknown
; Region   : load_image
; Bytes    : file 0x043B2B..0x043BCD  (162 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043B2B  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
043B2F  56                    PUSH   si                           ; UNKNOWN
043B30  2A C0                 SUB    al, al                       ; UNKNOWN
043B32  A2 B9 C1              MOV    byte ptr [0xc1b9], al        ; UNKNOWN
043B35  A2 BC C1              MOV    byte ptr [0xc1bc], al        ; UNKNOWN
043B38  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
043B3D  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
043B40  C6 87 9A C1 00        MOV    byte ptr [bx - 0x3e66], 0    ; UNKNOWN
043B45  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
043B48  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
043B4C  7C EF                 JL     0x43b3d                      ; UNKNOWN
043B4E  83 3E 34 0B 00        CMP    word ptr [0xb34], 0          ; UNKNOWN
043B53  74 03                 JE     0x43b58                      ; UNKNOWN
043B55  E9 BC 00              JMP    0x43c14                      ; UNKNOWN
043B58  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
043B5D  E9 9C 00              JMP    0x43bfc                      ; UNKNOWN
043B60  A1 94 82              MOV    ax, word ptr [0x8294]        ; UNKNOWN
043B63  F7 D8                 NEG    ax                           ; UNKNOWN
043B65  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
043B68  80 BF 2F 09 00        CMP    byte ptr [bx + 0x92f], 0     ; UNKNOWN
043B6D  7E 05                 JLE    0x43b74                      ; UNKNOWN
043B6F  A1 94 82              MOV    ax, word ptr [0x8294]        ; UNKNOWN
043B72  EB 02                 JMP    0x43b76                      ; UNKNOWN
043B74  2B C0                 SUB    ax, ax                       ; UNKNOWN
043B76  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
043B79  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
043B7D  98                    CWDE                                ; UNKNOWN
043B7E  8B D8                 MOV    bx, ax                       ; UNKNOWN
043B80  03 1E A2 C1           ADD    bx, word ptr [0xc1a2]        ; UNKNOWN
043B84  8E 06 A4 C1           MOV    es, word ptr [0xc1a4]        ; UNKNOWN
043B88  03 5E F2              ADD    bx, word ptr [bp - 0xe]      ; UNKNOWN
043B8B  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
043B8E  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043B91  24 1F                 AND    al, 0x1f                     ; UNKNOWN
043B93  88 46 F6              MOV    byte ptr [bp - 0xa], al      ; UNKNOWN
043B96  3C 18                 CMP    al, 0x18                     ; UNKNOWN
043B98  73 04                 JAE    0x43b9e                      ; UNKNOWN
043B9A  80 66 F6 07           AND    byte ptr [bp - 0xa], 7       ; UNKNOWN
043B9E  8A 46 F6              MOV    al, byte ptr [bp - 0xa]      ; UNKNOWN
043BA1  2A E4                 SUB    ah, ah                       ; UNKNOWN
043BA3  50                    PUSH   ax                           ; UNKNOWN
043BA4  9A FE 05 C9 33        LCALL  0x33c9, 0x5fe                ; UNKNOWN
043BA9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
043BAC  3C 19                 CMP    al, 0x19                     ; UNKNOWN
043BAE  74 49                 JE     0x43bf9                      ; UNKNOWN
043BB0  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
043BB2  74 45                 JE     0x43bf9                      ; UNKNOWN
043BB4  8A 4E FC              MOV    cl, byte ptr [bp - 4]        ; UNKNOWN
043BB7  B0 01                 MOV    al, 1                        ; UNKNOWN
043BB9  D2 E0                 SHL    al, cl                       ; UNKNOWN
043BBB  08 06 BC C1           OR     byte ptr [0xc1bc], al        ; UNKNOWN
043BBF  FE 06 B9 C1           INC    byte ptr [0xc1b9]            ; UNKNOWN
043BC3  F6 46 FC 01           TEST   byte ptr [bp - 4], 1         ; UNKNOWN
043BC7  74 10                 JE     0x43bd9                      ; UNKNOWN
043BC9  8A D9                 MOV    bl, cl                       ; UNKNOWN
043BCB  FE C3                 INC    bl                           ; UNKNOWN
