; ============================================================================
; func_020629_unknown
; Region   : load_image
; Bytes    : file 0x020629..0x0206B7  (142 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020629  C8 5A 00 00           ENTER  0x5a, 0                      ; UNKNOWN
02062D  57                    PUSH   di                           ; UNKNOWN
02062E  56                    PUSH   si                           ; UNKNOWN
02062F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
020632  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
020637  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02063A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02063D  39 06 4A 3E           CMP    word ptr [0x3e4a], ax        ; UNKNOWN
020641  75 58                 JNE    0x2069b                      ; UNKNOWN
020643  69 1E 10 3E 3C 01     IMUL   bx, word ptr [0x3e10], 0x13c ; UNKNOWN
020649  F6 87 AA 74 08        TEST   byte ptr [bx + 0x74aa], 8    ; UNKNOWN
02064E  74 08                 JE     0x20658                      ; UNKNOWN
020650  50                    PUSH   ax                           ; UNKNOWN
020651  0E                    PUSH   cs                           ; UNKNOWN
020652  E8 F8 FC              CALL   0x2034d                      ; UNKNOWN
020655  83 C4 02              ADD    sp, 2                        ; UNKNOWN
020658  83 3E 58 3E 00        CMP    word ptr [0x3e58], 0         ; UNKNOWN
02065D  7E 05                 JLE    0x20664                      ; UNKNOWN
02065F  B8 01 00              MOV    ax, 1                        ; UNKNOWN
020662  EB 02                 JMP    0x20666                      ; UNKNOWN
020664  2B C0                 SUB    ax, ax                       ; UNKNOWN
020666  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
020669  83 3E 54 3E 00        CMP    word ptr [0x3e54], 0         ; UNKNOWN
02066E  7E 05                 JLE    0x20675                      ; UNKNOWN
020670  B8 01 00              MOV    ax, 1                        ; UNKNOWN
020673  EB 02                 JMP    0x20677                      ; UNKNOWN
020675  2B C0                 SUB    ax, ax                       ; UNKNOWN
020677  03 46 A6              ADD    ax, word ptr [bp - 0x5a]     ; UNKNOWN
02067A  03 06 52 3E           ADD    ax, word ptr [0x3e52]        ; UNKNOWN
02067E  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
020681  0B C0                 OR     ax, ax                       ; UNKNOWN
020683  74 0B                 JE     0x20690                      ; UNKNOWN
020685  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
020689  0E                    PUSH   cs                           ; UNKNOWN
02068A  E8 16 E9              CALL   0x1efa3                      ; UNKNOWN
02068D  E9 AF 01              JMP    0x2083f                      ; UNKNOWN
020690  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
020694  0E                    PUSH   cs                           ; UNKNOWN
020695  E8 33 E6              CALL   0x1eccb                      ; UNKNOWN
020698  E9 A4 01              JMP    0x2083f                      ; UNKNOWN
02069B  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
02069F  F6 07 08              TEST   byte ptr [bx], 8             ; UNKNOWN
0206A2  75 13                 JNE    0x206b7                      ; UNKNOWN
0206A4  50                    PUSH   ax                           ; UNKNOWN
0206A5  0E                    PUSH   cs                           ; UNKNOWN
0206A6  E8 2A FE              CALL   0x204d3                      ; UNKNOWN
0206A9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0206AC  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
0206B0  80 0F 08              OR     byte ptr [bx], 8             ; UNKNOWN
0206B3  5E                    POP    si                           ; UNKNOWN
0206B4  5F                    POP    di                           ; UNKNOWN
0206B5  C9                    LEAVE                               ; UNKNOWN
0206B6  CB                    RETF                                ; UNKNOWN
