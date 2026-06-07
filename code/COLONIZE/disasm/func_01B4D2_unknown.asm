; ============================================================================
; func_01B4D2_unknown
; Region   : load_image
; Bytes    : file 0x01B4D2..0x01B5F9  (295 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B4D2  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
01B4D6  56                    PUSH   si                           ; UNKNOWN
01B4D7  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
01B4DA  83 E8 08              SUB    ax, 8                        ; UNKNOWN
01B4DD  83 F8 77              CMP    ax, 0x77                     ; UNKNOWN
01B4E0  7E 03                 JLE    0x1b4e5                      ; UNKNOWN
01B4E2  B8 77 00              MOV    ax, 0x77                     ; UNKNOWN
01B4E5  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01B4E8  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
01B4EB  2D C8 00              SUB    ax, 0xc8                     ; UNKNOWN
01B4EE  83 F8 77              CMP    ax, 0x77                     ; UNKNOWN
01B4F1  7E 03                 JLE    0x1b4f6                      ; UNKNOWN
01B4F3  B8 77 00              MOV    ax, 0x77                     ; UNKNOWN
01B4F6  B9 18 00              MOV    cx, 0x18                     ; UNKNOWN
01B4F9  99                    CDQ                                 ; UNKNOWN
01B4FA  F7 F9                 IDIV   cx                           ; UNKNOWN
01B4FC  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01B4FF  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01B502  99                    CDQ                                 ; UNKNOWN
01B503  F7 F9                 IDIV   cx                           ; UNKNOWN
01B505  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01B508  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
01B50C  75 03                 JNE    0x1b511                      ; UNKNOWN
01B50E  E9 1C 02              JMP    0x1b72d                      ; UNKNOWN
01B511  0B C0                 OR     ax, ax                       ; UNKNOWN
01B513  75 03                 JNE    0x1b518                      ; UNKNOWN
01B515  E9 15 02              JMP    0x1b72d                      ; UNKNOWN
01B518  83 7E F6 04           CMP    word ptr [bp - 0xa], 4       ; UNKNOWN
01B51C  75 03                 JNE    0x1b521                      ; UNKNOWN
01B51E  E9 0C 02              JMP    0x1b72d                      ; UNKNOWN
01B521  83 F8 04              CMP    ax, 4                        ; UNKNOWN
01B524  75 03                 JNE    0x1b529                      ; UNKNOWN
01B526  E9 04 02              JMP    0x1b72d                      ; UNKNOWN
01B529  83 3E C6 32 06        CMP    word ptr [0x32c6], 6         ; UNKNOWN
01B52E  74 03                 JE     0x1b533                      ; UNKNOWN
01B530  E9 D1 00              JMP    0x1b604                      ; UNKNOWN
01B533  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
01B538  75 03                 JNE    0x1b53d                      ; UNKNOWN
01B53A  E9 F0 01              JMP    0x1b72d                      ; UNKNOWN
01B53D  50                    PUSH   ax                           ; UNKNOWN
01B53E  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
01B541  9A 96 06 5F 24        LCALL  0x245f, 0x696                ; UNKNOWN
01B546  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01B549  0A C0                 OR     al, al                       ; UNKNOWN
01B54B  7C 03                 JL     0x1b550                      ; UNKNOWN
01B54D  E9 DD 01              JMP    0x1b72d                      ; UNKNOWN
01B550  8B 76 F6              MOV    si, word ptr [bp - 0xa]      ; UNKNOWN
01B553  8B C6                 MOV    ax, si                       ; UNKNOWN
01B555  C1 E6 02              SHL    si, 2                        ; UNKNOWN
01B558  03 F0                 ADD    si, ax                       ; UNKNOWN
01B55A  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
01B55D  80 B8 B0 73 00        CMP    byte ptr [bx + si + 0x73b0], 0 ; UNKNOWN
01B562  74 03                 JE     0x1b567                      ; UNKNOWN
01B564  E9 C6 01              JMP    0x1b72d                      ; UNKNOWN
01B567  A3 FD 08              MOV    word ptr [0x8fd], ax         ; UNKNOWN
01B56A  89 1E FF 08           MOV    word ptr [0x8ff], bx         ; UNKNOWN
01B56E  53                    PUSH   bx                           ; UNKNOWN
01B56F  50                    PUSH   ax                           ; UNKNOWN
01B570  0E                    PUSH   cs                           ; UNKNOWN
01B571  E8 F1 E6              CALL   0x19c65                      ; UNKNOWN
01B574  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01B577  FF 36 44 73           PUSH   word ptr [0x7344]            ; UNKNOWN
01B57B  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
01B580  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B583  83 F8 09              CMP    ax, 9                        ; UNKNOWN
01B586  7D 09                 JGE    0x1b591                      ; UNKNOWN
01B588  83 F8 08              CMP    ax, 8                        ; UNKNOWN
01B58B  74 04                 JE     0x1b591                      ; UNKNOWN
01B58D  0B C0                 OR     ax, ax                       ; UNKNOWN
01B58F  75 35                 JNE    0x1b5c6                      ; UNKNOWN
01B591  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01B595  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01B598  2A E4                 SUB    ah, ah                       ; UNKNOWN
01B59A  03 06 FF 08           ADD    ax, word ptr [0x8ff]         ; UNKNOWN
01B59E  48                    DEC    ax                           ; UNKNOWN
01B59F  48                    DEC    ax                           ; UNKNOWN
01B5A0  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01B5A3  50                    PUSH   ax                           ; UNKNOWN
01B5A4  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01B5A6  2A E4                 SUB    ah, ah                       ; UNKNOWN
01B5A8  03 06 FD 08           ADD    ax, word ptr [0x8fd]         ; UNKNOWN
01B5AC  48                    DEC    ax                           ; UNKNOWN
01B5AD  48                    DEC    ax                           ; UNKNOWN
01B5AE  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01B5B1  50                    PUSH   ax                           ; UNKNOWN
01B5B2  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
01B5B7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01B5BA  0B C0                 OR     ax, ax                       ; UNKNOWN
01B5BC  74 04                 JE     0x1b5c2                      ; UNKNOWN
01B5BE  6A 08                 PUSH   8                            ; UNKNOWN
01B5C0  EB 05                 JMP    0x1b5c7                      ; UNKNOWN
01B5C2  6A 00                 PUSH   0                            ; UNKNOWN
01B5C4  EB 01                 JMP    0x1b5c7                      ; UNKNOWN
01B5C6  50                    PUSH   ax                           ; UNKNOWN
01B5C7  FF 36 44 73           PUSH   word ptr [0x7344]            ; UNKNOWN
01B5CB  0E                    PUSH   cs                           ; UNKNOWN
01B5CC  E8 AD E6              CALL   0x19c7c                      ; UNKNOWN
01B5CF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01B5D2  83 F8 01              CMP    ax, 1                        ; UNKNOWN
01B5D5  1B C0                 SBB    ax, ax                       ; UNKNOWN
01B5D7  F7 D8                 NEG    ax                           ; UNKNOWN
01B5D9  0B C0                 OR     ax, ax                       ; UNKNOWN
01B5DB  74 20                 JE     0x1b5fd                      ; UNKNOWN
01B5DD  FF 36 44 73           PUSH   word ptr [0x7344]            ; UNKNOWN
01B5E1  9A 61 16 5F 24        LCALL  0x245f, 0x1661               ; UNKNOWN
01B5E6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B5E9  A0 44 73              MOV    al, byte ptr [0x7344]        ; UNKNOWN
01B5EC  50                    PUSH   ax                           ; UNKNOWN
01B5ED  FF 36 FF 08           PUSH   word ptr [0x8ff]             ; UNKNOWN
01B5F1  FF 36 FD 08           PUSH   word ptr [0x8fd]             ; UNKNOWN
01B5F5  9A                    DB     0x9A                         ; UNKNOWN (raw)
01B5F6  C2                    DB     0xC2                         ; UNKNOWN (raw)
01B5F7  06                    DB     0x06                         ; UNKNOWN (raw)
01B5F8  5F                    DB     0x5F                         ; UNKNOWN (raw)
