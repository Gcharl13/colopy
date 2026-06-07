; ============================================================================
; func_03383F_unknown
; Region   : load_image
; Bytes    : file 0x03383F..0x03397D  (318 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03383F  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
033843  8B 1E 9A 79           MOV    bx, word ptr [0x799a]        ; UNKNOWN
033847  D1 E3                 SHL    bx, 1                        ; UNKNOWN
033849  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
03384D  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
033852  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033855  52                    PUSH   dx                           ; UNKNOWN
033856  50                    PUSH   ax                           ; UNKNOWN
033857  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03385A  16                    PUSH   ss                           ; UNKNOWN
03385B  50                    PUSH   ax                           ; UNKNOWN
03385C  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
033861  83 C4 08              ADD    sp, 8                        ; UNKNOWN
033864  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033867  50                    PUSH   ax                           ; UNKNOWN
033868  9A 3D 00 13 24        LCALL  0x2413, 0x3d                 ; UNKNOWN
03386D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033870  8B 1E 9A 79           MOV    bx, word ptr [0x799a]        ; UNKNOWN
033874  D1 E3                 SHL    bx, 1                        ; UNKNOWN
033876  FF B7 2B 38           PUSH   word ptr [bx + 0x382b]       ; UNKNOWN
03387A  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
03387F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033882  52                    PUSH   dx                           ; UNKNOWN
033883  50                    PUSH   ax                           ; UNKNOWN
033884  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033887  16                    PUSH   ss                           ; UNKNOWN
033888  50                    PUSH   ax                           ; UNKNOWN
033889  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
03388E  83 C4 08              ADD    sp, 8                        ; UNKNOWN
033891  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033894  50                    PUSH   ax                           ; UNKNOWN
033895  9A 5D 00 13 24        LCALL  0x2413, 0x5d                 ; UNKNOWN
03389A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03389D  8B 1E 04 3E           MOV    bx, word ptr [0x3e04]        ; UNKNOWN
0338A1  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0338A3  FF B7 D9 3D           PUSH   word ptr [bx + 0x3dd9]       ; UNKNOWN
0338A7  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
0338AC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0338AF  52                    PUSH   dx                           ; UNKNOWN
0338B0  50                    PUSH   ax                           ; UNKNOWN
0338B1  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0338B4  16                    PUSH   ss                           ; UNKNOWN
0338B5  50                    PUSH   ax                           ; UNKNOWN
0338B6  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
0338BB  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0338BE  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0338C1  50                    PUSH   ax                           ; UNKNOWN
0338C2  9A 3D 00 13 24        LCALL  0x2413, 0x3d                 ; UNKNOWN
0338C7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0338CA  6A 0A                 PUSH   0xa                          ; UNKNOWN
0338CC  8D 46 9C              LEA    ax, [bp - 0x64]              ; UNKNOWN
0338CF  50                    PUSH   ax                           ; UNKNOWN
0338D0  FF 36 02 3E           PUSH   word ptr [0x3e02]            ; UNKNOWN
0338D4  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
0338D9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0338DC  8D 46 9C              LEA    ax, [bp - 0x64]              ; UNKNOWN
0338DF  50                    PUSH   ax                           ; UNKNOWN
0338E0  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0338E3  50                    PUSH   ax                           ; UNKNOWN
0338E4  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
0338E9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0338EC  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0338EF  50                    PUSH   ax                           ; UNKNOWN
0338F0  9A 5D 00 13 24        LCALL  0x2413, 0x5d                 ; UNKNOWN
0338F5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0338F8  FF 36 AB 3B           PUSH   word ptr [0x3bab]            ; UNKNOWN
0338FC  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
0338FF  50                    PUSH   ax                           ; UNKNOWN
033900  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
033905  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033908  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
03390C  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
03390F  98                    CWDE                                ; UNKNOWN
033910  50                    PUSH   ax                           ; UNKNOWN
033911  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033914  16                    PUSH   ss                           ; UNKNOWN
033915  50                    PUSH   ax                           ; UNKNOWN
033916  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
03391B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03391E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033921  50                    PUSH   ax                           ; UNKNOWN
033922  9A 6D 00 13 24        LCALL  0x2413, 0x6d                 ; UNKNOWN
033927  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03392A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03392D  50                    PUSH   ax                           ; UNKNOWN
03392E  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
033933  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033936  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033939  50                    PUSH   ax                           ; UNKNOWN
03393A  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
03393F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
033942  FF 36 9B 3B           PUSH   word ptr [0x3b9b]            ; UNKNOWN
033946  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033949  50                    PUSH   ax                           ; UNKNOWN
03394A  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
03394F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033952  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033955  50                    PUSH   ax                           ; UNKNOWN
033956  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
03395B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03395E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033961  50                    PUSH   ax                           ; UNKNOWN
033962  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
033966  9A A5 05 5F 24        LCALL  0x245f, 0x5a5                ; UNKNOWN
03396B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03396E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
033971  16                    PUSH   ss                           ; UNKNOWN
033972  50                    PUSH   ax                           ; UNKNOWN
033973  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
033976  9A D0 02 2B 3E        LCALL  0x3e2b, 0x2d0                ; UNKNOWN
03397B  C9                    LEAVE                               ; UNKNOWN
03397C  C3                    RET                                 ; UNKNOWN
