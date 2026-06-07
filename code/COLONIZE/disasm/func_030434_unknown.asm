; ============================================================================
; func_030434_unknown
; Region   : load_image
; Bytes    : file 0x030434..0x0304CE  (154 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030434  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
030438  56                    PUSH   si                           ; UNKNOWN
030439  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
03043E  EB 0A                 JMP    0x3044a                      ; UNKNOWN
030440  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; UNKNOWN
030443  C6 42 DE 00           MOV    byte ptr [bp + si - 0x22], 0 ; UNKNOWN
030447  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
03044A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03044E  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
030451  98                    CWDE                                ; UNKNOWN
030452  3B 46 DC              CMP    ax, word ptr [bp - 0x24]     ; UNKNOWN
030455  7F E9                 JG     0x30440                      ; UNKNOWN
030457  C6 46 FE 00           MOV    byte ptr [bp - 2], 0         ; UNKNOWN
03045B  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
03045E  98                    CWDE                                ; UNKNOWN
03045F  8B F0                 MOV    si, ax                       ; UNKNOWN
030461  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030465  80 78 70 00           CMP    byte ptr [bx + si + 0x70], 0 ; UNKNOWN
030469  7C 0A                 JL     0x30475                      ; UNKNOWN
03046B  8A 40 70              MOV    al, byte ptr [bx + si + 0x70] ; UNKNOWN
03046E  98                    CWDE                                ; UNKNOWN
03046F  8B F0                 MOV    si, ax                       ; UNKNOWN
030471  C6 42 DE 01           MOV    byte ptr [bp + si - 0x22], 1 ; UNKNOWN
030475  FE 46 FE              INC    byte ptr [bp - 2]            ; UNKNOWN
030478  80 7E FE 14           CMP    byte ptr [bp - 2], 0x14      ; UNKNOWN
03047C  7C DD                 JL     0x3045b                      ; UNKNOWN
03047E  C7 46 DC 00 00        MOV    word ptr [bp - 0x24], 0      ; UNKNOWN
030483  EB 0F                 JMP    0x30494                      ; UNKNOWN
030485  6A 0D                 PUSH   0xd                          ; UNKNOWN
030487  FF 76 DC              PUSH   word ptr [bp - 0x24]         ; UNKNOWN
03048A  0E                    PUSH   cs                           ; UNKNOWN
03048B  E8 9F E1              CALL   0x2e62d                      ; UNKNOWN
03048E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030491  FF 46 DC              INC    word ptr [bp - 0x24]         ; UNKNOWN
030494  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030498  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
03049B  98                    CWDE                                ; UNKNOWN
03049C  3B 46 DC              CMP    ax, word ptr [bp - 0x24]     ; UNKNOWN
03049F  7E 2A                 JLE    0x304cb                      ; UNKNOWN
0304A1  8B 76 DC              MOV    si, word ptr [bp - 0x24]     ; UNKNOWN
0304A4  80 7A DE 00           CMP    byte ptr [bp + si - 0x22], 0 ; UNKNOWN
0304A8  75 E7                 JNE    0x30491                      ; UNKNOWN
0304AA  56                    PUSH   si                           ; UNKNOWN
0304AB  0E                    PUSH   cs                           ; UNKNOWN
0304AC  E8 38 DF              CALL   0x2e3e7                      ; UNKNOWN
0304AF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0304B2  83 F8 09              CMP    ax, 9                        ; UNKNOWN
0304B5  7D DA                 JGE    0x30491                      ; UNKNOWN
0304B7  6A FF                 PUSH   -1                           ; UNKNOWN
0304B9  56                    PUSH   si                           ; UNKNOWN
0304BA  0E                    PUSH   cs                           ; UNKNOWN
0304BB  E8 A3 F9              CALL   0x2fe61                      ; UNKNOWN
0304BE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0304C1  0B C0                 OR     ax, ax                       ; UNKNOWN
0304C3  75 C0                 JNE    0x30485                      ; UNKNOWN
0304C5  C6 42 DE 01           MOV    byte ptr [bp + si - 0x22], 1 ; UNKNOWN
0304C9  EB C6                 JMP    0x30491                      ; UNKNOWN
0304CB  5E                    POP    si                           ; UNKNOWN
0304CC  C9                    LEAVE                               ; UNKNOWN
0304CD  CB                    RETF                                ; UNKNOWN
