; ============================================================================
; func_063CE5_unknown
; Region   : load_image
; Bytes    : file 0x063CE5..0x063DB2  (205 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063CE5  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
063CE9  57                    PUSH   di                           ; UNKNOWN
063CEA  56                    PUSH   si                           ; UNKNOWN
063CEB  83 3E 14 0C 00        CMP    word ptr [0xc14], 0          ; UNKNOWN
063CF0  75 03                 JNE    0x63cf5                      ; UNKNOWN
063CF2  E9 18 01              JMP    0x63e0d                      ; UNKNOWN
063CF5  A1 22 CE              MOV    ax, word ptr [0xce22]        ; UNKNOWN
063CF8  FF 06 16 0C           INC    word ptr [0xc16]             ; UNKNOWN
063CFC  39 06 16 0C           CMP    word ptr [0xc16], ax         ; UNKNOWN
063D00  7D 03                 JGE    0x63d05                      ; UNKNOWN
063D02  E9 08 01              JMP    0x63e0d                      ; UNKNOWN
063D05  83 3E 7C 0C 00        CMP    word ptr [0xc7c], 0          ; UNKNOWN
063D0A  74 03                 JE     0x63d0f                      ; UNKNOWN
063D0C  E9 FE 00              JMP    0x63e0d                      ; UNKNOWN
063D0F  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
063D14  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
063D17  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
063D1A  2B C0                 SUB    ax, ax                       ; UNKNOWN
063D1C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
063D1F  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
063D22  E9 BA 00              JMP    0x63ddf                      ; UNKNOWN
063D25  8B D8                 MOV    bx, ax                       ; UNKNOWN
063D27  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
063D2A  8A 87 05 CE           MOV    al, byte ptr [bx - 0x31fb]   ; UNKNOWN
063D2E  2A E4                 SUB    ah, ah                       ; UNKNOWN
063D30  2B D2                 SUB    dx, dx                       ; UNKNOWN
063D32  03 87 26 CE           ADD    ax, word ptr [bx - 0x31da]   ; UNKNOWN
063D36  13 97 28 CE           ADC    dx, word ptr [bx - 0x31d8]   ; UNKNOWN
063D3A  3B 56 F4              CMP    dx, word ptr [bp - 0xc]      ; UNKNOWN
063D3D  7E 03                 JLE    0x63d42                      ; UNKNOWN
063D3F  E9 9A 00              JMP    0x63ddc                      ; UNKNOWN
063D42  7C 08                 JL     0x63d4c                      ; UNKNOWN
063D44  3B 46 F2              CMP    ax, word ptr [bp - 0xe]      ; UNKNOWN
063D47  76 03                 JBE    0x63d4c                      ; UNKNOWN
063D49  E9 90 00              JMP    0x63ddc                      ; UNKNOWN
063D4C  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
063D4F  8B 56 F4              MOV    dx, word ptr [bp - 0xc]      ; UNKNOWN
063D52  89 87 26 CE           MOV    word ptr [bx - 0x31da], ax   ; UNKNOWN
063D56  89 97 28 CE           MOV    word ptr [bx - 0x31d8], dx   ; UNKNOWN
063D5A  8A 87 02 CE           MOV    al, byte ptr [bx - 0x31fe]   ; UNKNOWN
063D5E  2A E4                 SUB    ah, ah                       ; UNKNOWN
063D60  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
063D63  8A 8F 04 CE           MOV    cl, byte ptr [bx - 0x31fc]   ; UNKNOWN
063D67  2A ED                 SUB    ch, ch                       ; UNKNOWN
063D69  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
063D6C  8A 8F 03 CE           MOV    cl, byte ptr [bx - 0x31fd]   ; UNKNOWN
063D70  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
063D73  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
063D78  83 F8 01              CMP    ax, 1                        ; UNKNOWN
063D7B  7E 52                 JLE    0x63dcf                      ; UNKNOWN
063D7D  FD                    STD                                 ; UNKNOWN
063D7E  1E                    PUSH   ds                           ; UNKNOWN
063D7F  1E                    PUSH   ds                           ; UNKNOWN
063D80  07                    POP    es                           ; UNKNOWN
063D81  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
063D84  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
063D87  D1 E0                 SHL    ax, 1                        ; UNKNOWN
063D89  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
063D8C  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
063D8F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
063D92  D1 E3                 SHL    bx, 1                        ; UNKNOWN
063D94  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
063D97  BF FC CD              MOV    di, 0xcdfc                   ; UNKNOWN
063D9A  83 C7 02              ADD    di, 2                        ; UNKNOWN
063D9D  C5 36 10 0C           LDS    si, ptr [0xc10]              ; UNKNOWN
063DA1  03 F0                 ADD    si, ax                       ; UNKNOWN
063DA3  83 EE 01              SUB    si, 1                        ; UNKNOWN
063DA6  57                    PUSH   di                           ; UNKNOWN
063DA7  56                    PUSH   si                           ; UNKNOWN
063DA8  B9 03 00              MOV    cx, 3                        ; UNKNOWN
063DAB  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
063DAD  5F                    POP    di                           ; UNKNOWN
063DAE  1E                    PUSH   ds                           ; UNKNOWN
063DAF  07                    POP    es                           ; UNKNOWN
063DB0  8B CB                 MOV    cx, bx                       ; UNKNOWN
