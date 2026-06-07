; ============================================================================
; func_0676B4_unknown
; Region   : load_image
; Bytes    : file 0x0676B4..0x067716  (98 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0676B4  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0676B8  53                    PUSH   bx                           ; UNKNOWN
0676B9  57                    PUSH   di                           ; UNKNOWN
0676BA  56                    PUSH   si                           ; UNKNOWN
0676BB  2B FF                 SUB    di, di                       ; UNKNOWN
0676BD  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
0676C0  74 4E                 JE     0x67710                      ; UNKNOWN
0676C2  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0676C4  98                    CWDE                                ; UNKNOWN
0676C5  8B F0                 MOV    si, ax                       ; UNKNOWN
0676C7  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
0676CA  F6 84 BB 13 02        TEST   byte ptr [si + 0x13bb], 2    ; UNKNOWN
0676CF  74 03                 JE     0x676d4                      ; UNKNOWN
0676D1  83 EE 20              SUB    si, 0x20                     ; UNKNOWN
0676D4  F6 84 BB 13 04        TEST   byte ptr [si + 0x13bb], 4    ; UNKNOWN
0676D9  74 0A                 JE     0x676e5                      ; UNKNOWN
0676DB  C1 E7 04              SHL    di, 4                        ; UNKNOWN
0676DE  8D 44 D0              LEA    ax, [si - 0x30]              ; UNKNOWN
0676E1  03 F8                 ADD    di, ax                       ; UNKNOWN
0676E3  EB 23                 JMP    0x67708                      ; UNKNOWN
0676E5  83 FE 41              CMP    si, 0x41                     ; UNKNOWN
0676E8  7C 0D                 JL     0x676f7                      ; UNKNOWN
0676EA  83 FE 46              CMP    si, 0x46                     ; UNKNOWN
0676ED  7F 08                 JG     0x676f7                      ; UNKNOWN
0676EF  C1 E7 04              SHL    di, 4                        ; UNKNOWN
0676F2  8D 44 C9              LEA    ax, [si - 0x37]              ; UNKNOWN
0676F5  EB EA                 JMP    0x676e1                      ; UNKNOWN
0676F7  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0676FA  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
0676FD  74 09                 JE     0x67708                      ; UNKNOWN
0676FF  43                    INC    bx                           ; UNKNOWN
067700  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
067703  75 FA                 JNE    0x676ff                      ; UNKNOWN
067705  89 5E FA              MOV    word ptr [bp - 6], bx        ; UNKNOWN
067708  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
06770B  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
06770E  75 B2                 JNE    0x676c2                      ; UNKNOWN
067710  8B C7                 MOV    ax, di                       ; UNKNOWN
067712  5E                    POP    si                           ; UNKNOWN
067713  5F                    POP    di                           ; UNKNOWN
067714  C9                    LEAVE                               ; UNKNOWN
067715  CB                    RETF                                ; UNKNOWN
