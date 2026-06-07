; ============================================================================
; func_012189_unknown
; Region   : load_image
; Bytes    : file 0x012189..0x0121D7  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012189  C8 38 00 00           ENTER  0x38, 0                      ; UNKNOWN
01218D  A1 3A 82              MOV    ax, word ptr [0x823a]        ; UNKNOWN
012190  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
012193  A1 36 82              MOV    ax, word ptr [0x8236]        ; UNKNOWN
012196  89 46 CC              MOV    word ptr [bp - 0x34], ax     ; UNKNOWN
012199  2B C0                 SUB    ax, ax                       ; UNKNOWN
01219B  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
01219E  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
0121A1  89 46 D0              MOV    word ptr [bp - 0x30], ax     ; UNKNOWN
0121A4  EB 29                 JMP    0x121cf                      ; UNKNOWN
0121A6  FF 76 D0              PUSH   word ptr [bp - 0x30]         ; UNKNOWN
0121A9  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
0121AE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0121B1  8B 46 D6              MOV    ax, word ptr [bp - 0x2a]     ; UNKNOWN
0121B4  39 06 3A 82           CMP    word ptr [0x823a], ax        ; UNKNOWN
0121B8  75 12                 JNE    0x121cc                      ; UNKNOWN
0121BA  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
0121BE  8A 47 05              MOV    al, byte ptr [bx + 5]        ; UNKNOWN
0121C1  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0121C4  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
0121C7  75 03                 JNE    0x121cc                      ; UNKNOWN
0121C9  FF 46 D4              INC    word ptr [bp - 0x2c]         ; UNKNOWN
0121CC  FF 46 D0              INC    word ptr [bp - 0x30]         ; UNKNOWN
0121CF  A1 12 3E              MOV    ax, word ptr [0x3e12]        ; UNKNOWN
0121D2  39 46 D0              CMP    word ptr [bp - 0x30], ax     ; UNKNOWN
0121D5  7C CF                 JL     0x121a6                      ; UNKNOWN
