; ============================================================================
; func_01D989_unknown
; Region   : load_image
; Bytes    : file 0x01D989..0x01DC3F  (694 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01D989  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
01D98D  56                    PUSH   si                           ; UNKNOWN
01D98E  9A FB 01 E4 35        LCALL  0x35e4, 0x1fb                ; UNKNOWN
01D993  6A 00                 PUSH   0                            ; UNKNOWN
01D995  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
01D99A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D99D  6A 07                 PUSH   7                            ; UNKNOWN
01D99F  68 40 01              PUSH   0x140                        ; UNKNOWN
01D9A2  6A 00                 PUSH   0                            ; UNKNOWN
01D9A4  6A 00                 PUSH   0                            ; UNKNOWN
01D9A6  9A B3 02 2B 3E        LCALL  0x3e2b, 0x2b3                ; UNKNOWN
01D9AB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01D9AE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01D9B1  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01D9B6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D9B9  C7 06 44 73 00 00     MOV    word ptr [0x7344], 0         ; UNKNOWN
01D9BF  9A 8F 26 5F 24        LCALL  0x245f, 0x268f               ; UNKNOWN
01D9C4  C7 06 A4 09 01 00     MOV    word ptr [0x9a4], 1          ; UNKNOWN
01D9CA  0E                    PUSH   cs                           ; UNKNOWN
01D9CB  E8 50 99              CALL   0x1731e                      ; UNKNOWN
01D9CE  83 3E EA 0A 00        CMP    word ptr [0xaea], 0          ; UNKNOWN
01D9D3  7C 0E                 JL     0x1d9e3                      ; UNKNOWN
01D9D5  6A 00                 PUSH   0                            ; UNKNOWN
01D9D7  FF 36 EA 0A           PUSH   word ptr [0xaea]             ; UNKNOWN
01D9DB  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
01D9E0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01D9E3  0E                    PUSH   cs                           ; UNKNOWN
01D9E4  E8 32 99              CALL   0x17319                      ; UNKNOWN
01D9E7  6A 01                 PUSH   1                            ; UNKNOWN
01D9E9  0E                    PUSH   cs                           ; UNKNOWN
01D9EA  E8 EB BF              CALL   0x199d8                      ; UNKNOWN
01D9ED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01D9F0  83 3E EA 0A 00        CMP    word ptr [0xaea], 0          ; UNKNOWN
01D9F5  7C 2D                 JL     0x1da24                      ; UNKNOWN
01D9F7  6A 01                 PUSH   1                            ; UNKNOWN
01D9F9  FF 36 EA 0A           PUSH   word ptr [0xaea]             ; UNKNOWN
01D9FD  9A 06 10 5F 24        LCALL  0x245f, 0x1006               ; UNKNOWN
01DA02  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DA05  0E                    PUSH   cs                           ; UNKNOWN
01DA06  E8 10 99              CALL   0x17319                      ; UNKNOWN
01DA09  6A 00                 PUSH   0                            ; UNKNOWN
01DA0B  0E                    PUSH   cs                           ; UNKNOWN
01DA0C  E8 C9 BF              CALL   0x199d8                      ; UNKNOWN
01DA0F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DA12  B8 54 00              MOV    ax, 0x54                     ; UNKNOWN
01DA15  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
01DA1A  6A 08                 PUSH   8                            ; UNKNOWN
01DA1C  9A 02 00 F1 44        LCALL  0x44f1, 2                    ; UNKNOWN
01DA21  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DA24  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
01DA29  74 08                 JE     0x1da33                      ; UNKNOWN
01DA2B  9A 6B 00 EF 21        LCALL  0x21ef, 0x6b                 ; UNKNOWN
01DA30  E9 D4 02              JMP    0x1dd07                      ; UNKNOWN
01DA33  F6 06 FA 3D 80        TEST   byte ptr [0x3dfa], 0x80      ; UNKNOWN
01DA38  75 03                 JNE    0x1da3d                      ; UNKNOWN
01DA3A  E9 C7 00              JMP    0x1db04                      ; UNKNOWN
01DA3D  F6 06 FE 3D 80        TEST   byte ptr [0x3dfe], 0x80      ; UNKNOWN
01DA42  74 03                 JE     0x1da47                      ; UNKNOWN
01DA44  E9 BD 00              JMP    0x1db04                      ; UNKNOWN
01DA47  6A 00                 PUSH   0                            ; UNKNOWN
01DA49  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
01DA4E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DA51  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
01DA54  83 F8 0D              CMP    ax, 0xd                      ; UNKNOWN
01DA57  75 0C                 JNE    0x1da65                      ; UNKNOWN
01DA59  C7 46 EC 10 00        MOV    word ptr [bp - 0x14], 0x10   ; UNKNOWN
01DA5E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
01DA63  EB 67                 JMP    0x1dacc                      ; UNKNOWN
01DA65  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01DA68  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
01DA6B  50                    PUSH   ax                           ; UNKNOWN
01DA6C  8D 4E F4              LEA    cx, [bp - 0xc]               ; UNKNOWN
01DA6F  51                    PUSH   cx                           ; UNKNOWN
01DA70  2B D2                 SUB    dx, dx                       ; UNKNOWN
01DA72  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
01DA75  52                    PUSH   dx                           ; UNKNOWN
01DA76  9A 0C 16 5F 24        LCALL  0x245f, 0x160c               ; UNKNOWN
01DA7B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01DA7E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01DA82  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01DA84  2A E4                 SUB    ah, ah                       ; UNKNOWN
01DA86  48                    DEC    ax                           ; UNKNOWN
01DA87  48                    DEC    ax                           ; UNKNOWN
01DA88  01 46 F4              ADD    word ptr [bp - 0xc], ax      ; UNKNOWN
01DA8B  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01DA8E  2A E4                 SUB    ah, ah                       ; UNKNOWN
01DA90  48                    DEC    ax                           ; UNKNOWN
01DA91  48                    DEC    ax                           ; UNKNOWN
01DA92  01 46 F2              ADD    word ptr [bp - 0xe], ax      ; UNKNOWN
01DA95  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
01DA98  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
01DA9B  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
01DAA0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DAA3  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01DAA6  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
01DAAB  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
01DAAE  C1 E6 04              SHL    si, 4                        ; UNKNOWN
01DAB1  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
01DAB4  80 B8 BB 34 00        CMP    byte ptr [bx + si + 0x34bb], 0 ; UNKNOWN
01DAB9  74 08                 JE     0x1dac3                      ; UNKNOWN
01DABB  3B 5E EE              CMP    bx, word ptr [bp - 0x12]     ; UNKNOWN
01DABE  74 03                 JE     0x1dac3                      ; UNKNOWN
01DAC0  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
01DAC3  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
01DAC6  83 7E FA 08           CMP    word ptr [bp - 6], 8         ; UNKNOWN
01DACA  7C DF                 JL     0x1daab                      ; UNKNOWN
01DACC  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
01DACF  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01DAD1  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01DAD5  6A 00                 PUSH   0                            ; UNKNOWN
01DAD7  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01DADC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DADF  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
01DAE2  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01DAE4  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
01DAE8  6A 01                 PUSH   1                            ; UNKNOWN
01DAEA  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
01DAEF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DAF2  6A 05                 PUSH   5                            ; UNKNOWN
01DAF4  68 5D 17              PUSH   0x175d                       ; UNKNOWN
01DAF7  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01DAFC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DAFF  80 0E FE 3D 80        OR     byte ptr [0x3dfe], 0x80      ; UNKNOWN
01DB04  F6 06 FA 3D 80        TEST   byte ptr [0x3dfa], 0x80      ; UNKNOWN
01DB09  74 6B                 JE     0x1db76                      ; UNKNOWN
01DB0B  F6 06 FF 3D 80        TEST   byte ptr [0x3dff], 0x80      ; UNKNOWN
01DB10  75 64                 JNE    0x1db76                      ; UNKNOWN
01DB12  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
01DB17  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01DB1B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01DB1D  2A E4                 SUB    ah, ah                       ; UNKNOWN
01DB1F  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
01DB22  2A F6                 SUB    dh, dh                       ; UNKNOWN
01DB24  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
01DB29  EB 1B                 JMP    0x1db46                      ; UNKNOWN
01DB2B  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
01DB2E  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
01DB33  72 0C                 JB     0x1db41                      ; UNKNOWN
01DB35  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
01DB3A  77 05                 JA     0x1db41                      ; UNKNOWN
01DB3C  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
01DB41  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
01DB46  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01DB49  0B C0                 OR     ax, ax                       ; UNKNOWN
01DB4B  7D DE                 JGE    0x1db2b                      ; UNKNOWN
01DB4D  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
01DB51  74 23                 JE     0x1db76                      ; UNKNOWN
01DB53  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
01DB56  40                    INC    ax                           ; UNKNOWN
01DB57  40                    INC    ax                           ; UNKNOWN
01DB58  1E                    PUSH   ds                           ; UNKNOWN
01DB59  50                    PUSH   ax                           ; UNKNOWN
01DB5A  6A 00                 PUSH   0                            ; UNKNOWN
01DB5C  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
01DB61  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01DB64  6A 05                 PUSH   5                            ; UNKNOWN
01DB66  68 67 17              PUSH   0x1767                       ; UNKNOWN
01DB69  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
01DB6E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01DB71  80 0E FF 3D 80        OR     byte ptr [0x3dff], 0x80      ; UNKNOWN
01DB76  C7 06 0C 09 01 00     MOV    word ptr [0x90c], 1          ; UNKNOWN
01DB7C  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
01DB81  83 C0 14              ADD    ax, 0x14                     ; UNKNOWN
01DB84  83 D2 00              ADC    dx, 0                        ; UNKNOWN
01DB87  A3 CC 32              MOV    word ptr [0x32cc], ax        ; UNKNOWN
01DB8A  89 16 CE 32           MOV    word ptr [0x32ce], dx        ; UNKNOWN
01DB8E  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
01DB93  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
01DB98  74 75                 JE     0x1dc0f                      ; UNKNOWN
01DB9A  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
01DB9F  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01DBA2  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
01DBA5  9A F6 00 28 1A        LCALL  0x1a28, 0xf6                 ; UNKNOWN
01DBAA  2B C0                 SUB    ax, ax                       ; UNKNOWN
01DBAC  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
01DBB1  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
01DBB6  75 09                 JNE    0x1dbc1                      ; UNKNOWN
01DBB8  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
01DBBD  0B C0                 OR     ax, ax                       ; UNKNOWN
01DBBF  74 17                 JE     0x1dbd8                      ; UNKNOWN
01DBC1  9A E4 00 EF 21        LCALL  0x21ef, 0xe4                 ; UNKNOWN
01DBC6  6A 05                 PUSH   5                            ; UNKNOWN
01DBC8  9A 0E 01 58 06        LCALL  0x658, 0x10e                 ; UNKNOWN
01DBCD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01DBD0  2B C0                 SUB    ax, ax                       ; UNKNOWN
01DBD2  A3 0C 09              MOV    word ptr [0x90c], ax         ; UNKNOWN
01DBD5  A3 3A 3E              MOV    word ptr [0x3e3a], ax        ; UNKNOWN
01DBD8  2B C0                 SUB    ax, ax                       ; UNKNOWN
01DBDA  8B 16 0C 09           MOV    dx, word ptr [0x90c]         ; UNKNOWN
01DBDE  9A 18 01 8F 5C        LCALL  0x5c8f, 0x118                ; UNKNOWN
01DBE3  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
01DBE8  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
01DBEB  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
01DBEE  2B 46 F6              SUB    ax, word ptr [bp - 0xa]      ; UNKNOWN
01DBF1  1B 56 F8              SBB    dx, word ptr [bp - 8]        ; UNKNOWN
01DBF4  0B D2                 OR     dx, dx                       ; UNKNOWN
01DBF6  7C 0D                 JL     0x1dc05                      ; UNKNOWN
01DBF8  7F 05                 JG     0x1dbff                      ; UNKNOWN
01DBFA  3D 58 02              CMP    ax, 0x258                    ; UNKNOWN
01DBFD  72 06                 JB     0x1dc05                      ; UNKNOWN
01DBFF  C7 06 0C 09 00 00     MOV    word ptr [0x90c], 0          ; UNKNOWN
01DC05  83 3E 0C 09 00        CMP    word ptr [0x90c], 0          ; UNKNOWN
01DC0A  75 99                 JNE    0x1dba5                      ; UNKNOWN
01DC0C  E9 D7 00              JMP    0x1dce6                      ; UNKNOWN
01DC0F  9A F6 00 28 1A        LCALL  0x1a28, 0xf6                 ; UNKNOWN
01DC14  2B C0                 SUB    ax, ax                       ; UNKNOWN
01DC16  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
01DC1B  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
01DC20  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
01DC23  89 56 EA              MOV    word ptr [bp - 0x16], dx     ; UNKNOWN
01DC26  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
01DC2B  74 13                 JE     0x1dc40                      ; UNKNOWN
01DC2D  83 C0 08              ADD    ax, 8                        ; UNKNOWN
01DC30  83 D2 00              ADC    dx, 0                        ; UNKNOWN
01DC33  A3 D0 32              MOV    word ptr [0x32d0], ax        ; UNKNOWN
01DC36  89 16 D2 32           MOV    word ptr [0x32d2], dx        ; UNKNOWN
01DC3A  C7                    DB     0xC7                         ; UNKNOWN (raw)
01DC3B  06                    DB     0x06                         ; UNKNOWN (raw)
01DC3C  CA                    DB     0xCA                         ; UNKNOWN (raw)
01DC3D  32                    DB     0x32                         ; UNKNOWN (raw)
01DC3E  01                    DB     0x01                         ; UNKNOWN (raw)
