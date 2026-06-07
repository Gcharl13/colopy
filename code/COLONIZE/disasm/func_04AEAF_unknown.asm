; ============================================================================
; func_04AEAF_unknown
; Region   : load_image
; Bytes    : file 0x04AEAF..0x04B00F  (352 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04AEAF  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
04AEB3  56                    PUSH   si                           ; UNKNOWN
04AEB4  0E                    PUSH   cs                           ; UNKNOWN
04AEB5  E8 C1 DB              CALL   0x48a79                      ; UNKNOWN
04AEB8  0B C0                 OR     ax, ax                       ; UNKNOWN
04AEBA  74 03                 JE     0x4aebf                      ; UNKNOWN
04AEBC  E9 9B 02              JMP    0x4b15a                      ; UNKNOWN
04AEBF  83 7E 06 07           CMP    word ptr [bp + 6], 7         ; UNKNOWN
04AEC3  75 1A                 JNE    0x4aedf                      ; UNKNOWN
04AEC5  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04AEC8  EB 03                 JMP    0x4aecd                      ; UNKNOWN
04AECA  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
04AECD  83 7E F4 07           CMP    word ptr [bp - 0xc], 7       ; UNKNOWN
04AED1  7D 16                 JGE    0x4aee9                      ; UNKNOWN
04AED3  FF 76 F4              PUSH   word ptr [bp - 0xc]          ; UNKNOWN
04AED6  0E                    PUSH   cs                           ; UNKNOWN
04AED7  E8 49 FE              CALL   0x4ad23                      ; UNKNOWN
04AEDA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AEDD  EB EB                 JMP    0x4aeca                      ; UNKNOWN
04AEDF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04AEE2  0E                    PUSH   cs                           ; UNKNOWN
04AEE3  E8 3D FE              CALL   0x4ad23                      ; UNKNOWN
04AEE6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AEE9  83 3E 3E C6 00        CMP    word ptr [0xc63e], 0         ; UNKNOWN
04AEEE  75 03                 JNE    0x4aef3                      ; UNKNOWN
04AEF0  E9 67 02              JMP    0x4b15a                      ; UNKNOWN
04AEF3  2B C0                 SUB    ax, ax                       ; UNKNOWN
04AEF5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04AEF8  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04AEFB  A3 40 C6              MOV    word ptr [0xc640], ax        ; UNKNOWN
04AEFE  0E                    PUSH   cs                           ; UNKNOWN
04AEFF  E8 96 DC              CALL   0x48b98                      ; UNKNOWN
04AF02  0E                    PUSH   cs                           ; UNKNOWN
04AF03  E8 37 DF              CALL   0x48e3d                      ; UNKNOWN
04AF06  6A 0F                 PUSH   0xf                          ; UNKNOWN
04AF08  6A 05                 PUSH   5                            ; UNKNOWN
04AF0A  68 40 01              PUSH   0x140                        ; UNKNOWN
04AF0D  6A 00                 PUSH   0                            ; UNKNOWN
04AF0F  FF 36 D2 33           PUSH   word ptr [0x33d2]            ; UNKNOWN
04AF13  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
04AF18  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04AF1B  52                    PUSH   dx                           ; UNKNOWN
04AF1C  50                    PUSH   ax                           ; UNKNOWN
04AF1D  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
04AF22  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
04AF25  B8 01 00              MOV    ax, 1                        ; UNKNOWN
04AF28  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04AF2B  50                    PUSH   ax                           ; UNKNOWN
04AF2C  6A 00                 PUSH   0                            ; UNKNOWN
04AF2E  0E                    PUSH   cs                           ; UNKNOWN
04AF2F  E8 1A FC              CALL   0x4ab4c                      ; UNKNOWN
04AF32  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04AF35  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
04AF3A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04AF3F  2B C0                 SUB    ax, ax                       ; UNKNOWN
04AF41  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04AF44  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
04AF49  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
04AF4E  0B C0                 OR     ax, ax                       ; UNKNOWN
04AF50  74 30                 JE     0x4af82                      ; UNKNOWN
04AF52  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
04AF57  83 F8 34              CMP    ax, 0x34                     ; UNKNOWN
04AF5A  74 5A                 JE     0x4afb6                      ; UNKNOWN
04AF5C  7E 03                 JLE    0x4af61                      ; UNKNOWN
04AF5E  E9 90 00              JMP    0x4aff1                      ; UNKNOWN
04AF61  83 F8 32              CMP    ax, 0x32                     ; UNKNOWN
04AF64  74 42                 JE     0x4afa8                      ; UNKNOWN
04AF66  77 1A                 JA     0x4af82                      ; UNKNOWN
04AF68  2C 09                 SUB    al, 9                        ; UNKNOWN
04AF6A  74 63                 JE     0x4afcf                      ; UNKNOWN
04AF6C  2C 04                 SUB    al, 4                        ; UNKNOWN
04AF6E  74 7A                 JE     0x4afea                      ; UNKNOWN
04AF70  2C 0E                 SUB    al, 0xe                      ; UNKNOWN
04AF72  74 06                 JE     0x4af7a                      ; UNKNOWN
04AF74  2C 05                 SUB    al, 5                        ; UNKNOWN
04AF76  74 72                 JE     0x4afea                      ; UNKNOWN
04AF78  EB 08                 JMP    0x4af82                      ; UNKNOWN
04AF7A  2B C0                 SUB    ax, ax                       ; UNKNOWN
04AF7C  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04AF7F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04AF82  6B 06 40 C6 18        IMUL   ax, word ptr [0xc640], 0x18  ; UNKNOWN
04AF87  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
04AF8A  7F 03                 JG     0x4af8f                      ; UNKNOWN
04AF8C  E9 8F 00              JMP    0x4b01e                      ; UNKNOWN
04AF8F  FF 0E 40 C6           DEC    word ptr [0xc640]            ; UNKNOWN
04AF93  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
04AF98  EB E8                 JMP    0x4af82                      ; UNKNOWN
04AF9A  FF 4E FC              DEC    word ptr [bp - 4]            ; UNKNOWN
04AF9D  79 F4                 JNS    0x4af93                      ; UNKNOWN
04AF9F  A1 3E C6              MOV    ax, word ptr [0xc63e]        ; UNKNOWN
04AFA2  48                    DEC    ax                           ; UNKNOWN
04AFA3  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04AFA6  EB EB                 JMP    0x4af93                      ; UNKNOWN
04AFA8  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04AFAB  40                    INC    ax                           ; UNKNOWN
04AFAC  99                    CDQ                                 ; UNKNOWN
04AFAD  F7 3E 3E C6           IDIV   word ptr [0xc63e]            ; UNKNOWN
04AFB1  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
04AFB4  EB DD                 JMP    0x4af93                      ; UNKNOWN
04AFB6  83 6E FC 18           SUB    word ptr [bp - 4], 0x18      ; UNKNOWN
04AFBA  79 D7                 JNS    0x4af93                      ; UNKNOWN
04AFBC  EB 03                 JMP    0x4afc1                      ; UNKNOWN
04AFBE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04AFC1  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04AFC4  83 C0 18              ADD    ax, 0x18                     ; UNKNOWN
04AFC7  3B 06 3E C6           CMP    ax, word ptr [0xc63e]        ; UNKNOWN
04AFCB  7C F1                 JL     0x4afbe                      ; UNKNOWN
04AFCD  EB C4                 JMP    0x4af93                      ; UNKNOWN
04AFCF  A1 3E C6              MOV    ax, word ptr [0xc63e]        ; UNKNOWN
04AFD2  83 46 FC 18           ADD    word ptr [bp - 4], 0x18      ; UNKNOWN
04AFD6  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
04AFD9  7E B8                 JLE    0x4af93                      ; UNKNOWN
04AFDB  EB 03                 JMP    0x4afe0                      ; UNKNOWN
04AFDD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04AFE0  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04AFE3  83 E8 18              SUB    ax, 0x18                     ; UNKNOWN
04AFE6  79 F5                 JNS    0x4afdd                      ; UNKNOWN
04AFE8  EB A9                 JMP    0x4af93                      ; UNKNOWN
04AFEA  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
04AFEF  EB 91                 JMP    0x4af82                      ; UNKNOWN
04AFF1  3D 48 01              CMP    ax, 0x148                    ; UNKNOWN
04AFF4  74 A4                 JE     0x4af9a                      ; UNKNOWN
04AFF6  7F 0C                 JG     0x4b004                      ; UNKNOWN
04AFF8  83 E8 36              SUB    ax, 0x36                     ; UNKNOWN
04AFFB  74 D2                 JE     0x4afcf                      ; UNKNOWN
04AFFD  48                    DEC    ax                           ; UNKNOWN
04AFFE  48                    DEC    ax                           ; UNKNOWN
04AFFF  74 99                 JE     0x4af9a                      ; UNKNOWN
04B001  E9 7E FF              JMP    0x4af82                      ; UNKNOWN
04B004  2D 4B 01              SUB    ax, 0x14b                    ; UNKNOWN
04B007  74 AD                 JE     0x4afb6                      ; UNKNOWN
04B009  48                    DEC    ax                           ; UNKNOWN
04B00A  48                    DEC    ax                           ; UNKNOWN
04B00B  74 C2                 JE     0x4afcf                      ; UNKNOWN
04B00D  83                    DB     0x83                         ; UNKNOWN (raw)
04B00E  E8                    DB     0xE8                         ; UNKNOWN (raw)
