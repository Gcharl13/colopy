; ============================================================================
; func_03DB88_unknown
; Region   : load_image
; Bytes    : file 0x03DB88..0x03E144  (1468 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03DB88  C8 3C 00 00           ENTER  0x3c, 0                      ; UNKNOWN
03DB8C  57                    PUSH   di                           ; UNKNOWN
03DB8D  56                    PUSH   si                           ; UNKNOWN
03DB8E  68 FF 7F              PUSH   0x7fff                       ; UNKNOWN
03DB91  6A 01                 PUSH   1                            ; UNKNOWN
03DB93  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DB98  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DB9B  A3 40 0B              MOV    word ptr [0xb40], ax         ; UNKNOWN
03DB9E  C7 06 42 0B 00 00     MOV    word ptr [0xb42], 0          ; UNKNOWN
03DBA4  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03DBA8  74 03                 JE     0x3dbad                      ; UNKNOWN
03DBAA  E9 E0 0E              JMP    0x3ea8d                      ; UNKNOWN
03DBAD  C7 06 58 85 00 00     MOV    word ptr [0x8558], 0         ; UNKNOWN
03DBB3  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DBB7  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DBBB  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DBBF  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DBC3  B0 19                 MOV    al, 0x19                     ; UNKNOWN
03DBC5  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
03DBCA  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DBCE  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DBD2  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DBD6  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DBDA  2A C0                 SUB    al, al                       ; UNKNOWN
03DBDC  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
03DBE1  C6 06 56 85 03        MOV    byte ptr [0x8556], 3         ; UNKNOWN
03DBE6  A0 88 82              MOV    al, byte ptr [0x8288]        ; UNKNOWN
03DBE9  2C 06                 SUB    al, 6                        ; UNKNOWN
03DBEB  A2 54 85              MOV    byte ptr [0x8554], al        ; UNKNOWN
03DBEE  C6 06 57 85 00        MOV    byte ptr [0x8557], 0         ; UNKNOWN
03DBF3  A0 8A 82              MOV    al, byte ptr [0x828a]        ; UNKNOWN
03DBF6  A2 55 85              MOV    byte ptr [0x8555], al        ; UNKNOWN
03DBF9  6A 01                 PUSH   1                            ; UNKNOWN
03DBFB  6A 00                 PUSH   0                            ; UNKNOWN
03DBFD  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DC02  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DC05  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03DC08  0B C0                 OR     ax, ax                       ; UNKNOWN
03DC0A  74 07                 JE     0x3dc13                      ; UNKNOWN
03DC0C  C6 06 57 85 05        MOV    byte ptr [0x8557], 5         ; UNKNOWN
03DC11  EB 08                 JMP    0x3dc1b                      ; UNKNOWN
03DC13  A0 8A 82              MOV    al, byte ptr [0x828a]        ; UNKNOWN
03DC16  2C 06                 SUB    al, 6                        ; UNKNOWN
03DC18  A2 55 85              MOV    byte ptr [0x8555], al        ; UNKNOWN
03DC1B  6A 00                 PUSH   0                            ; UNKNOWN
03DC1D  0E                    PUSH   cs                           ; UNKNOWN
03DC1E  E8 57 F9              CALL   0x3d578                      ; UNKNOWN
03DC21  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03DC24  A1 7E 0B              MOV    ax, word ptr [0xb7e]         ; UNKNOWN
03DC27  03 06 7C 0B           ADD    ax, word ptr [0xb7c]         ; UNKNOWN
03DC2B  40                    INC    ax                           ; UNKNOWN
03DC2C  69 C0 40 01           IMUL   ax, ax, 0x140                ; UNKNOWN
03DC30  3B 06 58 85           CMP    ax, word ptr [0x8558]        ; UNKNOWN
03DC34  7F E5                 JG     0x3dc1b                      ; UNKNOWN
03DC36  9A 0E 00 41 3A        LCALL  0x3a41, 0xe                  ; UNKNOWN
03DC3B  2B C0                 SUB    ax, ax                       ; UNKNOWN
03DC3D  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
03DC40  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
03DC43  EB 12                 JMP    0x3dc57                      ; UNKNOWN
03DC45  8B 5E DE              MOV    bx, word ptr [bp - 0x22]     ; UNKNOWN
03DC48  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03DC4A  83 BF 14 83 00        CMP    word ptr [bx - 0x7cec], 0    ; UNKNOWN
03DC4F  74 03                 JE     0x3dc54                      ; UNKNOWN
03DC51  FF 46 E6              INC    word ptr [bp - 0x1a]         ; UNKNOWN
03DC54  FF 46 DE              INC    word ptr [bp - 0x22]         ; UNKNOWN
03DC57  83 7E DE 10           CMP    word ptr [bp - 0x22], 0x10   ; UNKNOWN
03DC5B  7C E8                 JL     0x3dc45                      ; UNKNOWN
03DC5D  B8 0F 00              MOV    ax, 0xf                      ; UNKNOWN
03DC60  2B 46 E6              SUB    ax, word ptr [bp - 0x1a]     ; UNKNOWN
03DC63  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
03DC66  0B C0                 OR     ax, ax                       ; UNKNOWN
03DC68  7E 35                 JLE    0x3dc9f                      ; UNKNOWN
03DC6A  83 3E 7E 0B 00        CMP    word ptr [0xb7e], 0          ; UNKNOWN
03DC6F  7E 13                 JLE    0x3dc84                      ; UNKNOWN
03DC71  50                    PUSH   ax                           ; UNKNOWN
03DC72  6A 00                 PUSH   0                            ; UNKNOWN
03DC74  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DC79  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DC7C  2B 46 D6              SUB    ax, word ptr [bp - 0x2a]     ; UNKNOWN
03DC7F  F7 D8                 NEG    ax                           ; UNKNOWN
03DC81  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
03DC84  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0      ; UNKNOWN
03DC89  EB 0C                 JMP    0x3dc97                      ; UNKNOWN
03DC8B  6A 01                 PUSH   1                            ; UNKNOWN
03DC8D  0E                    PUSH   cs                           ; UNKNOWN
03DC8E  E8 E7 F8              CALL   0x3d578                      ; UNKNOWN
03DC91  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03DC94  FF 46 DE              INC    word ptr [bp - 0x22]         ; UNKNOWN
03DC97  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
03DC9A  39 46 D6              CMP    word ptr [bp - 0x2a], ax     ; UNKNOWN
03DC9D  7F EC                 JG     0x3dc8b                      ; UNKNOWN
03DC9F  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1      ; UNKNOWN
03DCA4  E9 2D 01              JMP    0x3ddd4                      ; UNKNOWN
03DCA7  FF 46 E2              INC    word ptr [bp - 0x1e]         ; UNKNOWN
03DCAA  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03DCAD  48                    DEC    ax                           ; UNKNOWN
03DCAE  3B 46 E2              CMP    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DCB1  7F 03                 JG     0x3dcb6                      ; UNKNOWN
03DCB3  E9 1B 01              JMP    0x3ddd1                      ; UNKNOWN
03DCB6  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0      ; UNKNOWN
03DCBB  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DCBF  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DCC3  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DCC7  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DCCB  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DCCE  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DCD1  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DCD6  0A C0                 OR     al, al                       ; UNKNOWN
03DCD8  74 05                 JE     0x3dcdf                      ; UNKNOWN
03DCDA  C7 46 D2 01 00        MOV    word ptr [bp - 0x2e], 1      ; UNKNOWN
03DCDF  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DCE3  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DCE7  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DCEB  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DCEF  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DCF2  40                    INC    ax                           ; UNKNOWN
03DCF3  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DCF6  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DCFB  0A C0                 OR     al, al                       ; UNKNOWN
03DCFD  74 04                 JE     0x3dd03                      ; UNKNOWN
03DCFF  80 4E D2 02           OR     byte ptr [bp - 0x2e], 2      ; UNKNOWN
03DD03  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DD07  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DD0B  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DD0F  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DD13  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DD16  42                    INC    dx                           ; UNKNOWN
03DD17  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DD1A  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DD1F  0A C0                 OR     al, al                       ; UNKNOWN
03DD21  74 04                 JE     0x3dd27                      ; UNKNOWN
03DD23  80 4E D2 04           OR     byte ptr [bp - 0x2e], 4      ; UNKNOWN
03DD27  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DD2B  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DD2F  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DD33  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DD37  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DD3A  40                    INC    ax                           ; UNKNOWN
03DD3B  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DD3E  42                    INC    dx                           ; UNKNOWN
03DD3F  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DD44  0A C0                 OR     al, al                       ; UNKNOWN
03DD46  74 04                 JE     0x3dd4c                      ; UNKNOWN
03DD48  80 4E D2 08           OR     byte ptr [bp - 0x2e], 8      ; UNKNOWN
03DD4C  83 7E D2 06           CMP    word ptr [bp - 0x2e], 6      ; UNKNOWN
03DD50  74 09                 JE     0x3dd5b                      ; UNKNOWN
03DD52  83 7E D2 09           CMP    word ptr [bp - 0x2e], 9      ; UNKNOWN
03DD56  74 03                 JE     0x3dd5b                      ; UNKNOWN
03DD58  E9 4C FF              JMP    0x3dca7                      ; UNKNOWN
03DD5B  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DD5F  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DD63  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DD67  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DD6B  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DD6E  40                    INC    ax                           ; UNKNOWN
03DD6F  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DD72  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03DD75  8B F0                 MOV    si, ax                       ; UNKNOWN
03DD77  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DD7C  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DD80  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DD84  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DD88  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DD8C  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DD8F  42                    INC    dx                           ; UNKNOWN
03DD90  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DD93  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03DD96  8B FA                 MOV    di, dx                       ; UNKNOWN
03DD98  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DD9D  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DDA1  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DDA5  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DDA9  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DDAD  8B C6                 MOV    ax, si                       ; UNKNOWN
03DDAF  8B D7                 MOV    dx, di                       ; UNKNOWN
03DDB1  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03DDB4  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DDB9  83 7E E2 00           CMP    word ptr [bp - 0x1e], 0      ; UNKNOWN
03DDBD  74 03                 JE     0x3ddc2                      ; UNKNOWN
03DDBF  FF 4E E2              DEC    word ptr [bp - 0x1e]         ; UNKNOWN
03DDC2  83 7E DC 00           CMP    word ptr [bp - 0x24], 0      ; UNKNOWN
03DDC6  75 03                 JNE    0x3ddcb                      ; UNKNOWN
03DDC8  E9 DC FE              JMP    0x3dca7                      ; UNKNOWN
03DDCB  FF 4E DC              DEC    word ptr [bp - 0x24]         ; UNKNOWN
03DDCE  E9 D6 FE              JMP    0x3dca7                      ; UNKNOWN
03DDD1  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
03DDD4  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DDD7  48                    DEC    ax                           ; UNKNOWN
03DDD8  3B 46 DC              CMP    ax, word ptr [bp - 0x24]     ; UNKNOWN
03DDDB  7E 08                 JLE    0x3dde5                      ; UNKNOWN
03DDDD  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1      ; UNKNOWN
03DDE2  E9 C5 FE              JMP    0x3dcaa                      ; UNKNOWN
03DDE5  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03DDEA  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
03DDEF  E9 39 01              JMP    0x3df2b                      ; UNKNOWN
03DDF2  6A 10                 PUSH   0x10                         ; UNKNOWN
03DDF4  6A 01                 PUSH   1                            ; UNKNOWN
03DDF6  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DDFB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DDFE  8B C8                 MOV    cx, ax                       ; UNKNOWN
03DE00  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DE03  D1 F8                 SAR    ax, 1                        ; UNKNOWN
03DE05  2B C1                 SUB    ax, cx                       ; UNKNOWN
03DE07  2B 46 DC              SUB    ax, word ptr [bp - 0x24]     ; UNKNOWN
03DE0A  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03DE0D  F7 D0                 NOT    ax                           ; UNKNOWN
03DE0F  40                    INC    ax                           ; UNKNOWN
03DE10  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03DE13  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03DE16  2B 06 80 0B           SUB    ax, word ptr [0xb80]         ; UNKNOWN
03DE1A  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03DE1C  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
03DE1F  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03DE22  0B C0                 OR     ax, ax                       ; UNKNOWN
03DE24  7D 02                 JGE    0x3de28                      ; UNKNOWN
03DE26  2B C0                 SUB    ax, ax                       ; UNKNOWN
03DE28  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03DE2B  C1 7E FA 02           SAR    word ptr [bp - 6], 2         ; UNKNOWN
03DE2F  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03DE32  EB 2A                 JMP    0x3de5e                      ; UNKNOWN
03DE34  C7 46 D2 05 00        MOV    word ptr [bp - 0x2e], 5      ; UNKNOWN
03DE39  EB 3C                 JMP    0x3de77                      ; UNKNOWN
03DE3B  C7 46 D2 04 00        MOV    word ptr [bp - 0x2e], 4      ; UNKNOWN
03DE40  EB 35                 JMP    0x3de77                      ; UNKNOWN
03DE42  C7 46 D2 01 00        MOV    word ptr [bp - 0x2e], 1      ; UNKNOWN
03DE47  EB 2E                 JMP    0x3de77                      ; UNKNOWN
03DE49  C7 46 D2 03 00        MOV    word ptr [bp - 0x2e], 3      ; UNKNOWN
03DE4E  EB 27                 JMP    0x3de77                      ; UNKNOWN
03DE50  C7 46 D2 02 00        MOV    word ptr [bp - 0x2e], 2      ; UNKNOWN
03DE55  EB 20                 JMP    0x3de77                      ; UNKNOWN
03DE57  C7 46 D2 00 00        MOV    word ptr [bp - 0x2e], 0      ; UNKNOWN
03DE5C  EB 19                 JMP    0x3de77                      ; UNKNOWN
03DE5E  83 F8 05              CMP    ax, 5                        ; UNKNOWN
03DE61  77 F4                 JA     0x3de57                      ; UNKNOWN
03DE63  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03DE65  93                    XCHG   bx, ax                       ; UNKNOWN
03DE66  2E FF A7 9B 0B        JMP    word ptr cs:[bx + 0xb9b]     ; UNKNOWN
03DE6B  64 0B 6B 0B           OR     bp, word ptr fs:[bp + di + 0xb] ; UNKNOWN
03DE6F  72 0B                 JB     0x3de7c                      ; UNKNOWN
03DE71  79 0B                 JNS    0x3de7e                      ; UNKNOWN
03DE73  80 0B 80              OR     byte ptr [bp + di], 0x80     ; UNKNOWN
03DE76  0B 83 7E EA           OR     ax, word ptr [bp + di - 0x1582] ; UNKNOWN
03DE7A  00 75 05              ADD    byte ptr [di + 5], dh        ; UNKNOWN
03DE7D  C7 46 D2 19 00        MOV    word ptr [bp - 0x2e], 0x19   ; UNKNOWN
03DE82  83 7E EA 02           CMP    word ptr [bp - 0x16], 2      ; UNKNOWN
03DE86  7C 04                 JL     0x3de8c                      ; UNKNOWN
03DE88  80 4E D2 20           OR     byte ptr [bp - 0x2e], 0x20   ; UNKNOWN
03DE8C  83 7E EA 03           CMP    word ptr [bp - 0x16], 3      ; UNKNOWN
03DE90  7C 04                 JL     0x3de96                      ; UNKNOWN
03DE92  80 4E D2 80           OR     byte ptr [bp - 0x2e], 0x80   ; UNKNOWN
03DE96  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03DE9A  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03DE9E  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03DEA2  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03DEA6  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DEA9  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DEAC  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
03DEAF  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03DEB4  FF 46 E2              INC    word ptr [bp - 0x1e]         ; UNKNOWN
03DEB7  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03DEBA  39 46 E2              CMP    word ptr [bp - 0x1e], ax     ; UNKNOWN
03DEBD  7D 64                 JGE    0x3df23                      ; UNKNOWN
03DEBF  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03DEC3  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03DEC7  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03DECB  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03DECF  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03DED2  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03DED5  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03DEDA  2A E4                 SUB    ah, ah                       ; UNKNOWN
03DEDC  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03DEDF  C7 46 D2 19 00        MOV    word ptr [bp - 0x2e], 0x19   ; UNKNOWN
03DEE4  6A 10                 PUSH   0x10                         ; UNKNOWN
03DEE6  6A 01                 PUSH   1                            ; UNKNOWN
03DEE8  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DEED  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DEF0  8B 0E 8A 82           MOV    cx, word ptr [0x828a]        ; UNKNOWN
03DEF4  D1 F9                 SAR    cx, 1                        ; UNKNOWN
03DEF6  2B C8                 SUB    cx, ax                       ; UNKNOWN
03DEF8  2B 4E DC              SUB    cx, word ptr [bp - 0x24]     ; UNKNOWN
03DEFB  83 C1 08              ADD    cx, 8                        ; UNKNOWN
03DEFE  0B C9                 OR     cx, cx                       ; UNKNOWN
03DF00  7F 03                 JG     0x3df05                      ; UNKNOWN
03DF02  E9 ED FE              JMP    0x3ddf2                      ; UNKNOWN
03DF05  6A 10                 PUSH   0x10                         ; UNKNOWN
03DF07  6A 01                 PUSH   1                            ; UNKNOWN
03DF09  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DF0E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DF11  8B C8                 MOV    cx, ax                       ; UNKNOWN
03DF13  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF16  D1 F8                 SAR    ax, 1                        ; UNKNOWN
03DF18  2B C1                 SUB    ax, cx                       ; UNKNOWN
03DF1A  2B 46 DC              SUB    ax, word ptr [bp - 0x24]     ; UNKNOWN
03DF1D  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03DF20  E9 ED FE              JMP    0x3de10                      ; UNKNOWN
03DF23  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03DF28  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
03DF2B  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF2E  39 46 DC              CMP    word ptr [bp - 0x24], ax     ; UNKNOWN
03DF31  7D 08                 JGE    0x3df3b                      ; UNKNOWN
03DF33  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0      ; UNKNOWN
03DF38  E9 7C FF              JMP    0x3deb7                      ; UNKNOWN
03DF3B  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
03DF40  E9 16 03              JMP    0x3e259                      ; UNKNOWN
03DF43  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF46  D1 F8                 SAR    ax, 1                        ; UNKNOWN
03DF48  2B 46 DC              SUB    ax, word ptr [bp - 0x24]     ; UNKNOWN
03DF4B  F7 D0                 NOT    ax                           ; UNKNOWN
03DF4D  40                    INC    ax                           ; UNKNOWN
03DF4E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03DF51  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF54  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
03DF57  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
03DF5A  89 46 CC              MOV    word ptr [bp - 0x34], ax     ; UNKNOWN
03DF5D  0B C0                 OR     ax, ax                       ; UNKNOWN
03DF5F  7F 0C                 JG     0x3df6d                      ; UNKNOWN
03DF61  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF64  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
03DF67  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
03DF6A  F7 D0                 NOT    ax                           ; UNKNOWN
03DF6C  40                    INC    ax                           ; UNKNOWN
03DF6D  8B 0E 82 0B           MOV    cx, word ptr [0xb82]         ; UNKNOWN
03DF71  C1 E1 02              SHL    cx, 2                        ; UNKNOWN
03DF74  03 C1                 ADD    ax, cx                       ; UNKNOWN
03DF76  50                    PUSH   ax                           ; UNKNOWN
03DF77  6A 00                 PUSH   0                            ; UNKNOWN
03DF79  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DF7E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03DF81  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
03DF84  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0      ; UNKNOWN
03DF89  E9 5E 01              JMP    0x3e0ea                      ; UNKNOWN
03DF8C  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03DF8F  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
03DF92  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
03DF95  F7 D0                 NOT    ax                           ; UNKNOWN
03DF97  40                    INC    ax                           ; UNKNOWN
03DF98  8B 0E 82 0B           MOV    cx, word ptr [0xb82]         ; UNKNOWN
03DF9C  C1 E1 02              SHL    cx, 2                        ; UNKNOWN
03DF9F  03 C1                 ADD    ax, cx                       ; UNKNOWN
03DFA1  3B 46 F0              CMP    ax, word ptr [bp - 0x10]     ; UNKNOWN
03DFA4  7F 03                 JG     0x3dfa9                      ; UNKNOWN
03DFA6  E9 16 01              JMP    0x3e0bf                      ; UNKNOWN
03DFA9  E9 10 01              JMP    0x3e0bc                      ; UNKNOWN
03DFAC  F6 46 EA 80           TEST   byte ptr [bp - 0x16], 0x80   ; UNKNOWN
03DFB0  74 07                 JE     0x3dfb9                      ; UNKNOWN
03DFB2  83 6E F0 03           SUB    word ptr [bp - 0x10], 3      ; UNKNOWN
03DFB6  E9 B4 00              JMP    0x3e06d                      ; UNKNOWN
03DFB9  F6 46 EA 20           TEST   byte ptr [bp - 0x16], 0x20   ; UNKNOWN
03DFBD  74 07                 JE     0x3dfc6                      ; UNKNOWN
03DFBF  80 66 EA 5F           AND    byte ptr [bp - 0x16], 0x5f   ; UNKNOWN
03DFC3  E9 A7 00              JMP    0x3e06d                      ; UNKNOWN
03DFC6  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
03DFCA  7D 71                 JGE    0x3e03d                      ; UNKNOWN
03DFCC  0B C0                 OR     ax, ax                       ; UNKNOWN
03DFCE  74 4D                 JE     0x3e01d                      ; UNKNOWN
03DFD0  48                    DEC    ax                           ; UNKNOWN
03DFD1  48                    DEC    ax                           ; UNKNOWN
03DFD2  74 42                 JE     0x3e016                      ; UNKNOWN
03DFD4  48                    DEC    ax                           ; UNKNOWN
03DFD5  74 0E                 JE     0x3dfe5                      ; UNKNOWN
03DFD7  48                    DEC    ax                           ; UNKNOWN
03DFD8  74 03                 JE     0x3dfdd                      ; UNKNOWN
03DFDA  E9 90 00              JMP    0x3e06d                      ; UNKNOWN
03DFDD  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3      ; UNKNOWN
03DFE2  E9 88 00              JMP    0x3e06d                      ; UNKNOWN
03DFE5  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
03DFE9  7E 05                 JLE    0x3dff0                      ; UNKNOWN
03DFEB  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
03DFEE  EB 06                 JMP    0x3dff6                      ; UNKNOWN
03DFF0  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
03DFF3  F7 D0                 NOT    ax                           ; UNKNOWN
03DFF5  40                    INC    ax                           ; UNKNOWN
03DFF6  50                    PUSH   ax                           ; UNKNOWN
03DFF7  6A 00                 PUSH   0                            ; UNKNOWN
03DFF9  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03DFFE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03E001  0B C0                 OR     ax, ax                       ; UNKNOWN
03E003  74 07                 JE     0x3e00c                      ; UNKNOWN
03E005  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
03E00A  EB 61                 JMP    0x3e06d                      ; UNKNOWN
03E00C  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; UNKNOWN
03E011  FF 4E F0              DEC    word ptr [bp - 0x10]         ; UNKNOWN
03E014  EB 57                 JMP    0x3e06d                      ; UNKNOWN
03E016  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
03E01B  EB 50                 JMP    0x3e06d                      ; UNKNOWN
03E01D  FF 36 02 83           PUSH   word ptr [0x8302]            ; UNKNOWN
03E021  FF 36 00 83           PUSH   word ptr [0x8300]            ; UNKNOWN
03E025  FF 36 FE 82           PUSH   word ptr [0x82fe]            ; UNKNOWN
03E029  FF 36 FC 82           PUSH   word ptr [0x82fc]            ; UNKNOWN
03E02D  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03E030  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03E033  BB 02 00              MOV    bx, 2                        ; UNKNOWN
03E036  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03E03B  EB 30                 JMP    0x3e06d                      ; UNKNOWN
03E03D  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
03E041  7E 2A                 JLE    0x3e06d                      ; UNKNOWN
03E043  0B C0                 OR     ax, ax                       ; UNKNOWN
03E045  74 68                 JE     0x3e0af                      ; UNKNOWN
03E047  48                    DEC    ax                           ; UNKNOWN
03E048  48                    DEC    ax                           ; UNKNOWN
03E049  74 92                 JE     0x3dfdd                      ; UNKNOWN
03E04B  48                    DEC    ax                           ; UNKNOWN
03E04C  74 5A                 JE     0x3e0a8                      ; UNKNOWN
03E04E  48                    DEC    ax                           ; UNKNOWN
03E04F  74 3C                 JE     0x3e08d                      ; UNKNOWN
03E051  48                    DEC    ax                           ; UNKNOWN
03E052  75 19                 JNE    0x3e06d                      ; UNKNOWN
03E054  83 6E F0 02           SUB    word ptr [bp - 0x10], 2      ; UNKNOWN
03E058  6A 03                 PUSH   3                            ; UNKNOWN
03E05A  6A 00                 PUSH   0                            ; UNKNOWN
03E05C  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03E061  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03E064  0B C0                 OR     ax, ax                       ; UNKNOWN
03E066  75 05                 JNE    0x3e06d                      ; UNKNOWN
03E068  C7 46 EE 07 00        MOV    word ptr [bp - 0x12], 7      ; UNKNOWN
03E06D  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
03E071  7E 43                 JLE    0x3e0b6                      ; UNKNOWN
03E073  A1 82 0B              MOV    ax, word ptr [0xb82]         ; UNKNOWN
03E076  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03E078  83 E8 07              SUB    ax, 7                        ; UNKNOWN
03E07B  F7 D8                 NEG    ax                           ; UNKNOWN
03E07D  50                    PUSH   ax                           ; UNKNOWN
03E07E  6A 01                 PUSH   1                            ; UNKNOWN
03E080  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03E085  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03E088  29 46 F0              SUB    word ptr [bp - 0x10], ax     ; UNKNOWN
03E08B  EB 32                 JMP    0x3e0bf                      ; UNKNOWN
03E08D  83 6E F0 02           SUB    word ptr [bp - 0x10], 2      ; UNKNOWN
03E091  6A 03                 PUSH   3                            ; UNKNOWN
03E093  6A 00                 PUSH   0                            ; UNKNOWN
03E095  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03E09A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03E09D  0B C0                 OR     ax, ax                       ; UNKNOWN
03E09F  75 CC                 JNE    0x3e06d                      ; UNKNOWN
03E0A1  C7 46 EE 06 00        MOV    word ptr [bp - 0x12], 6      ; UNKNOWN
03E0A6  EB C5                 JMP    0x3e06d                      ; UNKNOWN
03E0A8  C7 46 EE 04 00        MOV    word ptr [bp - 0x12], 4      ; UNKNOWN
03E0AD  EB BE                 JMP    0x3e06d                      ; UNKNOWN
03E0AF  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; UNKNOWN
03E0B4  EB B7                 JMP    0x3e06d                      ; UNKNOWN
03E0B6  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
03E0BA  7D 03                 JGE    0x3e0bf                      ; UNKNOWN
03E0BC  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
03E0BF  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03E0C3  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03E0C7  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03E0CB  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03E0CF  8A 5E EA              MOV    bl, byte ptr [bp - 0x16]     ; UNKNOWN
03E0D2  81 E3 E0 00           AND    bx, 0xe0                     ; UNKNOWN
03E0D6  0B 5E EE              OR     bx, word ptr [bp - 0x12]     ; UNKNOWN
03E0D9  89 5E EA              MOV    word ptr [bp - 0x16], bx     ; UNKNOWN
03E0DC  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03E0DF  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03E0E2  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03E0E7  FF 46 E2              INC    word ptr [bp - 0x1e]         ; UNKNOWN
03E0EA  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
03E0ED  39 46 E2              CMP    word ptr [bp - 0x1e], ax     ; UNKNOWN
03E0F0  7D 45                 JGE    0x3e137                      ; UNKNOWN
03E0F2  FF 36 FA 82           PUSH   word ptr [0x82fa]            ; UNKNOWN
03E0F6  FF 36 F8 82           PUSH   word ptr [0x82f8]            ; UNKNOWN
03E0FA  FF 36 F6 82           PUSH   word ptr [0x82f6]            ; UNKNOWN
03E0FE  FF 36 F4 82           PUSH   word ptr [0x82f4]            ; UNKNOWN
03E102  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
03E105  8B 56 DC              MOV    dx, word ptr [bp - 0x24]     ; UNKNOWN
03E108  9A 04 00 75 5A        LCALL  0x5a75, 4                    ; UNKNOWN
03E10D  2A E4                 SUB    ah, ah                       ; UNKNOWN
03E10F  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03E112  83 E0 1F              AND    ax, 0x1f                     ; UNKNOWN
03E115  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03E118  83 7E EA 19           CMP    word ptr [bp - 0x16], 0x19   ; UNKNOWN
03E11C  74 03                 JE     0x3e121                      ; UNKNOWN
03E11E  E9 8B FE              JMP    0x3dfac                      ; UNKNOWN
03E121  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
03E124  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
03E127  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
03E12A  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
03E12D  0B C0                 OR     ax, ax                       ; UNKNOWN
03E12F  7F 03                 JG     0x3e134                      ; UNKNOWN
03E131  E9 58 FE              JMP    0x3df8c                      ; UNKNOWN
03E134  E9 61 FE              JMP    0x3df98                      ; UNKNOWN
03E137  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
03E13C  48                    DEC    ax                           ; UNKNOWN
03E13D  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
03E140  E9 CA 00              JMP    0x3e20d                      ; UNKNOWN
03E143  F6                    DB     0xF6                         ; UNKNOWN (raw)
