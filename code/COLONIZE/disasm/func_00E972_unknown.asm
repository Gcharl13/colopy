; ============================================================================
; func_00E972_unknown
; Region   : load_image
; Bytes    : file 0x00E972..0x00E9C7  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E972  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
00E976  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
00E97B  A1 52 05              MOV    ax, word ptr [0x552]         ; UNKNOWN
00E97E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00E981  0B C0                 OR     ax, ax                       ; UNKNOWN
00E983  7E 42                 JLE    0xe9c7                       ; UNKNOWN
00E985  C7 46 FA 5E 05        MOV    word ptr [bp - 6], 0x55e     ; UNKNOWN
00E98A  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E98D  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
00E98F  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00E992  40                    INC    ax                           ; UNKNOWN
00E993  74 23                 JE     0xe9b8                       ; UNKNOWN
00E995  83 7F 02 FF           CMP    word ptr [bx + 2], -1        ; UNKNOWN
00E999  74 1D                 JE     0xe9b8                       ; UNKNOWN
00E99B  6A FF                 PUSH   -1                           ; UNKNOWN
00E99D  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
00E9A0  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
00E9A3  0E                    PUSH   cs                           ; UNKNOWN
00E9A4  E8 37 FE              CALL   0xe7de                       ; UNKNOWN
00E9A7  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00E9AA  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
00E9AD  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E9B0  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
00E9B2  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E9B5  89 47 02              MOV    word ptr [bx + 2], ax        ; UNKNOWN
00E9B8  83 46 FA 04           ADD    word ptr [bp - 6], 4         ; UNKNOWN
00E9BC  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
00E9BF  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
00E9C2  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
00E9C5  7C C3                 JL     0xe98a                       ; UNKNOWN
