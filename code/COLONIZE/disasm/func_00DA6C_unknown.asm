; ============================================================================
; func_00DA6C_unknown
; Region   : load_image
; Bytes    : file 0x00DA6C..0x00E014  (1448 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DA6C  C8 F4 03 00           ENTER  0x3f4, 0                     ; UNKNOWN
00DA70  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00DA73  89 86 1E FF           MOV    word ptr [bp - 0xe2], ax     ; UNKNOWN
00DA77  89 86 1C FF           MOV    word ptr [bp - 0xe4], ax     ; UNKNOWN
00DA7B  C7 86 10 FF C8 00     MOV    word ptr [bp - 0xf0], 0xc8   ; UNKNOWN
00DA81  C7 86 12 FF 40 01     MOV    word ptr [bp - 0xee], 0x140  ; UNKNOWN
00DA87  C7 86 14 FF 00 00     MOV    word ptr [bp - 0xec], 0      ; UNKNOWN
00DA8D  C7 86 16 FF 00 A0     MOV    word ptr [bp - 0xea], 0xa000 ; UNKNOWN
00DA93  9A 8F 01 E7 05        LCALL  0x5e7, 0x18f                 ; UNKNOWN
00DA98  83 3E 4E 0A 00        CMP    word ptr [0xa4e], 0          ; UNKNOWN
00DA9D  74 36                 JE     0xdad5                       ; UNKNOWN
00DA9F  6A 03                 PUSH   3                            ; UNKNOWN
00DAA1  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
00DAA6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DAA9  6A 0A                 PUSH   0xa                          ; UNKNOWN
00DAAB  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DAAF  50                    PUSH   ax                           ; UNKNOWN
00DAB0  9A 80 00 58 06        LCALL  0x658, 0x80                  ; UNKNOWN
00DAB5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00DAB8  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DABC  50                    PUSH   ax                           ; UNKNOWN
00DABD  0E                    PUSH   cs                           ; UNKNOWN
00DABE  E8 B9 C6              CALL   0xa17a                       ; UNKNOWN
00DAC1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DAC4  0B C0                 OR     ax, ax                       ; UNKNOWN
00DAC6  75 0D                 JNE    0xdad5                       ; UNKNOWN
00DAC8  39 06 92 CE           CMP    word ptr [0xce92], ax        ; UNKNOWN
00DACC  74 4C                 JE     0xdb1a                       ; UNKNOWN
00DACE  9A 07 00 1E 5C        LCALL  0x5c1e, 7                    ; UNKNOWN
00DAD3  EB 45                 JMP    0xdb1a                       ; UNKNOWN
00DAD5  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00DADA  74 72                 JE     0xdb4e                       ; UNKNOWN
00DADC  6A 05                 PUSH   5                            ; UNKNOWN
00DADE  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DAE2  50                    PUSH   ax                           ; UNKNOWN
00DAE3  9A 80 00 58 06        LCALL  0x658, 0x80                  ; UNKNOWN
00DAE8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00DAEB  6A 00                 PUSH   0                            ; UNKNOWN
00DAED  8D 86 72 FF           LEA    ax, [bp - 0x8e]              ; UNKNOWN
00DAF1  50                    PUSH   ax                           ; UNKNOWN
00DAF2  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DAF6  50                    PUSH   ax                           ; UNKNOWN
00DAF7  0E                    PUSH   cs                           ; UNKNOWN
00DAF8  E8 4C E0              CALL   0xbb47                       ; UNKNOWN
00DAFB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00DAFE  0B C0                 OR     ax, ax                       ; UNKNOWN
00DB00  75 20                 JNE    0xdb22                       ; UNKNOWN
00DB02  81 BE 7C FF A4 06     CMP    word ptr [bp - 0x84], 0x6a4  ; UNKNOWN
00DB08  7D 18                 JGE    0xdb22                       ; UNKNOWN
00DB0A  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DB0E  50                    PUSH   ax                           ; UNKNOWN
00DB0F  0E                    PUSH   cs                           ; UNKNOWN
00DB10  E8 67 C6              CALL   0xa17a                       ; UNKNOWN
00DB13  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DB16  0B C0                 OR     ax, ax                       ; UNKNOWN
00DB18  75 08                 JNE    0xdb22                       ; UNKNOWN
00DB1A  C6 06 A1 09 01        MOV    byte ptr [0x9a1], 1          ; UNKNOWN
00DB1F  E9 E2 04              JMP    0xe004                       ; UNKNOWN
00DB22  6A 00                 PUSH   0                            ; UNKNOWN
00DB24  0E                    PUSH   cs                           ; UNKNOWN
00DB25  E8 2D FB              CALL   0xd655                       ; UNKNOWN
00DB28  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DB2B  0B C0                 OR     ax, ax                       ; UNKNOWN
00DB2D  74 03                 JE     0xdb32                       ; UNKNOWN
00DB2F  E9 D8 04              JMP    0xe00a                       ; UNKNOWN
00DB32  89 86 0C FF           MOV    word ptr [bp - 0xf4], ax     ; UNKNOWN
00DB36  6B 9E 0C FF 34        IMUL   bx, word ptr [bp - 0xf4], 0x34 ; UNKNOWN
00DB3B  C6 87 B7 C0 01        MOV    byte ptr [bx - 0x3f49], 1    ; UNKNOWN
00DB40  FF 86 0C FF           INC    word ptr [bp - 0xf4]         ; UNKNOWN
00DB44  83 BE 0C FF 04        CMP    word ptr [bp - 0xf4], 4      ; UNKNOWN
00DB49  7C EB                 JL     0xdb36                       ; UNKNOWN
00DB4B  E9 B6 04              JMP    0xe004                       ; UNKNOWN
00DB4E  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DB52  16                    PUSH   ss                           ; UNKNOWN
00DB53  50                    PUSH   ax                           ; UNKNOWN
00DB54  6A 00                 PUSH   0                            ; UNKNOWN
00DB56  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DB5A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DB5E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DB62  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DB66  68 6B 1C              PUSH   0x1c6b                       ; UNKNOWN
00DB69  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
00DB6E  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00DB71  0B C0                 OR     ax, ax                       ; UNKNOWN
00DB73  74 3B                 JE     0xdbb0                       ; UNKNOWN
00DB75  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DB79  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DB7D  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DB81  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DB85  2A C0                 SUB    al, al                       ; UNKNOWN
00DB87  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00DB8C  0E                    PUSH   cs                           ; UNKNOWN
00DB8D  E8 BD FE              CALL   0xda4d                       ; UNKNOWN
00DB90  68 00 03              PUSH   0x300                        ; UNKNOWN
00DB93  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00DB96  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00DB99  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DB9D  16                    PUSH   ss                           ; UNKNOWN
00DB9E  50                    PUSH   ax                           ; UNKNOWN
00DB9F  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
00DBA4  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00DBA7  C7 86 0E FF 01 00     MOV    word ptr [bp - 0xf2], 1      ; UNKNOWN
00DBAD  E9 F9 00              JMP    0xdca9                       ; UNKNOWN
00DBB0  80 3E A2 09 00        CMP    byte ptr [0x9a2], 0          ; UNKNOWN
00DBB5  74 30                 JE     0xdbe7                       ; UNKNOWN
00DBB7  FF B6 16 FF           PUSH   word ptr [bp - 0xea]         ; UNKNOWN
00DBBB  FF B6 14 FF           PUSH   word ptr [bp - 0xec]         ; UNKNOWN
00DBBF  FF B6 12 FF           PUSH   word ptr [bp - 0xee]         ; UNKNOWN
00DBC3  FF B6 10 FF           PUSH   word ptr [bp - 0xf0]         ; UNKNOWN
00DBC7  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DBCB  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DBCF  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DBD3  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DBD7  68 B0 00              PUSH   0xb0                         ; UNKNOWN
00DBDA  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DBDC  99                    CDQ                                 ; UNKNOWN
00DBDD  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DBE0  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00DBE5  EB 0B                 JMP    0xdbf2                       ; UNKNOWN
00DBE7  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DBEB  16                    PUSH   ss                           ; UNKNOWN
00DBEC  50                    PUSH   ax                           ; UNKNOWN
00DBED  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00DBF2  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DBF6  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DBFA  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DBFE  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DC02  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DC05  6A 07                 PUSH   7                            ; UNKNOWN
00DC07  6A 06                 PUSH   6                            ; UNKNOWN
00DC09  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DC0B  99                    CDQ                                 ; UNKNOWN
00DC0C  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DC0F  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DC14  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DC18  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DC1C  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DC20  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DC24  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DC27  6A 08                 PUSH   8                            ; UNKNOWN
00DC29  6A 09                 PUSH   9                            ; UNKNOWN
00DC2B  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DC2D  99                    CDQ                                 ; UNKNOWN
00DC2E  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DC31  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DC36  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DC3A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DC3E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DC42  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DC46  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DC49  6A 0F                 PUSH   0xf                          ; UNKNOWN
00DC4B  6A 0E                 PUSH   0xe                          ; UNKNOWN
00DC4D  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DC4F  99                    CDQ                                 ; UNKNOWN
00DC50  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DC53  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DC58  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DC5C  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DC60  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DC64  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DC68  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00DC6C  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00DC70  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00DC74  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00DC78  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DC7B  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DC7D  99                    CDQ                                 ; UNKNOWN
00DC7E  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DC81  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00DC86  6A 00                 PUSH   0                            ; UNKNOWN
00DC88  68 40 01              PUSH   0x140                        ; UNKNOWN
00DC8B  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DC8E  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DC90  99                    CDQ                                 ; UNKNOWN
00DC91  2B DB                 SUB    bx, bx                       ; UNKNOWN
00DC93  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00DC98  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DC9C  16                    PUSH   ss                           ; UNKNOWN
00DC9D  50                    PUSH   ax                           ; UNKNOWN
00DC9E  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00DCA3  C7 86 0E FF 00 00     MOV    word ptr [bp - 0xf2], 0      ; UNKNOWN
00DCA9  6A 33                 PUSH   0x33                         ; UNKNOWN
00DCAB  9A 0E 00 04 5D        LCALL  0x5d04, 0xe                  ; UNKNOWN
00DCB0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DCB3  9A 06 00 01 30        LCALL  0x3001, 6                    ; UNKNOWN
00DCB8  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00DCBD  75 0C                 JNE    0xdccb                       ; UNKNOWN
00DCBF  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
00DCC4  74 05                 JE     0xdccb                       ; UNKNOWN
00DCC6  9A 07 00 1E 5C        LCALL  0x5c1e, 7                    ; UNKNOWN
00DCCB  83 BE 0E FF 00        CMP    word ptr [bp - 0xf2], 0      ; UNKNOWN
00DCD0  75 04                 JNE    0xdcd6                       ; UNKNOWN
00DCD2  0E                    PUSH   cs                           ; UNKNOWN
00DCD3  E8 7D D8              CALL   0xb553                       ; UNKNOWN
00DCD6  9A 06 00 01 30        LCALL  0x3001, 6                    ; UNKNOWN
00DCDB  C7 86 1C FF 00 00     MOV    word ptr [bp - 0xe4], 0      ; UNKNOWN
00DCE1  8D 1E 74 1C           LEA    bx, [0x1c74]                 ; UNKNOWN
00DCE5  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
00DCEA  89 86 20 FF           MOV    word ptr [bp - 0xe0], ax     ; UNKNOWN
00DCEE  48                    DEC    ax                           ; UNKNOWN
00DCEF  7D 03                 JGE    0xdcf4                       ; UNKNOWN
00DCF1  E9 16 03              JMP    0xe00a                       ; UNKNOWN
00DCF4  48                    DEC    ax                           ; UNKNOWN
00DCF5  48                    DEC    ax                           ; UNKNOWN
00DCF6  7E 0F                 JLE    0xdd07                       ; UNKNOWN
00DCF8  48                    DEC    ax                           ; UNKNOWN
00DCF9  75 03                 JNE    0xdcfe                       ; UNKNOWN
00DCFB  E9 6B 01              JMP    0xde69                       ; UNKNOWN
00DCFE  48                    DEC    ax                           ; UNKNOWN
00DCFF  75 03                 JNE    0xdd04                       ; UNKNOWN
00DD01  E9 2A 02              JMP    0xdf2e                       ; UNKNOWN
00DD04  E9 03 03              JMP    0xe00a                       ; UNKNOWN
00DD07  C7 86 0C FF 00 00     MOV    word ptr [bp - 0xf4], 0      ; UNKNOWN
00DD0D  EB 1A                 JMP    0xdd29                       ; UNKNOWN
00DD0F  6A 03                 PUSH   3                            ; UNKNOWN
00DD11  6A 00                 PUSH   0                            ; UNKNOWN
00DD13  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00DD18  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00DD1B  8B 9E 0C FF           MOV    bx, word ptr [bp - 0xf4]     ; UNKNOWN
00DD1F  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00DD21  89 87 7C 0B           MOV    word ptr [bx + 0xb7c], ax    ; UNKNOWN
00DD25  FF 86 0C FF           INC    word ptr [bp - 0xf4]         ; UNKNOWN
00DD29  83 BE 0C FF 05        CMP    word ptr [bp - 0xf4], 5      ; UNKNOWN
00DD2E  7D 15                 JGE    0xdd45                       ; UNKNOWN
00DD30  83 BE 20 FF 03        CMP    word ptr [bp - 0xe0], 3      ; UNKNOWN
00DD35  75 D8                 JNE    0xdd0f                       ; UNKNOWN
00DD37  8B 9E 0C FF           MOV    bx, word ptr [bp - 0xf4]     ; UNKNOWN
00DD3B  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00DD3D  C7 87 7C 0B 01 00     MOV    word ptr [bx + 0xb7c], 1     ; UNKNOWN
00DD43  EB E0                 JMP    0xdd25                       ; UNKNOWN
00DD45  83 BE 20 FF 03        CMP    word ptr [bp - 0xe0], 3      ; UNKNOWN
00DD4A  75 0F                 JNE    0xdd5b                       ; UNKNOWN
00DD4C  9A 7A 02 2F 23        LCALL  0x232f, 0x27a                ; UNKNOWN
00DD51  0B C0                 OR     ax, ax                       ; UNKNOWN
00DD53  74 06                 JE     0xdd5b                       ; UNKNOWN
00DD55  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1      ; UNKNOWN
00DD5B  0E                    PUSH   cs                           ; UNKNOWN
00DD5C  E8 EE FC              CALL   0xda4d                       ; UNKNOWN
00DD5F  83 BE 20 FF 02        CMP    word ptr [bp - 0xe0], 2      ; UNKNOWN
00DD64  75 66                 JNE    0xddcc                       ; UNKNOWN
00DD66  8D 1E 7E 1C           LEA    bx, [0x1c7e]                 ; UNKNOWN
00DD6A  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
00DD6F  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax     ; UNKNOWN
00DD73  83 F8 01              CMP    ax, 1                        ; UNKNOWN
00DD76  7D 08                 JGE    0xdd80                       ; UNKNOWN
00DD78  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1      ; UNKNOWN
00DD7E  EB 4C                 JMP    0xddcc                       ; UNKNOWN
00DD80  83 F8 01              CMP    ax, 1                        ; UNKNOWN
00DD83  7E 47                 JLE    0xddcc                       ; UNKNOWN
00DD85  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DD89  50                    PUSH   ax                           ; UNKNOWN
00DD8A  68 86 1C              PUSH   0x1c86                       ; UNKNOWN
00DD8D  68 8B 1C              PUSH   0x1c8b                       ; UNKNOWN
00DD90  68 95 1C              PUSH   0x1c95                       ; UNKNOWN
00DD93  0E                    PUSH   cs                           ; UNKNOWN
00DD94  E8 73 D5              CALL   0xb30a                       ; UNKNOWN
00DD97  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00DD9A  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax     ; UNKNOWN
00DD9E  0B C0                 OR     ax, ax                       ; UNKNOWN
00DDA0  7C D6                 JL     0xdd78                       ; UNKNOWN
00DDA2  68 32 0A              PUSH   0xa32                        ; UNKNOWN
00DDA5  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DDA9  50                    PUSH   ax                           ; UNKNOWN
00DDAA  9A A6 07 65 5F        LCALL  0x5f65, 0x7a6                ; UNKNOWN
00DDAF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00DDB2  0B C0                 OR     ax, ax                       ; UNKNOWN
00DDB4  74 16                 JE     0xddcc                       ; UNKNOWN
00DDB6  C7 06 3F 0A 01 00     MOV    word ptr [0xa3f], 1          ; UNKNOWN
00DDBC  8D 86 22 FF           LEA    ax, [bp - 0xde]              ; UNKNOWN
00DDC0  50                    PUSH   ax                           ; UNKNOWN
00DDC1  68 32 0A              PUSH   0xa32                        ; UNKNOWN
00DDC4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00DDC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00DDCC  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0      ; UNKNOWN
00DDD1  75 2D                 JNE    0xde00                       ; UNKNOWN
00DDD3  83 BE 20 FF 02        CMP    word ptr [bp - 0xe0], 2      ; UNKNOWN
00DDD8  75 05                 JNE    0xdddf                       ; UNKNOWN
00DDDA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00DDDD  EB 02                 JMP    0xdde1                       ; UNKNOWN
00DDDF  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DDE1  50                    PUSH   ax                           ; UNKNOWN
00DDE2  0E                    PUSH   cs                           ; UNKNOWN
00DDE3  E8 6F F8              CALL   0xd655                       ; UNKNOWN
00DDE6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DDE9  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax     ; UNKNOWN
00DDED  48                    DEC    ax                           ; UNKNOWN
00DDEE  75 06                 JNE    0xddf6                       ; UNKNOWN
00DDF0  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1      ; UNKNOWN
00DDF6  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1      ; UNKNOWN
00DDFB  7E 03                 JLE    0xde00                       ; UNKNOWN
00DDFD  E9 0A 02              JMP    0xe00a                       ; UNKNOWN
00DE00  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0      ; UNKNOWN
00DE05  75 03                 JNE    0xde0a                       ; UNKNOWN
00DE07  E9 F0 01              JMP    0xdffa                       ; UNKNOWN
00DE0A  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DE0E  16                    PUSH   ss                           ; UNKNOWN
00DE0F  50                    PUSH   ax                           ; UNKNOWN
00DE10  6A 00                 PUSH   0                            ; UNKNOWN
00DE12  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DE16  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DE1A  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DE1E  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DE22  68 A3 1C              PUSH   0x1ca3                       ; UNKNOWN
00DE25  9A 0A 00 69 1A        LCALL  0x1a69, 0xa                  ; UNKNOWN
00DE2A  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
00DE2D  0B C0                 OR     ax, ax                       ; UNKNOWN
00DE2F  75 03                 JNE    0xde34                       ; UNKNOWN
00DE31  E9 11 01              JMP    0xdf45                       ; UNKNOWN
00DE34  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DE38  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DE3C  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DE40  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DE44  2A C0                 SUB    al, al                       ; UNKNOWN
00DE46  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
00DE4B  0E                    PUSH   cs                           ; UNKNOWN
00DE4C  E8 FE FB              CALL   0xda4d                       ; UNKNOWN
00DE4F  68 00 03              PUSH   0x300                        ; UNKNOWN
00DE52  68 00 A0              PUSH   0xa000                       ; UNKNOWN
00DE55  68 00 FC              PUSH   0xfc00                       ; UNKNOWN
00DE58  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DE5C  16                    PUSH   ss                           ; UNKNOWN
00DE5D  50                    PUSH   ax                           ; UNKNOWN
00DE5E  9A BE 12 65 5F        LCALL  0x5f65, 0x12be               ; UNKNOWN
00DE63  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
00DE66  E9 91 01              JMP    0xdffa                       ; UNKNOWN
00DE69  0E                    PUSH   cs                           ; UNKNOWN
00DE6A  E8 E0 FB              CALL   0xda4d                       ; UNKNOWN
00DE6D  6A 00                 PUSH   0                            ; UNKNOWN
00DE6F  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DE73  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DE77  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DE7B  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DE7F  68 9A 1C              PUSH   0x1c9a                       ; UNKNOWN
00DE82  9A 08 00 5E 1A        LCALL  0x1a5e, 8                    ; UNKNOWN
00DE87  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
00DE8A  83 F8 01              CMP    ax, 1                        ; UNKNOWN
00DE8D  1B C0                 SBB    ax, ax                       ; UNKNOWN
00DE8F  F7 D8                 NEG    ax                           ; UNKNOWN
00DE91  89 86 18 FF           MOV    word ptr [bp - 0xe8], ax     ; UNKNOWN
00DE95  0B C0                 OR     ax, ax                       ; UNKNOWN
00DE97  74 45                 JE     0xdede                       ; UNKNOWN
00DE99  9A 93 37 97 1B        LCALL  0x1b97, 0x3793               ; UNKNOWN
00DE9E  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DEA2  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DEA6  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DEAA  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DEAE  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00DEB2  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00DEB6  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00DEBA  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00DEBE  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DEC1  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DEC3  99                    CDQ                                 ; UNKNOWN
00DEC4  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DEC7  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00DECC  6A 00                 PUSH   0                            ; UNKNOWN
00DECE  68 40 01              PUSH   0x140                        ; UNKNOWN
00DED1  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DED4  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DED6  99                    CDQ                                 ; UNKNOWN
00DED7  2B DB                 SUB    bx, bx                       ; UNKNOWN
00DED9  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00DEDE  9A 4A 03 58 06        LCALL  0x658, 0x34a                 ; UNKNOWN
00DEE3  89 86 1A FF           MOV    word ptr [bp - 0xe6], ax     ; UNKNOWN
00DEE7  0B C0                 OR     ax, ax                       ; UNKNOWN
00DEE9  75 29                 JNE    0xdf14                       ; UNKNOWN
00DEEB  C6 06 A1 09 01        MOV    byte ptr [0x9a1], 1          ; UNKNOWN
00DEF0  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
00DEF5  74 09                 JE     0xdf00                       ; UNKNOWN
00DEF7  6A 03                 PUSH   3                            ; UNKNOWN
00DEF9  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
00DEFE  EB 11                 JMP    0xdf11                       ; UNKNOWN
00DF00  6A 01                 PUSH   1                            ; UNKNOWN
00DF02  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
00DF07  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DF0A  6A 02                 PUSH   2                            ; UNKNOWN
00DF0C  9A 06 03 28 1A        LCALL  0x1a28, 0x306                ; UNKNOWN
00DF11  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DF14  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1      ; UNKNOWN
00DF19  75 06                 JNE    0xdf21                       ; UNKNOWN
00DF1B  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1      ; UNKNOWN
00DF21  83 BE 1A FF 01        CMP    word ptr [bp - 0xe6], 1      ; UNKNOWN
00DF26  7F 03                 JG     0xdf2b                       ; UNKNOWN
00DF28  E9 D5 FE              JMP    0xde00                       ; UNKNOWN
00DF2B  E9 DC 00              JMP    0xe00a                       ; UNKNOWN
00DF2E  C7 86 1C FF 01 00     MOV    word ptr [bp - 0xe4], 1      ; UNKNOWN
00DF34  0E                    PUSH   cs                           ; UNKNOWN
00DF35  E8 15 FB              CALL   0xda4d                       ; UNKNOWN
00DF38  6A 00                 PUSH   0                            ; UNKNOWN
00DF3A  9A 37 0F 81 20        LCALL  0x2081, 0xf37                ; UNKNOWN
00DF3F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00DF42  E9 BB FE              JMP    0xde00                       ; UNKNOWN
00DF45  0E                    PUSH   cs                           ; UNKNOWN
00DF46  E8 19 FB              CALL   0xda62                       ; UNKNOWN
00DF49  8D 86 0C FC           LEA    ax, [bp - 0x3f4]             ; UNKNOWN
00DF4D  16                    PUSH   ss                           ; UNKNOWN
00DF4E  50                    PUSH   ax                           ; UNKNOWN
00DF4F  9A 02 00 F3 5B        LCALL  0x5bf3, 2                    ; UNKNOWN
00DF54  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DF58  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DF5C  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DF60  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DF64  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DF67  6A 07                 PUSH   7                            ; UNKNOWN
00DF69  6A 06                 PUSH   6                            ; UNKNOWN
00DF6B  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DF6D  99                    CDQ                                 ; UNKNOWN
00DF6E  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DF71  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DF76  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DF7A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DF7E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DF82  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DF86  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DF89  6A 08                 PUSH   8                            ; UNKNOWN
00DF8B  6A 09                 PUSH   9                            ; UNKNOWN
00DF8D  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DF8F  99                    CDQ                                 ; UNKNOWN
00DF90  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DF93  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DF98  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DF9C  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DFA0  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DFA4  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DFA8  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DFAB  6A 0F                 PUSH   0xf                          ; UNKNOWN
00DFAD  6A 0E                 PUSH   0xe                          ; UNKNOWN
00DFAF  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DFB1  99                    CDQ                                 ; UNKNOWN
00DFB2  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DFB5  9A 04 00 8E 5A        LCALL  0x5a8e, 4                    ; UNKNOWN
00DFBA  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00DFBE  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00DFC2  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00DFC6  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00DFCA  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00DFCE  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00DFD2  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00DFD6  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00DFDA  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DFDD  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DFDF  99                    CDQ                                 ; UNKNOWN
00DFE0  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00DFE3  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00DFE8  6A 00                 PUSH   0                            ; UNKNOWN
00DFEA  68 40 01              PUSH   0x140                        ; UNKNOWN
00DFED  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00DFF0  2B C0                 SUB    ax, ax                       ; UNKNOWN
00DFF2  99                    CDQ                                 ; UNKNOWN
00DFF3  2B DB                 SUB    bx, bx                       ; UNKNOWN
00DFF5  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00DFFA  83 BE 1C FF 00        CMP    word ptr [bp - 0xe4], 0      ; UNKNOWN
00DFFF  74 03                 JE     0xe004                       ; UNKNOWN
00E001  E9 C7 FC              JMP    0xdccb                       ; UNKNOWN
00E004  C7 86 1E FF 00 00     MOV    word ptr [bp - 0xe2], 0      ; UNKNOWN
00E00A  0E                    PUSH   cs                           ; UNKNOWN
00E00B  E8 3F FA              CALL   0xda4d                       ; UNKNOWN
00E00E  8B 86 1E FF           MOV    ax, word ptr [bp - 0xe2]     ; UNKNOWN
00E012  C9                    LEAVE                               ; UNKNOWN
00E013  CB                    RETF                                ; UNKNOWN
