; ============================================================================
; func_02391D_unknown
; Region   : load_image
; Bytes    : file 0x02391D..0x023AF2  (469 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02391D  C8 46 00 00           ENTER  0x46, 0                      ; UNKNOWN
023921  53                    PUSH   bx                           ; UNKNOWN
023922  52                    PUSH   dx                           ; UNKNOWN
023923  50                    PUSH   ax                           ; UNKNOWN
023924  57                    PUSH   di                           ; UNKNOWN
023925  56                    PUSH   si                           ; UNKNOWN
023926  8B F0                 MOV    si, ax                       ; UNKNOWN
023928  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0      ; UNKNOWN
02392D  80 66 B6 DF           AND    byte ptr [bp - 0x4a], 0xdf   ; UNKNOWN
023931  8B 56 B6              MOV    dx, word ptr [bp - 0x4a]     ; UNKNOWN
023934  83 E2 40              AND    dx, 0x40                     ; UNKNOWN
023937  8D 5E D6              LEA    bx, [bp - 0x2a]              ; UNKNOWN
02393A  0E                    PUSH   cs                           ; UNKNOWN
02393B  E8 34 FF              CALL   0x23872                      ; UNKNOWN
02393E  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
023941  F6 46 B6 80           TEST   byte ptr [bp - 0x4a], 0x80   ; UNKNOWN
023945  74 17                 JE     0x2395e                      ; UNKNOWN
023947  8B C6                 MOV    ax, si                       ; UNKNOWN
023949  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
02394E  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
023953  0B C0                 OR     ax, ax                       ; UNKNOWN
023955  7C 07                 JL     0x2395e                      ; UNKNOWN
023957  C7 46 E4 01 00        MOV    word ptr [bp - 0x1c], 1      ; UNKNOWN
02395C  EB 05                 JMP    0x23963                      ; UNKNOWN
02395E  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
023963  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
023968  6B 5E D6 1C           IMUL   bx, word ptr [bp - 0x2a], 0x1c ; UNKNOWN
02396C  89 5E C0              MOV    word ptr [bp - 0x40], bx     ; UNKNOWN
02396F  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
023973  8B C8                 MOV    cx, ax                       ; UNKNOWN
023975  2A E4                 SUB    ah, ah                       ; UNKNOWN
023977  8B F0                 MOV    si, ax                       ; UNKNOWN
023979  80 F9 0D              CMP    cl, 0xd                      ; UNKNOWN
02397C  73 03                 JAE    0x23981                      ; UNKNOWN
02397E  E9 CE 00              JMP    0x23a4f                      ; UNKNOWN
023981  3C 12                 CMP    al, 0x12                     ; UNKNOWN
023983  76 03                 JBE    0x23988                      ; UNKNOWN
023985  E9 C7 00              JMP    0x23a4f                      ; UNKNOWN
023988  83 FE 0F              CMP    si, 0xf                      ; UNKNOWN
02398B  75 03                 JNE    0x23990                      ; UNKNOWN
02398D  E9 B7 00              JMP    0x23a47                      ; UNKNOWN
023990  83 FE 10              CMP    si, 0x10                     ; UNKNOWN
023993  75 03                 JNE    0x23998                      ; UNKNOWN
023995  E9 AF 00              JMP    0x23a47                      ; UNKNOWN
023998  83 FE 11              CMP    si, 0x11                     ; UNKNOWN
02399B  75 03                 JNE    0x239a0                      ; UNKNOWN
02399D  E9 A7 00              JMP    0x23a47                      ; UNKNOWN
0239A0  83 FE 12              CMP    si, 0x12                     ; UNKNOWN
0239A3  75 03                 JNE    0x239a8                      ; UNKNOWN
0239A5  E9 9F 00              JMP    0x23a47                      ; UNKNOWN
0239A8  C7 46 EE 03 00        MOV    word ptr [bp - 0x12], 3      ; UNKNOWN
0239AD  8B 5E C0              MOV    bx, word ptr [bp - 0x40]     ; UNKNOWN
0239B0  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0239B4  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0239B7  8B F8                 MOV    di, ax                       ; UNKNOWN
0239B9  8A 8F 88 88           MOV    cl, byte ptr [bx - 0x7778]   ; UNKNOWN
0239BD  2A ED                 SUB    ch, ch                       ; UNKNOWN
0239BF  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
0239C2  83 F8 04              CMP    ax, 4                        ; UNKNOWN
0239C5  7C 05                 JL     0x239cc                      ; UNKNOWN
0239C7  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
0239CC  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
0239CF  8A 87 D4 37           MOV    al, byte ptr [bx + 0x37d4]   ; UNKNOWN
0239D3  88 46 FF              MOV    byte ptr [bp - 1], al        ; UNKNOWN
0239D6  8B 5E C0              MOV    bx, word ptr [bp - 0x40]     ; UNKNOWN
0239D9  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
0239DE  72 2B                 JB     0x23a0b                      ; UNKNOWN
0239E0  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
0239E5  77 24                 JA     0x23a0b                      ; UNKNOWN
0239E7  39 3E 0E 3E           CMP    word ptr [0x3e0e], di        ; UNKNOWN
0239EB  74 1E                 JE     0x23a0b                      ; UNKNOWN
0239ED  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
0239F1  04 30                 ADD    al, 0x30                     ; UNKNOWN
0239F3  88 46 FF              MOV    byte ptr [bp - 1], al        ; UNKNOWN
0239F6  83 FE 10              CMP    si, 0x10                     ; UNKNOWN
0239F9  75 10                 JNE    0x23a0b                      ; UNKNOWN
0239FB  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
023A00  75 09                 JNE    0x23a0b                      ; UNKNOWN
023A02  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1      ; UNKNOWN
023A07  C6 46 FF 58           MOV    byte ptr [bp - 1], 0x58      ; UNKNOWN
023A0B  83 FF 04              CMP    di, 4                        ; UNKNOWN
023A0E  7D 2C                 JGE    0x23a3c                      ; UNKNOWN
023A10  7D 0A                 JGE    0x23a1c                      ; UNKNOWN
023A12  6B DF 34              IMUL   bx, di, 0x34                 ; UNKNOWN
023A15  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
023A1A  74 20                 JE     0x23a3c                      ; UNKNOWN
023A1C  F6 06 FB 3D 20        TEST   byte ptr [0x3dfb], 0x20      ; UNKNOWN
023A21  74 19                 JE     0x23a3c                      ; UNKNOWN
023A23  F6 06 A8 09 08        TEST   byte ptr [0x9a8], 8          ; UNKNOWN
023A28  74 12                 JE     0x23a3c                      ; UNKNOWN
023A2A  8B 5E C0              MOV    bx, word ptr [bp - 0x40]     ; UNKNOWN
023A2D  8A 87 87 88           MOV    al, byte ptr [bx - 0x7779]   ; UNKNOWN
023A31  88 46 FF              MOV    byte ptr [bp - 1], al        ; UNKNOWN
023A34  3C 80                 CMP    al, 0x80                     ; UNKNOWN
023A36  72 04                 JB     0x23a3c                      ; UNKNOWN
023A38  C6 46 FF 45           MOV    byte ptr [bp - 1], 0x45      ; UNKNOWN
023A3C  83 FF 04              CMP    di, 4                        ; UNKNOWN
023A3F  7D 6F                 JGE    0x23ab0                      ; UNKNOWN
023A41  8A 85 7A 09           MOV    al, byte ptr [di + 0x97a]    ; UNKNOWN
023A45  EB 6D                 JMP    0x23ab4                      ; UNKNOWN
023A47  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
023A4C  E9 5E FF              JMP    0x239ad                      ; UNKNOWN
023A4F  83 FE 15              CMP    si, 0x15                     ; UNKNOWN
023A52  75 03                 JNE    0x23a57                      ; UNKNOWN
023A54  E9 51 FF              JMP    0x239a8                      ; UNKNOWN
023A57  83 FE 16              CMP    si, 0x16                     ; UNKNOWN
023A5A  75 03                 JNE    0x23a5f                      ; UNKNOWN
023A5C  E9 49 FF              JMP    0x239a8                      ; UNKNOWN
023A5F  83 FE 05              CMP    si, 5                        ; UNKNOWN
023A62  75 03                 JNE    0x23a67                      ; UNKNOWN
023A64  E9 41 FF              JMP    0x239a8                      ; UNKNOWN
023A67  83 FE 04              CMP    si, 4                        ; UNKNOWN
023A6A  75 03                 JNE    0x23a6f                      ; UNKNOWN
023A6C  E9 39 FF              JMP    0x239a8                      ; UNKNOWN
023A6F  83 FE 07              CMP    si, 7                        ; UNKNOWN
023A72  75 03                 JNE    0x23a77                      ; UNKNOWN
023A74  E9 31 FF              JMP    0x239a8                      ; UNKNOWN
023A77  83 FE 08              CMP    si, 8                        ; UNKNOWN
023A7A  75 03                 JNE    0x23a7f                      ; UNKNOWN
023A7C  E9 29 FF              JMP    0x239a8                      ; UNKNOWN
023A7F  83 FE 0C              CMP    si, 0xc                      ; UNKNOWN
023A82  74 0D                 JE     0x23a91                      ; UNKNOWN
023A84  83 FE 0A              CMP    si, 0xa                      ; UNKNOWN
023A87  74 08                 JE     0x23a91                      ; UNKNOWN
023A89  83 FE 0B              CMP    si, 0xb                      ; UNKNOWN
023A8C  74 03                 JE     0x23a91                      ; UNKNOWN
023A8E  E9 1C FF              JMP    0x239ad                      ; UNKNOWN
023A91  C7 46 EE 02 00        MOV    word ptr [bp - 0x12], 2      ; UNKNOWN
023A96  83 FE 0B              CMP    si, 0xb                      ; UNKNOWN
023A99  74 03                 JE     0x23a9e                      ; UNKNOWN
023A9B  E9 0F FF              JMP    0x239ad                      ; UNKNOWN
023A9E  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
023AA3  75 03                 JNE    0x23aa8                      ; UNKNOWN
023AA5  E9 05 FF              JMP    0x239ad                      ; UNKNOWN
023AA8  C7 46 EE 04 00        MOV    word ptr [bp - 0x12], 4      ; UNKNOWN
023AAD  E9 FD FE              JMP    0x239ad                      ; UNKNOWN
023AB0  8A 85 7A 09           MOV    al, byte ptr [di + 0x97a]    ; UNKNOWN
023AB4  88 46 E1              MOV    byte ptr [bp - 0x1f], al     ; UNKNOWN
023AB7  89 7E D8              MOV    word ptr [bp - 0x28], di     ; UNKNOWN
023ABA  88 46 F1              MOV    byte ptr [bp - 0xf], al      ; UNKNOWN
023ABD  83 7E E2 00           CMP    word ptr [bp - 0x1e], 0      ; UNKNOWN
023AC1  74 04                 JE     0x23ac7                      ; UNKNOWN
023AC3  C6 46 F1 00           MOV    byte ptr [bp - 0xf], 0       ; UNKNOWN
023AC7  8B 5E C0              MOV    bx, word ptr [bp - 0x40]     ; UNKNOWN
023ACA  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
023ACF  74 0E                 JE     0x23adf                      ; UNKNOWN
023AD1  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
023AD6  74 07                 JE     0x23adf                      ; UNKNOWN
023AD8  C7 46 E8 01 00        MOV    word ptr [bp - 0x18], 1      ; UNKNOWN
023ADD  EB 05                 JMP    0x23ae4                      ; UNKNOWN
023ADF  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; UNKNOWN
023AE4  83 7E E8 00           CMP    word ptr [bp - 0x18], 0      ; UNKNOWN
023AE8  74 51                 JE     0x23b3b                      ; UNKNOWN
023AEA  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
023AEE  2A FF                 SUB    bh, bh                       ; UNKNOWN
023AF0  8B C3                 MOV    ax, bx                       ; UNKNOWN
