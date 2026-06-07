; ============================================================================
; func_063588_unknown
; Region   : load_image
; Bytes    : file 0x063588..0x06360B  (131 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063588  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
06358C  53                    PUSH   bx                           ; UNKNOWN
06358D  52                    PUSH   dx                           ; UNKNOWN
06358E  50                    PUSH   ax                           ; UNKNOWN
06358F  57                    PUSH   di                           ; UNKNOWN
063590  56                    PUSH   si                           ; UNKNOWN
063591  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
063594  50                    PUSH   ax                           ; UNKNOWN
063595  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
063598  50                    PUSH   ax                           ; UNKNOWN
063599  8D 5E 0A              LEA    bx, [bp + 0xa]               ; UNKNOWN
06359C  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
06359F  8D 56 F4              LEA    dx, [bp - 0xc]               ; UNKNOWN
0635A2  9A 14 00 97 5A        LCALL  0x5a97, 0x14                 ; UNKNOWN
0635A7  0B C0                 OR     ax, ax                       ; UNKNOWN
0635A9  74 03                 JE     0x635ae                      ; UNKNOWN
0635AB  E9 8C 00              JMP    0x6363a                      ; UNKNOWN
0635AE  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
0635B1  2B 46 F6              SUB    ax, word ptr [bp - 0xa]      ; UNKNOWN
0635B4  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0635B7  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
0635BA  0B 46 0E              OR     ax, word ptr [bp + 0xe]      ; UNKNOWN
0635BD  74 05                 JE     0x635c4                      ; UNKNOWN
0635BF  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0635C2  EB 02                 JMP    0x635c6                      ; UNKNOWN
0635C4  2B C0                 SUB    ax, ax                       ; UNKNOWN
0635C6  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0635C9  0B C0                 OR     ax, ax                       ; UNKNOWN
0635CB  74 6D                 JE     0x6363a                      ; UNKNOWN
0635CD  8D 5E 0A              LEA    bx, [bp + 0xa]               ; UNKNOWN
0635D0  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
0635D3  8B 56 F4              MOV    dx, word ptr [bp - 0xc]      ; UNKNOWN
0635D6  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
0635DB  52                    PUSH   dx                           ; UNKNOWN
0635DC  50                    PUSH   ax                           ; UNKNOWN
0635DD  9A 06 00 4E 00        LCALL  0x4e, 6                      ; UNKNOWN
0635E2  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0635E5  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0635E8  C4 7E FA              LES    di, ptr [bp - 6]             ; UNKNOWN
0635EB  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
0635EE  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
0635F1  0B F6                 OR     si, si                       ; UNKNOWN
0635F3  75 02                 JNE    0x635f7                      ; UNKNOWN
0635F5  EB 43                 JMP    0x6363a                      ; UNKNOWN
0635F7  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
0635FA  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
0635FD  8A E0                 MOV    ah, al                       ; UNKNOWN
0635FF  D1 EA                 SHR    dx, 1                        ; UNKNOWN
063601  73 1E                 JAE    0x63621                      ; UNKNOWN
063603  0B D2                 OR     dx, dx                       ; UNKNOWN
063605  74 04                 JE     0x6360b                      ; UNKNOWN
063607  8B CA                 MOV    cx, dx                       ; UNKNOWN
063609  F3 AB                 REP STOSW word ptr es:[di], ax         ; UNKNOWN
