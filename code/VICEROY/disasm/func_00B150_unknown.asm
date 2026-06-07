; ============================================================================
; func_00B150_unknown
; Region   : load_image
; Bytes    : file 0x00B150..0x00B1EB  (155 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B150  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
00B154  56                    PUSH   si                           ; UNKNOWN
00B155  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; LOCAL_STORE
00B15A  EB 0A                 JMP    0xb166                       ; UNKNOWN
00B15C  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; LOCAL_LOAD
00B15F  C6 42 DE 00           MOV    byte ptr [bp + si - 0x22], 0 ; LOCAL_STORE
00B163  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
00B166  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00B16A  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00B16D  98                    CWDE                                ; UNKNOWN
00B16E  3B 46 DC              CMP    ax, word ptr [bp - 0x24]     ; CMP
00B171  7F E9                 JG     0xb15c                       ; UNKNOWN
00B173  C6 46 FE 00           MOV    byte ptr [bp - 2], 0         ; UNKNOWN
00B177  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
00B17A  98                    CWDE                                ; UNKNOWN
00B17B  8B F0                 MOV    si, ax                       ; UNKNOWN
00B17D  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00B181  80 78 70 00           CMP    byte ptr [bx + si + 0x70], 0 ; CMP
00B185  7C 0A                 JL     0xb191                       ; UNKNOWN
00B187  8A 40 70              MOV    al, byte ptr [bx + si + 0x70] ; MOV
00B18A  98                    CWDE                                ; UNKNOWN
00B18B  8B F0                 MOV    si, ax                       ; UNKNOWN
00B18D  C6 42 DE 01           MOV    byte ptr [bp + si - 0x22], 1 ; LOCAL_STORE
00B191  FE 46 FE              INC    byte ptr [bp - 2]            ; UNKNOWN
00B194  80 7E FE 14           CMP    byte ptr [bp - 2], 0x14      ; CMP
00B198  7C DD                 JL     0xb177                       ; UNKNOWN
00B19A  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; LOCAL_STORE
00B19F  EB 10                 JMP    0xb1b1                       ; UNKNOWN
00B1A1  90                    NOP                                 ; UNKNOWN
00B1A2  6A 0D                 PUSH   0xd                          ; UNKNOWN
00B1A4  FF 76 DC              PUSH   word ptr [bp - 0x24]         ; UNKNOWN
00B1A7  0E                    PUSH   cs                           ; UNKNOWN
00B1A8  E8 6D E1              CALL   0x9318                       ; UNKNOWN
00B1AB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B1AE  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
00B1B1  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00B1B5  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
00B1B8  98                    CWDE                                ; UNKNOWN
00B1B9  3B 46 DC              CMP    ax, word ptr [bp - 0x24]     ; CMP
00B1BC  7E 2A                 JLE    0xb1e8                       ; UNKNOWN
00B1BE  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; LOCAL_LOAD
00B1C1  80 7A DE 00           CMP    byte ptr [bp + si - 0x22], 0 ; CMP
00B1C5  75 E7                 JNE    0xb1ae                       ; UNKNOWN
00B1C7  56                    PUSH   si                           ; UNKNOWN
00B1C8  0E                    PUSH   cs                           ; UNKNOWN
00B1C9  E8 FC DE              CALL   0x90c8                       ; UNKNOWN
00B1CC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00B1CF  3D 09 00              CMP    ax, 9                        ; UNKNOWN
00B1D2  7D DA                 JGE    0xb1ae                       ; UNKNOWN
00B1D4  6A FF                 PUSH   -1                           ; UNKNOWN
00B1D6  56                    PUSH   si                           ; UNKNOWN
00B1D7  0E                    PUSH   cs                           ; UNKNOWN
00B1D8  E8 9D F9              CALL   0xab78                       ; UNKNOWN
00B1DB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B1DE  0B C0                 OR     ax, ax                       ; UNKNOWN
00B1E0  75 C0                 JNE    0xb1a2                       ; UNKNOWN
00B1E2  C6 42 DE 01           MOV    byte ptr [bp + si - 0x22], 1 ; LOCAL_STORE
00B1E6  EB C6                 JMP    0xb1ae                       ; UNKNOWN
00B1E8  5E                    POP    si                           ; UNKNOWN
00B1E9  C9                    LEAVE                               ; UNKNOWN
00B1EA  CB                    RETF                                ; UNKNOWN
