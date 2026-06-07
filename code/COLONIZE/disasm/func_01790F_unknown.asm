; ============================================================================
; func_01790F_unknown
; Region   : load_image
; Bytes    : file 0x01790F..0x0179E7  (216 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01790F  C8 20 00 00           ENTER  0x20, 0                      ; UNKNOWN
017913  56                    PUSH   si                           ; UNKNOWN
017914  A0 03 09              MOV    al, byte ptr [0x903]         ; UNKNOWN
017917  2A E4                 SUB    ah, ah                       ; UNKNOWN
017919  A3 96 0B              MOV    word ptr [0xb96], ax         ; UNKNOWN
01791C  B8 18 00              MOV    ax, 0x18                     ; UNKNOWN
01791F  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
017922  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
017925  A0 67 09              MOV    al, byte ptr [0x967]         ; UNKNOWN
017928  2A E4                 SUB    ah, ah                       ; UNKNOWN
01792A  50                    PUSH   ax                           ; UNKNOWN
01792B  6A 78                 PUSH   0x78                         ; UNKNOWN
01792D  6A 78                 PUSH   0x78                         ; UNKNOWN
01792F  6A 08                 PUSH   8                            ; UNKNOWN
017931  B8 C8 00              MOV    ax, 0xc8                     ; UNKNOWN
017934  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
017937  50                    PUSH   ax                           ; UNKNOWN
017938  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
01793C  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
017940  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
017944  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
017948  9A 6D 00 30 22        LCALL  0x2230, 0x6d                 ; UNKNOWN
01794D  83 C4 12              ADD    sp, 0x12                     ; UNKNOWN
017950  6A 48                 PUSH   0x48                         ; UNKNOWN
017952  6A 48                 PUSH   0x48                         ; UNKNOWN
017954  6A 20                 PUSH   0x20                         ; UNKNOWN
017956  68 E0 00              PUSH   0xe0                         ; UNKNOWN
017959  0E                    PUSH   cs                           ; UNKNOWN
01795A  E8 48 FE              CALL   0x177a5                      ; UNKNOWN
01795D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
017960  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
017964  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
017968  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
01796C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
017970  68 80 00              PUSH   0x80                         ; UNKNOWN
017973  6A 00                 PUSH   0                            ; UNKNOWN
017975  B8 C7 00              MOV    ax, 0xc7                     ; UNKNOWN
017978  BA 07 00              MOV    dx, 7                        ; UNKNOWN
01797B  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
01797E  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
017983  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
017987  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
01798B  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
01798F  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
017993  6A 68                 PUSH   0x68                         ; UNKNOWN
017995  6A 00                 PUSH   0                            ; UNKNOWN
017997  B8 DF 00              MOV    ax, 0xdf                     ; UNKNOWN
01799A  BA 1F 00              MOV    dx, 0x1f                     ; UNKNOWN
01799D  BB 28 01              MOV    bx, 0x128                    ; UNKNOWN
0179A0  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
0179A5  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; UNKNOWN
0179AA  E9 54 03              JMP    0x17d01                      ; UNKNOWN
0179AD  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
0179B0  8B C6                 MOV    ax, si                       ; UNKNOWN
0179B2  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0179B5  03 F0                 ADD    si, ax                       ; UNKNOWN
0179B7  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
0179BA  8A 80 B0 73           MOV    al, byte ptr [bx + si + 0x73b0] ; UNKNOWN
0179BE  2A E4                 SUB    ah, ah                       ; UNKNOWN
0179C0  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0179C3  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0179C5  74 29                 JE     0x179f0                      ; UNKNOWN
0179C7  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0179CB  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0179CF  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0179D3  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
0179D7  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
0179DA  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
0179DD  50                    PUSH   ax                           ; UNKNOWN
0179DE  6A 0C                 PUSH   0xc                          ; UNKNOWN
0179E0  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0179E3  8B D8                 MOV    bx, ax                       ; UNKNOWN
0179E5  83                    DB     0x83                         ; UNKNOWN (raw)
0179E6  C3                    DB     0xC3                         ; UNKNOWN (raw)
