; ============================================================================
; func_016D76_unknown
; Region   : load_image
; Bytes    : file 0x016D76..0x016E8F  (281 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016D76  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
016D7A  56                    PUSH   si                           ; UNKNOWN
016D7B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
016D7F  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
016D81  2A E4                 SUB    ah, ah                       ; UNKNOWN
016D83  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
016D86  2A F6                 SUB    dh, dh                       ; UNKNOWN
016D88  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
016D8D  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
016D90  0B C0                 OR     ax, ax                       ; UNKNOWN
016D92  7C 10                 JL     0x16da4                      ; UNKNOWN
016D94  6A 0A                 PUSH   0xa                          ; UNKNOWN
016D96  50                    PUSH   ax                           ; UNKNOWN
016D97  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
016D9C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
016D9F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
016DA2  EB 05                 JMP    0x16da9                      ; UNKNOWN
016DA4  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
016DA9  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff  ; UNKNOWN
016DAE  2B C0                 SUB    ax, ax                       ; UNKNOWN
016DB0  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
016DB3  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
016DB6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
016DB9  EB 18                 JMP    0x16dd3                      ; UNKNOWN
016DBB  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
016DBE  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
016DC1  2A E4                 SUB    ah, ah                       ; UNKNOWN
016DC3  50                    PUSH   ax                           ; UNKNOWN
016DC4  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
016DC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
016DCC  A8 40                 TEST   al, 0x40                     ; UNKNOWN
016DCE  74 6B                 JE     0x16e3b                      ; UNKNOWN
016DD0  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
016DD3  83 7E FA 08           CMP    word ptr [bp - 6], 8         ; UNKNOWN
016DD7  7D 79                 JGE    0x16e52                      ; UNKNOWN
016DD9  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
016DDC  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
016DE0  98                    CWDE                                ; UNKNOWN
016DE1  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
016DE5  8A 4C 01              MOV    cl, byte ptr [si + 1]        ; UNKNOWN
016DE8  2A ED                 SUB    ch, ch                       ; UNKNOWN
016DEA  03 C1                 ADD    ax, cx                       ; UNKNOWN
016DEC  8B D0                 MOV    dx, ax                       ; UNKNOWN
016DEE  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
016DF2  98                    CWDE                                ; UNKNOWN
016DF3  8A 0C                 MOV    cl, byte ptr [si]            ; UNKNOWN
016DF5  03 C1                 ADD    ax, cx                       ; UNKNOWN
016DF7  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
016DFC  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
016DFF  0B C0                 OR     ax, ax                       ; UNKNOWN
016E01  7C CD                 JL     0x16dd0                      ; UNKNOWN
016E03  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
016E06  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
016E0A  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
016E0D  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
016E10  83 F8 04              CMP    ax, 4                        ; UNKNOWN
016E13  7D BB                 JGE    0x16dd0                      ; UNKNOWN
016E15  6A 0A                 PUSH   0xa                          ; UNKNOWN
016E17  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
016E1A  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
016E1F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
016E22  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
016E25  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
016E29  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
016E2C  2A E4                 SUB    ah, ah                       ; UNKNOWN
016E2E  3B 46 EE              CMP    ax, word ptr [bp - 0x12]     ; UNKNOWN
016E31  75 88                 JNE    0x16dbb                      ; UNKNOWN
016E33  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
016E36  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
016E39  EB 95                 JMP    0x16dd0                      ; UNKNOWN
016E3B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
016E3E  01 46 EC              ADD    word ptr [bp - 0x14], ax     ; UNKNOWN
016E41  39 46 EA              CMP    word ptr [bp - 0x16], ax     ; UNKNOWN
016E44  7F 8A                 JG     0x16dd0                      ; UNKNOWN
016E46  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
016E49  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
016E4C  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
016E4F  E9 7E FF              JMP    0x16dd0                      ; UNKNOWN
016E52  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
016E55  2B 46 FC              SUB    ax, word ptr [bp - 4]        ; UNKNOWN
016E58  79 02                 JNS    0x16e5c                      ; UNKNOWN
016E5A  2B C0                 SUB    ax, ax                       ; UNKNOWN
016E5C  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
016E5F  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
016E63  74 08                 JE     0x16e6d                      ; UNKNOWN
016E65  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
016E68  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
016E6B  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
016E6D  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
016E71  74 08                 JE     0x16e7b                      ; UNKNOWN
016E73  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
016E76  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
016E79  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
016E7B  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
016E7F  74 08                 JE     0x16e89                      ; UNKNOWN
016E81  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
016E84  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
016E87  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
016E89  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
016E8C  5E                    POP    si                           ; UNKNOWN
016E8D  C9                    LEAVE                               ; UNKNOWN
016E8E  CB                    RETF                                ; UNKNOWN
