; ============================================================================
; func_067871_unknown
; Region   : load_image
; Bytes    : file 0x067871..0x067910  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067871  C8 2A 00 00           ENTER  0x2a, 0                      ; UNKNOWN
067875  52                    PUSH   dx                           ; UNKNOWN
067876  50                    PUSH   ax                           ; UNKNOWN
067877  53                    PUSH   bx                           ; UNKNOWN
067878  57                    PUSH   di                           ; UNKNOWN
067879  56                    PUSH   si                           ; UNKNOWN
06787A  68 44 11              PUSH   0x1144                       ; UNKNOWN
06787D  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
067880  50                    PUSH   ax                           ; UNKNOWN
067881  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
067886  83 C4 04              ADD    sp, 4                        ; UNKNOWN
067889  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
06788C  16                    PUSH   ss                           ; UNKNOWN
06788D  50                    PUSH   ax                           ; UNKNOWN
06788E  8B 46 D2              MOV    ax, word ptr [bp - 0x2e]     ; UNKNOWN
067891  BA 01 00              MOV    dx, 1                        ; UNKNOWN
067894  9A 06 00 E9 5A        LCALL  0x5ae9, 6                    ; UNKNOWN
067899  68 DB 30              PUSH   0x30db                       ; UNKNOWN
06789C  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
06789F  50                    PUSH   ax                           ; UNKNOWN
0678A0  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
0678A5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0678A8  8B F8                 MOV    di, ax                       ; UNKNOWN
0678AA  0B FF                 OR     di, di                       ; UNKNOWN
0678AC  74 35                 JE     0x678e3                      ; UNKNOWN
0678AE  2B F6                 SUB    si, si                       ; UNKNOWN
0678B0  39 76 06              CMP    word ptr [bp + 6], si        ; UNKNOWN
0678B3  7E 2E                 JLE    0x678e3                      ; UNKNOWN
0678B5  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
0678B8  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
0678BB  03 D6                 ADD    dx, si                       ; UNKNOWN
0678BD  8B 5E D0              MOV    bx, word ptr [bp - 0x30]     ; UNKNOWN
0678C0  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
0678C3  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
0678C8  52                    PUSH   dx                           ; UNKNOWN
0678C9  50                    PUSH   ax                           ; UNKNOWN
0678CA  6A 00                 PUSH   0                            ; UNKNOWN
0678CC  6A 01                 PUSH   1                            ; UNKNOWN
0678CE  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0678D1  99                    CDQ                                 ; UNKNOWN
0678D2  8B DF                 MOV    bx, di                       ; UNKNOWN
0678D4  9A 04 00 03 5B        LCALL  0x5b03, 4                    ; UNKNOWN
0678D9  0B D0                 OR     dx, ax                       ; UNKNOWN
0678DB  74 06                 JE     0x678e3                      ; UNKNOWN
0678DD  46                    INC    si                           ; UNKNOWN
0678DE  39 76 06              CMP    word ptr [bp + 6], si        ; UNKNOWN
0678E1  7F D5                 JG     0x678b8                      ; UNKNOWN
0678E3  0B FF                 OR     di, di                       ; UNKNOWN
0678E5  74 23                 JE     0x6790a                      ; UNKNOWN
0678E7  57                    PUSH   di                           ; UNKNOWN
0678E8  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
0678ED  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0678F0  83 7E D4 00           CMP    word ptr [bp - 0x2c], 0      ; UNKNOWN
0678F4  75 14                 JNE    0x6790a                      ; UNKNOWN
0678F6  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
0678F9  C6 87 4D 11 00        MOV    byte ptr [bx + 0x114d], 0    ; UNKNOWN
0678FE  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
067901  50                    PUSH   ax                           ; UNKNOWN
067902  9A 22 11 65 5F        LCALL  0x5f65, 0x1122               ; UNKNOWN
067907  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06790A  5E                    POP    si                           ; UNKNOWN
06790B  5F                    POP    di                           ; UNKNOWN
06790C  C9                    LEAVE                               ; UNKNOWN
06790D  CA 08 00              RETF   8                            ; UNKNOWN
