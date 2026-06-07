; ============================================================================
; func_067796_unknown
; Region   : load_image
; Bytes    : file 0x067796..0x067871  (219 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067796  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
06779A  52                    PUSH   dx                           ; UNKNOWN
06779B  50                    PUSH   ax                           ; UNKNOWN
06779C  53                    PUSH   bx                           ; UNKNOWN
06779D  57                    PUSH   di                           ; UNKNOWN
06779E  56                    PUSH   si                           ; UNKNOWN
06779F  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
0677A4  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0677A9  2B F6                 SUB    si, si                       ; UNKNOWN
0677AB  8B FE                 MOV    di, si                       ; UNKNOWN
0677AD  A0 4C 11              MOV    al, byte ptr [0x114c]        ; UNKNOWN
0677B0  2A E4                 SUB    ah, ah                       ; UNKNOWN
0677B2  40                    INC    ax                           ; UNKNOWN
0677B3  B9 0A 00              MOV    cx, 0xa                      ; UNKNOWN
0677B6  99                    CDQ                                 ; UNKNOWN
0677B7  F7 F9                 IDIV   cx                           ; UNKNOWN
0677B9  88 16 4C 11           MOV    byte ptr [0x114c], dl        ; UNKNOWN
0677BD  68 44 11              PUSH   0x1144                       ; UNKNOWN
0677C0  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
0677C3  50                    PUSH   ax                           ; UNKNOWN
0677C4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0677C9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0677CC  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
0677CF  16                    PUSH   ss                           ; UNKNOWN
0677D0  50                    PUSH   ax                           ; UNKNOWN
0677D1  A0 4C 11              MOV    al, byte ptr [0x114c]        ; UNKNOWN
0677D4  2A E4                 SUB    ah, ah                       ; UNKNOWN
0677D6  BA 01 00              MOV    dx, 1                        ; UNKNOWN
0677D9  9A 06 00 E9 5A        LCALL  0x5ae9, 6                    ; UNKNOWN
0677DE  8A 1E 4C 11           MOV    bl, byte ptr [0x114c]        ; UNKNOWN
0677E2  2A FF                 SUB    bh, bh                       ; UNKNOWN
0677E4  38 BF 4D 11           CMP    byte ptr [bx + 0x114d], bh   ; UNKNOWN
0677E8  75 05                 JNE    0x677ef                      ; UNKNOWN
0677EA  BE FF FF              MOV    si, 0xffff                   ; UNKNOWN
0677ED  EB 0B                 JMP    0x677fa                      ; UNKNOWN
0677EF  47                    INC    di                           ; UNKNOWN
0677F0  83 FF 0A              CMP    di, 0xa                      ; UNKNOWN
0677F3  7E 05                 JLE    0x677fa                      ; UNKNOWN
0677F5  8B 7E FE              MOV    di, word ptr [bp - 2]        ; UNKNOWN
0677F8  EB 61                 JMP    0x6785b                      ; UNKNOWN
0677FA  0B F6                 OR     si, si                       ; UNKNOWN
0677FC  74 AF                 JE     0x677ad                      ; UNKNOWN
0677FE  8A 1E 4C 11           MOV    bl, byte ptr [0x114c]        ; UNKNOWN
067802  2A FF                 SUB    bh, bh                       ; UNKNOWN
067804  C6 87 4D 11 FF        MOV    byte ptr [bx + 0x114d], 0xff ; UNKNOWN
067809  68 D8 30              PUSH   0x30d8                       ; UNKNOWN
06780C  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
06780F  50                    PUSH   ax                           ; UNKNOWN
067810  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
067815  83 C4 04              ADD    sp, 4                        ; UNKNOWN
067818  8B F8                 MOV    di, ax                       ; UNKNOWN
06781A  0B FF                 OR     di, di                       ; UNKNOWN
06781C  74 3D                 JE     0x6785b                      ; UNKNOWN
06781E  2B F6                 SUB    si, si                       ; UNKNOWN
067820  39 76 06              CMP    word ptr [bp + 6], si        ; UNKNOWN
067823  7E 2E                 JLE    0x67853                      ; UNKNOWN
067825  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
067828  8B 56 D2              MOV    dx, word ptr [bp - 0x2e]     ; UNKNOWN
06782B  03 D6                 ADD    dx, si                       ; UNKNOWN
06782D  8B 5E CE              MOV    bx, word ptr [bp - 0x32]     ; UNKNOWN
067830  8B 46 D0              MOV    ax, word ptr [bp - 0x30]     ; UNKNOWN
067833  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
067838  52                    PUSH   dx                           ; UNKNOWN
067839  50                    PUSH   ax                           ; UNKNOWN
06783A  6A 00                 PUSH   0                            ; UNKNOWN
06783C  6A 01                 PUSH   1                            ; UNKNOWN
06783E  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
067841  99                    CDQ                                 ; UNKNOWN
067842  8B DF                 MOV    bx, di                       ; UNKNOWN
067844  9A 08 00 23 5B        LCALL  0x5b23, 8                    ; UNKNOWN
067849  0B D0                 OR     dx, ax                       ; UNKNOWN
06784B  74 0E                 JE     0x6785b                      ; UNKNOWN
06784D  46                    INC    si                           ; UNKNOWN
06784E  39 76 06              CMP    word ptr [bp + 6], si        ; UNKNOWN
067851  7F D5                 JG     0x67828                      ; UNKNOWN
067853  A0 4C 11              MOV    al, byte ptr [0x114c]        ; UNKNOWN
067856  2A E4                 SUB    ah, ah                       ; UNKNOWN
067858  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06785B  0B FF                 OR     di, di                       ; UNKNOWN
06785D  74 09                 JE     0x67868                      ; UNKNOWN
06785F  57                    PUSH   di                           ; UNKNOWN
067860  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
067865  83 C4 02              ADD    sp, 2                        ; UNKNOWN
067868  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
06786B  5E                    POP    si                           ; UNKNOWN
06786C  5F                    POP    di                           ; UNKNOWN
06786D  C9                    LEAVE                               ; UNKNOWN
06786E  CA 04 00              RETF   4                            ; UNKNOWN
