; ============================================================================
; func_066ABA_unknown
; Region   : load_image
; Bytes    : file 0x066ABA..0x066B1E  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066ABA  55                    PUSH   bp                           ; UNKNOWN
066ABB  8B EC                 MOV    bp, sp                       ; UNKNOWN
066ABD  53                    PUSH   bx                           ; UNKNOWN
066ABE  52                    PUSH   dx                           ; UNKNOWN
066ABF  57                    PUSH   di                           ; UNKNOWN
066AC0  56                    PUSH   si                           ; UNKNOWN
066AC1  C5 7E 0C              LDS    di, ptr [bp + 0xc]           ; UNKNOWN
066AC4  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
066AC7  8B F0                 MOV    si, ax                       ; UNKNOWN
066AC9  D1 E6                 SHL    si, 1                        ; UNKNOWN
066ACB  03 F0                 ADD    si, ax                       ; UNKNOWN
066ACD  C1 E6 02              SHL    si, 2                        ; UNKNOWN
066AD0  03 F7                 ADD    si, di                       ; UNKNOWN
066AD2  83 C6 36              ADD    si, 0x36                     ; UNKNOWN
066AD5  8B 44 08              MOV    ax, word ptr [si + 8]        ; UNKNOWN
066AD8  F7 66 0A              MUL    word ptr [bp + 0xa]          ; UNKNOWN
066ADB  83 C0 32              ADD    ax, 0x32                     ; UNKNOWN
066ADE  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
066AE1  2B D2                 SUB    dx, dx                       ; UNKNOWN
066AE3  F7 F1                 DIV    cx                           ; UNKNOWN
066AE5  26 89 47 08           MOV    word ptr es:[bx + 8], ax     ; UNKNOWN
066AE9  8B D0                 MOV    dx, ax                       ; UNKNOWN
066AEB  8B 44 0A              MOV    ax, word ptr [si + 0xa]      ; UNKNOWN
066AEE  8B F2                 MOV    si, dx                       ; UNKNOWN
066AF0  F7 66 0A              MUL    word ptr [bp + 0xa]          ; UNKNOWN
066AF3  83 C0 32              ADD    ax, 0x32                     ; UNKNOWN
066AF6  2B D2                 SUB    dx, dx                       ; UNKNOWN
066AF8  F7 F1                 DIV    cx                           ; UNKNOWN
066AFA  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax   ; UNKNOWN
066AFE  D1 EE                 SHR    si, 1                        ; UNKNOWN
066B00  2B 76 FC              SUB    si, word ptr [bp - 4]        ; UNKNOWN
066B03  F7 DE                 NEG    si                           ; UNKNOWN
066B05  26 89 77 04           MOV    word ptr es:[bx + 4], si     ; UNKNOWN
066B09  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
066B0C  F7 D8                 NEG    ax                           ; UNKNOWN
066B0E  40                    INC    ax                           ; UNKNOWN
066B0F  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
066B13  B9 F7 62              MOV    cx, 0x62f7                   ; UNKNOWN
066B16  8E D9                 MOV    ds, cx                       ; UNKNOWN
066B18  5E                    POP    si                           ; UNKNOWN
066B19  5F                    POP    di                           ; UNKNOWN
066B1A  C9                    LEAVE                               ; UNKNOWN
066B1B  CA 0A 00              RETF   0xa                          ; UNKNOWN
