; ============================================================================
; func_0342E6_unknown
; Region   : load_image
; Bytes    : file 0x0342E6..0x0343AD  (199 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0342E6  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
0342EA  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
0342ED  50                    PUSH   ax                           ; UNKNOWN
0342EE  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
0342F1  50                    PUSH   ax                           ; UNKNOWN
0342F2  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
0342F5  50                    PUSH   ax                           ; UNKNOWN
0342F6  8D 4E FE              LEA    cx, [bp - 2]                 ; UNKNOWN
0342F9  51                    PUSH   cx                           ; UNKNOWN
0342FA  8D 56 FC              LEA    dx, [bp - 4]                 ; UNKNOWN
0342FD  52                    PUSH   dx                           ; UNKNOWN
0342FE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034301  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
034304  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
034306  0E                    PUSH   cs                           ; UNKNOWN
034307  E8 6A FF              CALL   0x34274                      ; UNKNOWN
03430A  83 C4 0E              ADD    sp, 0xe                      ; UNKNOWN
03430D  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
034311  7D 5A                 JGE    0x3436d                      ; UNKNOWN
034313  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034316  6A 10                 PUSH   0x10                         ; UNKNOWN
034318  6A 64                 PUSH   0x64                         ; UNKNOWN
03431A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03431D  2B D2                 SUB    dx, dx                       ; UNKNOWN
03431F  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
034322  9A BD 01 76 1A        LCALL  0x1a76, 0x1bd                ; UNKNOWN
034327  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
03432B  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
034330  72 3B                 JB     0x3436d                      ; UNKNOWN
034332  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
034337  77 34                 JA     0x3436d                      ; UNKNOWN
034339  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
03433D  75 2E                 JNE    0x3436d                      ; UNKNOWN
03433F  80 BF 8C 88 00        CMP    byte ptr [bx - 0x7774], 0    ; UNKNOWN
034344  74 27                 JE     0x3436d                      ; UNKNOWN
034346  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
03434A  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
03434E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034351  6A 00                 PUSH   0                            ; UNKNOWN
034353  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
034356  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
03435B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03435E  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
034361  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
034365  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
034368  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
03436D  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
034371  7C 33                 JL     0x343a6                      ; UNKNOWN
034373  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
034377  7D 2D                 JGE    0x343a6                      ; UNKNOWN
034379  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
03437D  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
034381  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
034385  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
034389  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
03438C  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
03438F  50                    PUSH   ax                           ; UNKNOWN
034390  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
034393  50                    PUSH   ax                           ; UNKNOWN
034394  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
034397  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
03439A  03 D8                 ADD    bx, ax                       ; UNKNOWN
03439C  48                    DEC    ax                           ; UNKNOWN
03439D  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
0343A0  4A                    DEC    dx                           ; UNKNOWN
0343A1  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
0343A6  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0343A9  FF 07                 INC    word ptr [bx]                ; UNKNOWN
0343AB  C9                    LEAVE                               ; UNKNOWN
0343AC  CB                    RETF                                ; UNKNOWN
