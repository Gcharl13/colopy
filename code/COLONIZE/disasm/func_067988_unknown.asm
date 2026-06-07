; ============================================================================
; func_067988_unknown
; Region   : load_image
; Bytes    : file 0x067988..0x067A08  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067988  C8 A4 00 00           ENTER  0xa4, 0                      ; UNKNOWN
06798C  8C D8                 MOV    ax, ds                       ; UNKNOWN
06798E  8E C0                 MOV    es, ax                       ; UNKNOWN
067990  56                    PUSH   si                           ; UNKNOWN
067991  57                    PUSH   di                           ; UNKNOWN
067992  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
067995  8D 7E AD              LEA    di, [bp - 0x53]              ; UNKNOWN
067998  B9 4F 00              MOV    cx, 0x4f                     ; UNKNOWN
06799B  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06799C  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
06799D  0A C0                 OR     al, al                       ; UNKNOWN
06799F  E0 FA                 LOOPNE 0x6799b                      ; UNKNOWN
0679A1  5F                    POP    di                           ; UNKNOWN
0679A2  5E                    POP    si                           ; UNKNOWN
0679A3  8D 5E AD              LEA    bx, [bp - 0x53]              ; UNKNOWN
0679A6  8D 8E 5C FF           LEA    cx, [bp - 0xa4]              ; UNKNOWN
0679AA  1E                    PUSH   ds                           ; UNKNOWN
0679AB  53                    PUSH   bx                           ; UNKNOWN
0679AC  1E                    PUSH   ds                           ; UNKNOWN
0679AD  51                    PUSH   cx                           ; UNKNOWN
0679AE  9A B3 00 E9 5A        LCALL  0x5ae9, 0xb3                 ; UNKNOWN
0679B3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0679B6  B8 24 35              MOV    ax, 0x3524                   ; UNKNOWN
0679B9  CD 21                 INT    0x21                         ; UNKNOWN
0679BB  8C C0                 MOV    ax, es                       ; UNKNOWN
0679BD  2E 89 1E 0E 00        MOV    word ptr cs:[0xe], bx        ; UNKNOWN
0679C2  2E A3 10 00           MOV    word ptr cs:[0x10], ax       ; UNKNOWN
0679C6  1E                    PUSH   ds                           ; UNKNOWN
0679C7  0E                    PUSH   cs                           ; UNKNOWN
0679C8  1F                    POP    ds                           ; UNKNOWN
0679C9  BA 12 00              MOV    dx, 0x12                     ; UNKNOWN
0679CC  B8 24 25              MOV    ax, 0x2524                   ; UNKNOWN
0679CF  CD 21                 INT    0x21                         ; UNKNOWN
0679D1  1F                    POP    ds                           ; UNKNOWN
0679D2  8D 9E 5C FF           LEA    bx, [bp - 0xa4]              ; UNKNOWN
0679D6  8B D3                 MOV    dx, bx                       ; UNKNOWN
0679D8  B8 00 3D              MOV    ax, 0x3d00                   ; UNKNOWN
0679DB  CD 21                 INT    0x21                         ; UNKNOWN
0679DD  72 0D                 JB     0x679ec                      ; UNKNOWN
0679DF  8B D8                 MOV    bx, ax                       ; UNKNOWN
0679E1  B4 3E                 MOV    ah, 0x3e                     ; UNKNOWN
0679E3  CD 21                 INT    0x21                         ; UNKNOWN
0679E5  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
0679EA  EB 05                 JMP    0x679f1                      ; UNKNOWN
0679EC  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0679F1  1E                    PUSH   ds                           ; UNKNOWN
0679F2  2E 8B 16 0E 00        MOV    dx, word ptr cs:[0xe]        ; UNKNOWN
0679F7  2E A1 10 00           MOV    ax, word ptr cs:[0x10]       ; UNKNOWN
0679FB  8E D8                 MOV    ds, ax                       ; UNKNOWN
0679FD  B8 24 25              MOV    ax, 0x2524                   ; UNKNOWN
067A00  CD 21                 INT    0x21                         ; UNKNOWN
067A02  1F                    POP    ds                           ; UNKNOWN
067A03  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
067A06  C9                    LEAVE                               ; UNKNOWN
067A07  CB                    RETF                                ; UNKNOWN
