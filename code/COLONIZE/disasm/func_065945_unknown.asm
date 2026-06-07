; ============================================================================
; func_065945_unknown
; Region   : load_image
; Bytes    : file 0x065945..0x0659E3  (158 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065945  55                    PUSH   bp                           ; UNKNOWN
065946  8B EC                 MOV    bp, sp                       ; UNKNOWN
065948  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
06594B  A3 F2 0E              MOV    word ptr [0xef2], ax         ; UNKNOWN
06594E  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
065951  A3 F4 0E              MOV    word ptr [0xef4], ax         ; UNKNOWN
065954  68 E4 0E              PUSH   0xee4                        ; UNKNOWN
065957  68 E2 0E              PUSH   0xee2                        ; UNKNOWN
06595A  9A 73 03 1E 5C        LCALL  0x5c1e, 0x373                ; UNKNOWN
06595F  8B E5                 MOV    sp, bp                       ; UNKNOWN
065961  A3 E0 0E              MOV    word ptr [0xee0], ax         ; UNKNOWN
065964  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
065969  A3 F6 0E              MOV    word ptr [0xef6], ax         ; UNKNOWN
06596C  89 16 F8 0E           MOV    word ptr [0xef8], dx         ; UNKNOWN
065970  8B 1E E0 0E           MOV    bx, word ptr [0xee0]         ; UNKNOWN
065974  83 3E EC 0E 00        CMP    word ptr [0xeec], 0          ; UNKNOWN
065979  74 0C                 JE     0x65987                      ; UNKNOWN
06597B  0B DB                 OR     bx, bx                       ; UNKNOWN
06597D  75 08                 JNE    0x65987                      ; UNKNOWN
06597F  C7 06 EE 0E 01 00     MOV    word ptr [0xeee], 1          ; UNKNOWN
065985  EB 06                 JMP    0x6598d                      ; UNKNOWN
065987  C7 06 EE 0E 00 00     MOV    word ptr [0xeee], 0          ; UNKNOWN
06598D  0B DB                 OR     bx, bx                       ; UNKNOWN
06598F  74 0C                 JE     0x6599d                      ; UNKNOWN
065991  83 3E E8 0E 00        CMP    word ptr [0xee8], 0          ; UNKNOWN
065996  75 05                 JNE    0x6599d                      ; UNKNOWN
065998  BA 01 00              MOV    dx, 1                        ; UNKNOWN
06599B  EB 02                 JMP    0x6599f                      ; UNKNOWN
06599D  2B D2                 SUB    dx, dx                       ; UNKNOWN
06599F  89 1E E8 0E           MOV    word ptr [0xee8], bx         ; UNKNOWN
0659A3  0B DB                 OR     bx, bx                       ; UNKNOWN
0659A5  75 04                 JNE    0x659ab                      ; UNKNOWN
0659A7  89 1E EC 0E           MOV    word ptr [0xeec], bx         ; UNKNOWN
0659AB  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
0659AE  39 06 F2 0E           CMP    word ptr [0xef2], ax         ; UNKNOWN
0659B2  75 19                 JNE    0x659cd                      ; UNKNOWN
0659B4  A1 E4 0E              MOV    ax, word ptr [0xee4]         ; UNKNOWN
0659B7  39 06 F4 0E           CMP    word ptr [0xef4], ax         ; UNKNOWN
0659BB  75 10                 JNE    0x659cd                      ; UNKNOWN
0659BD  0B D2                 OR     dx, dx                       ; UNKNOWN
0659BF  75 0C                 JNE    0x659cd                      ; UNKNOWN
0659C1  39 16 EE 0E           CMP    word ptr [0xeee], dx         ; UNKNOWN
0659C5  75 06                 JNE    0x659cd                      ; UNKNOWN
0659C7  89 16 EA 0E           MOV    word ptr [0xeea], dx         ; UNKNOWN
0659CB  EB 06                 JMP    0x659d3                      ; UNKNOWN
0659CD  C7 06 EA 0E 01 00     MOV    word ptr [0xeea], 1          ; UNKNOWN
0659D3  89 16 E6 0E           MOV    word ptr [0xee6], dx         ; UNKNOWN
0659D7  0B D2                 OR     dx, dx                       ; UNKNOWN
0659D9  74 15                 JE     0x659f0                      ; UNKNOWN
0659DB  C7 06 EC 0E 01 00     MOV    word ptr [0xeec], 1          ; UNKNOWN
0659E1  8A C3                 MOV    al, bl                       ; UNKNOWN
