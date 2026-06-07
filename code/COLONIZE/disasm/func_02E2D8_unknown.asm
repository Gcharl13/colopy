; ============================================================================
; func_02E2D8_unknown
; Region   : load_image
; Bytes    : file 0x02E2D8..0x02E360  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E2D8  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02E2DC  56                    PUSH   si                           ; UNKNOWN
02E2DD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02E2E0  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E2E3  EB 29                 JMP    0x2e30e                      ; UNKNOWN
02E2E5  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
02E2E8  8A 47 21              MOV    al, byte ptr [bx + 0x21]     ; UNKNOWN
02E2EB  88 47 20              MOV    byte ptr [bx + 0x20], al     ; UNKNOWN
02E2EE  8A 47 41              MOV    al, byte ptr [bx + 0x41]     ; UNKNOWN
02E2F1  88 47 40              MOV    byte ptr [bx + 0x40], al     ; UNKNOWN
02E2F4  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02E2F7  40                    INC    ax                           ; UNKNOWN
02E2F8  50                    PUSH   ax                           ; UNKNOWN
02E2F9  0E                    PUSH   cs                           ; UNKNOWN
02E2FA  E8 53 FF              CALL   0x2e250                      ; UNKNOWN
02E2FD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E300  50                    PUSH   ax                           ; UNKNOWN
02E301  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02E304  0E                    PUSH   cs                           ; UNKNOWN
02E305  E8 88 FF              CALL   0x2e290                      ; UNKNOWN
02E308  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E30B  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02E30E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E312  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E315  98                    CWDE                                ; UNKNOWN
02E316  48                    DEC    ax                           ; UNKNOWN
02E317  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
02E31A  7F C9                 JG     0x2e2e5                      ; UNKNOWN
02E31C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02E321  EB 0E                 JMP    0x2e331                      ; UNKNOWN
02E323  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02E326  38 40 70              CMP    byte ptr [bx + si + 0x70], al ; UNKNOWN
02E329  7E 03                 JLE    0x2e32e                      ; UNKNOWN
02E32B  FE 48 70              DEC    byte ptr [bx + si + 0x70]    ; UNKNOWN
02E32E  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02E331  83 7E FE 14           CMP    word ptr [bp - 2], 0x14      ; UNKNOWN
02E335  7D 15                 JGE    0x2e34c                      ; UNKNOWN
02E337  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
02E33A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E33E  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
02E341  38 40 70              CMP    byte ptr [bx + si + 0x70], al ; UNKNOWN
02E344  75 DD                 JNE    0x2e323                      ; UNKNOWN
02E346  C6 40 70 FF           MOV    byte ptr [bx + si + 0x70], 0xff ; UNKNOWN
02E34A  EB E2                 JMP    0x2e32e                      ; UNKNOWN
02E34C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E350  FE 4F 1F              DEC    byte ptr [bx + 0x1f]         ; UNKNOWN
02E353  83 AF C6 00 64        SUB    word ptr [bx + 0xc6], 0x64   ; UNKNOWN
02E358  83 9F C8 00 00        SBB    word ptr [bx + 0xc8], 0      ; UNKNOWN
02E35D  5E                    POP    si                           ; UNKNOWN
02E35E  C9                    LEAVE                               ; UNKNOWN
02E35F  CB                    RETF                                ; UNKNOWN
