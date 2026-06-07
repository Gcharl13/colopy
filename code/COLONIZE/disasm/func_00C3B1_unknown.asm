; ============================================================================
; func_00C3B1_unknown
; Region   : load_image
; Bytes    : file 0x00C3B1..0x00C498  (231 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C3B1  C8 60 00 00           ENTER  0x60, 0                      ; UNKNOWN
00C3B5  57                    PUSH   di                           ; UNKNOWN
00C3B6  56                    PUSH   si                           ; UNKNOWN
00C3B7  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
00C3BC  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00C3C1  75 0C                 JNE    0xc3cf                       ; UNKNOWN
00C3C3  9A 97 07 2F 23        LCALL  0x232f, 0x797                ; UNKNOWN
00C3C8  0B C0                 OR     ax, ax                       ; UNKNOWN
00C3CA  74 08                 JE     0xc3d4                       ; UNKNOWN
00C3CC  E9 AD 02              JMP    0xc67c                       ; UNKNOWN
00C3CF  C6 06 1E 3E 02        MOV    byte ptr [0x3e1e], 2         ; UNKNOWN
00C3D4  80 3E 1E 3E 00        CMP    byte ptr [0x3e1e], 0         ; UNKNOWN
00C3D9  75 05                 JNE    0xc3e0                       ; UNKNOWN
00C3DB  80 0E FA 3D 80        OR     byte ptr [0x3dfa], 0x80      ; UNKNOWN
00C3E0  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00C3E5  75 0C                 JNE    0xc3f3                       ; UNKNOWN
00C3E7  9A 2E 0C 2F 23        LCALL  0x232f, 0xc2e                ; UNKNOWN
00C3EC  0B C0                 OR     ax, ax                       ; UNKNOWN
00C3EE  74 12                 JE     0xc402                       ; UNKNOWN
00C3F0  E9 89 02              JMP    0xc67c                       ; UNKNOWN
00C3F3  6A 03                 PUSH   3                            ; UNKNOWN
00C3F5  6A 00                 PUSH   0                            ; UNKNOWN
00C3F7  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00C3FC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00C3FF  A3 10 3E              MOV    word ptr [0x3e10], ax        ; UNKNOWN
00C402  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
00C405  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00C408  83 F8 03              CMP    ax, 3                        ; UNKNOWN
00C40B  7E 06                 JLE    0xc413                       ; UNKNOWN
00C40D  C7 06 10 3E 00 00     MOV    word ptr [0x3e10], 0         ; UNKNOWN
00C413  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
00C418  74 03                 JE     0xc41d                       ; UNKNOWN
00C41A  E9 74 01              JMP    0xc591                       ; UNKNOWN
00C41D  6A 00                 PUSH   0                            ; UNKNOWN
00C41F  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00C423  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00C427  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00C42B  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00C42F  68 B8 1A              PUSH   0x1ab8                       ; UNKNOWN
00C432  9A 08 00 5E 1A        LCALL  0x1a5e, 8                    ; UNKNOWN
00C437  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
00C43A  83 F8 01              CMP    ax, 1                        ; UNKNOWN
00C43D  1B C0                 SBB    ax, ax                       ; UNKNOWN
00C43F  F7 D8                 NEG    ax                           ; UNKNOWN
00C441  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00C444  0B C0                 OR     ax, ax                       ; UNKNOWN
00C446  74 45                 JE     0xc48d                       ; UNKNOWN
00C448  9A 93 37 97 1B        LCALL  0x1b97, 0x3793               ; UNKNOWN
00C44D  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
00C451  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
00C455  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
00C459  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
00C45D  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
00C461  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
00C465  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
00C469  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
00C46D  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00C470  2B C0                 SUB    ax, ax                       ; UNKNOWN
00C472  99                    CDQ                                 ; UNKNOWN
00C473  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
00C476  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
00C47B  6A 00                 PUSH   0                            ; UNKNOWN
00C47D  68 40 01              PUSH   0x140                        ; UNKNOWN
00C480  68 C8 00              PUSH   0xc8                         ; UNKNOWN
00C483  2B C0                 SUB    ax, ax                       ; UNKNOWN
00C485  99                    CDQ                                 ; UNKNOWN
00C486  2B DB                 SUB    bx, bx                       ; UNKNOWN
00C488  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
00C48D  6A 17                 PUSH   0x17                         ; UNKNOWN
00C48F  6B 16 10 3E 34        IMUL   dx, word ptr [0x3e10], 0x34  ; UNKNOWN
00C494  81 C2 86 C0           ADD    dx, 0xc086                   ; UNKNOWN
