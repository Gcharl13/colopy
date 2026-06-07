; ============================================================================
; func_0177DB_unknown
; Region   : load_image
; Bytes    : file 0x0177DB..0x017873  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0177DB  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
0177DF  56                    PUSH   si                           ; UNKNOWN
0177E0  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0177E4  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0177E6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0177E8  A3 2C 0B              MOV    word ptr [0xb2c], ax         ; UNKNOWN
0177EB  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
0177EE  A3 2E 0B              MOV    word ptr [0xb2e], ax         ; UNKNOWN
0177F1  9A 66 04 5F 24        LCALL  0x245f, 0x466                ; UNKNOWN
0177F6  8B D0                 MOV    dx, ax                       ; UNKNOWN
0177F8  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0177FC  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
0177FF  2A E4                 SUB    ah, ah                       ; UNKNOWN
017801  9A 81 10 98 3A        LCALL  0x3a98, 0x1081               ; UNKNOWN
017806  9A 47 02 E8 39        LCALL  0x39e8, 0x247                ; UNKNOWN
01780B  9A EA 00 E8 39        LCALL  0x39e8, 0xea                 ; UNKNOWN
017810  6A 50                 PUSH   0x50                         ; UNKNOWN
017812  6A 50                 PUSH   0x50                         ; UNKNOWN
017814  6A 08                 PUSH   8                            ; UNKNOWN
017816  68 C8 00              PUSH   0xc8                         ; UNKNOWN
017819  6A 00                 PUSH   0                            ; UNKNOWN
01781B  6A 00                 PUSH   0                            ; UNKNOWN
01781D  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
017821  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
017825  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
017829  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
01782D  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
017831  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
017835  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
017839  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
01783D  9A 83 00 F4 44        LCALL  0x44f4, 0x83                 ; UNKNOWN
017842  83 C4 1C              ADD    sp, 0x1c                     ; UNKNOWN
017845  9A 66 04 5F 24        LCALL  0x245f, 0x466                ; UNKNOWN
01784A  8B D8                 MOV    bx, ax                       ; UNKNOWN
01784C  8A 87 D6 0A           MOV    al, byte ptr [bx + 0xad6]    ; UNKNOWN
017850  2A E4                 SUB    ah, ah                       ; UNKNOWN
017852  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
017855  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
01785A  E9 A4 00              JMP    0x17901                      ; UNKNOWN
01785D  8B D8                 MOV    bx, ax                       ; UNKNOWN
01785F  8B C8                 MOV    cx, ax                       ; UNKNOWN
017861  8A 87 4D 09           MOV    al, byte ptr [bx + 0x94d]    ; UNKNOWN
017865  98                    CWDE                                ; UNKNOWN
017866  8B 36 38 73           MOV    si, word ptr [0x7338]        ; UNKNOWN
01786A  8A 54 01              MOV    dl, byte ptr [si + 1]        ; UNKNOWN
01786D  2A F6                 SUB    dh, dh                       ; UNKNOWN
01786F  03 C2                 ADD    ax, dx                       ; UNKNOWN
017871  89                    DB     0x89                         ; UNKNOWN (raw)
017872  46                    DB     0x46                         ; UNKNOWN (raw)
