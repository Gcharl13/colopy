; ============================================================================
; func_03C3E6_unknown
; Region   : load_image
; Bytes    : file 0x03C3E6..0x03C4EF  (265 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C3E6  C8 1E 00 00           ENTER  0x1e, 0                      ; UNKNOWN
03C3EA  C7 46 E6 00 00        MOV    word ptr [bp - 0x1a], 0      ; UNKNOWN
03C3EF  A1 CC 79              MOV    ax, word ptr [0x79cc]        ; UNKNOWN
03C3F2  39 06 CE 79           CMP    word ptr [0x79ce], ax        ; UNKNOWN
03C3F6  74 03                 JE     0x3c3fb                      ; UNKNOWN
03C3F8  E9 67 02              JMP    0x3c662                      ; UNKNOWN
03C3FB  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
03C400  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03C403  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
03C406  83 3E E6 0E 00        CMP    word ptr [0xee6], 0          ; UNKNOWN
03C40B  74 10                 JE     0x3c41d                      ; UNKNOWN
03C40D  C6 06 FC 0A 00        MOV    byte ptr [0xafc], 0          ; UNKNOWN
03C412  A3 C6 79              MOV    word ptr [0x79c6], ax        ; UNKNOWN
03C415  89 16 C8 79           MOV    word ptr [0x79c8], dx        ; UNKNOWN
03C419  0E                    PUSH   cs                           ; UNKNOWN
03C41A  E8 BF FF              CALL   0x3c3dc                      ; UNKNOWN
03C41D  83 3E F0 0E 00        CMP    word ptr [0xef0], 0          ; UNKNOWN
03C422  75 03                 JNE    0x3c427                      ; UNKNOWN
03C424  E9 37 02              JMP    0x3c65e                      ; UNKNOWN
03C427  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03C42C  75 12                 JNE    0x3c440                      ; UNKNOWN
03C42E  83 3E DE 0E 00        CMP    word ptr [0xede], 0          ; UNKNOWN
03C433  74 0B                 JE     0x3c440                      ; UNKNOWN
03C435  80 3E FC 0A 00        CMP    byte ptr [0xafc], 0          ; UNKNOWN
03C43A  75 04                 JNE    0x3c440                      ; UNKNOWN
03C43C  0E                    PUSH   cs                           ; UNKNOWN
03C43D  E8 BF D4              CALL   0x398ff                      ; UNKNOWN
03C440  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03C445  75 27                 JNE    0x3c46e                      ; UNKNOWN
03C447  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
03C44A  8B 56 FC              MOV    dx, word ptr [bp - 4]        ; UNKNOWN
03C44D  2B 06 C6 79           SUB    ax, word ptr [0x79c6]        ; UNKNOWN
03C451  1B 16 C8 79           SBB    dx, word ptr [0x79c8]        ; UNKNOWN
03C455  0B D2                 OR     dx, dx                       ; UNKNOWN
03C457  7C 15                 JL     0x3c46e                      ; UNKNOWN
03C459  7F 05                 JG     0x3c460                      ; UNKNOWN
03C45B  83 F8 14              CMP    ax, 0x14                     ; UNKNOWN
03C45E  76 0E                 JBE    0x3c46e                      ; UNKNOWN
03C460  C6 06 FC 0A 01        MOV    byte ptr [0xafc], 1          ; UNKNOWN
03C465  6A 02                 PUSH   2                            ; UNKNOWN
03C467  0E                    PUSH   cs                           ; UNKNOWN
03C468  E8 5C FF              CALL   0x3c3c7                      ; UNKNOWN
03C46B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03C46E  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
03C471  83 E8 08              SUB    ax, 8                        ; UNKNOWN
03C474  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03C477  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
03C47A  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
03C47E  BB 10 00              MOV    bx, 0x10                     ; UNKNOWN
03C481  D3 FB                 SAR    bx, cl                       ; UNKNOWN
03C483  99                    CDQ                                 ; UNKNOWN
03C484  F7 FB                 IDIV   bx                           ; UNKNOWN
03C486  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
03C489  8B 46 EC              MOV    ax, word ptr [bp - 0x14]     ; UNKNOWN
03C48C  99                    CDQ                                 ; UNKNOWN
03C48D  F7 FB                 IDIV   bx                           ; UNKNOWN
03C48F  8B 4E F4              MOV    cx, word ptr [bp - 0xc]      ; UNKNOWN
03C492  2B 0E 82 82           SUB    cx, word ptr [0x8282]        ; UNKNOWN
03C496  03 0E 80 82           ADD    cx, word ptr [0x8280]        ; UNKNOWN
03C49A  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
03C49D  2B 06 84 82           SUB    ax, word ptr [0x8284]        ; UNKNOWN
03C4A1  03 06 86 82           ADD    ax, word ptr [0x8286]        ; UNKNOWN
03C4A5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03C4A8  83 3E 08 3E 01        CMP    word ptr [0x3e08], 1         ; UNKNOWN
03C4AD  75 37                 JNE    0x3c4e6                      ; UNKNOWN
03C4AF  3B 0E 8E 82           CMP    cx, word ptr [0x828e]        ; UNKNOWN
03C4B3  75 06                 JNE    0x3c4bb                      ; UNKNOWN
03C4B5  3B 06 8C 82           CMP    ax, word ptr [0x828c]        ; UNKNOWN
03C4B9  74 2B                 JE     0x3c4e6                      ; UNKNOWN
03C4BB  83 3E 56 C1 00        CMP    word ptr [0xc156], 0         ; UNKNOWN
03C4C0  74 05                 JE     0x3c4c7                      ; UNKNOWN
03C4C2  9A 08 01 0B 38        LCALL  0x380b, 0x108                ; UNKNOWN
03C4C7  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03C4CA  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
03C4CD  9A E6 00 0B 38        LCALL  0x380b, 0xe6                 ; UNKNOWN
03C4D2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03C4D5  9A 08 01 0B 38        LCALL  0x380b, 0x108                ; UNKNOWN
03C4DA  6A 00                 PUSH   0                            ; UNKNOWN
03C4DC  6A 01                 PUSH   1                            ; UNKNOWN
03C4DE  9A 44 04 10 0C        LCALL  0xc10, 0x444                 ; UNKNOWN
03C4E3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03C4E6  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
03C4EB  75 03                 JNE    0x3c4f0                      ; UNKNOWN
03C4ED  E9                    DB     0xE9                         ; UNKNOWN (raw)
03C4EE  C3                    DB     0xC3                         ; UNKNOWN (raw)
