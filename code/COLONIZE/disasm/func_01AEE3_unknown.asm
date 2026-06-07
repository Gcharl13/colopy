; ============================================================================
; func_01AEE3_unknown
; Region   : load_image
; Bytes    : file 0x01AEE3..0x01AFA6  (195 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01AEE3  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
01AEE7  56                    PUSH   si                           ; UNKNOWN
01AEE8  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01AEEC  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01AEEF  98                    CWDE                                ; UNKNOWN
01AEF0  03 06 3A 73           ADD    ax, word ptr [0x733a]        ; UNKNOWN
01AEF4  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01AEF7  48                    DEC    ax                           ; UNKNOWN
01AEF8  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01AEFB  C7 46 FA 02 00        MOV    word ptr [bp - 6], 2         ; UNKNOWN
01AF00  2B C0                 SUB    ax, ax                       ; UNKNOWN
01AF02  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01AF05  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01AF08  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01AF0B  EB 40                 JMP    0x1af4d                      ; UNKNOWN
01AF0D  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
01AF11  7E 0C                 JLE    0x1af1f                      ; UNKNOWN
01AF13  FF 4E F4              DEC    word ptr [bp - 0xc]          ; UNKNOWN
01AF16  FF 4E FC              DEC    word ptr [bp - 4]            ; UNKNOWN
01AF19  83 7E F4 01           CMP    word ptr [bp - 0xc], 1       ; UNKNOWN
01AF1D  7F EE                 JG     0x1af0d                      ; UNKNOWN
01AF1F  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
01AF22  01 46 FA              ADD    word ptr [bp - 6], ax        ; UNKNOWN
01AF25  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01AF29  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
01AF2C  98                    CWDE                                ; UNKNOWN
01AF2D  2B 46 F2              SUB    ax, word ptr [bp - 0xe]      ; UNKNOWN
01AF30  48                    DEC    ax                           ; UNKNOWN
01AF31  75 04                 JNE    0x1af37                      ; UNKNOWN
01AF33  83 46 FA 04           ADD    word ptr [bp - 6], 4         ; UNKNOWN
01AF37  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
01AF3A  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
01AF3D  7E 0B                 JLE    0x1af4a                      ; UNKNOWN
01AF3F  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
01AF42  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01AF45  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1      ; UNKNOWN
01AF4A  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
01AF4D  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
01AF51  75 4D                 JNE    0x1afa0                      ; UNKNOWN
01AF53  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
01AF56  39 46 F2              CMP    word ptr [bp - 0xe], ax      ; UNKNOWN
01AF59  7D 45                 JGE    0x1afa0                      ; UNKNOWN
01AF5B  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
01AF5E  9A F5 0E 5F 24        LCALL  0x245f, 0xef5                ; UNKNOWN
01AF63  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01AF66  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01AF69  A0 EF 32              MOV    al, byte ptr [0x32ef]        ; UNKNOWN
01AF6C  98                    CWDE                                ; UNKNOWN
01AF6D  8B 76 F8              MOV    si, word ptr [bp - 8]        ; UNKNOWN
01AF70  8B CE                 MOV    cx, si                       ; UNKNOWN
01AF72  D1 E6                 SHL    si, 1                        ; UNKNOWN
01AF74  03 F1                 ADD    si, cx                       ; UNKNOWN
01AF76  C1 E6 02              SHL    si, 2                        ; UNKNOWN
01AF79  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
01AF7D  26 03 40 3E           ADD    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
01AF81  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01AF84  83 F8 01              CMP    ax, 1                        ; UNKNOWN
01AF87  7D 06                 JGE    0x1af8f                      ; UNKNOWN
01AF89  48                    DEC    ax                           ; UNKNOWN
01AF8A  F7 D8                 NEG    ax                           ; UNKNOWN
01AF8C  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
01AF8F  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
01AF92  83 F8 01              CMP    ax, 1                        ; UNKNOWN
01AF95  7D 03                 JGE    0x1af9a                      ; UNKNOWN
01AF97  B8 01 00              MOV    ax, 1                        ; UNKNOWN
01AF9A  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
01AF9D  E9 79 FF              JMP    0x1af19                      ; UNKNOWN
01AFA0  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01AFA3  5E                    POP    si                           ; UNKNOWN
01AFA4  C9                    LEAVE                               ; UNKNOWN
01AFA5  CB                    RETF                                ; UNKNOWN
