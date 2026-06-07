; ============================================================================
; func_05E8FE_unknown
; Region   : load_image
; Bytes    : file 0x05E8FE..0x05E993  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05E8FE  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
05E902  56                    PUSH   si                           ; UNKNOWN
05E903  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
05E908  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05E90C  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
05E90E  2A E4                 SUB    ah, ah                       ; UNKNOWN
05E910  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
05E913  8A 4F 01              MOV    cl, byte ptr [bx + 1]        ; UNKNOWN
05E916  2A ED                 SUB    ch, ch                       ; UNKNOWN
05E918  89 4E E4              MOV    word ptr [bp - 0x1c], cx     ; UNKNOWN
05E91B  51                    PUSH   cx                           ; UNKNOWN
05E91C  50                    PUSH   ax                           ; UNKNOWN
05E91D  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
05E922  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05E925  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
05E928  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05E92C  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
05E92F  2A E4                 SUB    ah, ah                       ; UNKNOWN
05E931  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
05E934  8B F0                 MOV    si, ax                       ; UNKNOWN
05E936  C1 E6 04              SHL    si, 4                        ; UNKNOWN
05E939  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
05E93C  80 B8 57 87 02        CMP    byte ptr [bx + si - 0x78a9], 2 ; UNKNOWN
05E941  73 03                 JAE    0x5e946                      ; UNKNOWN
05E943  E9 C4 01              JMP    0x5eb0a                      ; UNKNOWN
05E946  8B F0                 MOV    si, ax                       ; UNKNOWN
05E948  C1 E6 04              SHL    si, 4                        ; UNKNOWN
05E94B  8A 80 57 87           MOV    al, byte ptr [bx + si - 0x78a9] ; UNKNOWN
05E94F  48                    DEC    ax                           ; UNKNOWN
05E950  48                    DEC    ax                           ; UNKNOWN
05E951  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05E954  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; UNKNOWN
05E959  EB 27                 JMP    0x5e982                      ; UNKNOWN
05E95B  8B 46 F0              MOV    ax, word ptr [bp - 0x10]     ; UNKNOWN
05E95E  2B 46 EA              SUB    ax, word ptr [bp - 0x16]     ; UNKNOWN
05E961  F7 D0                 NOT    ax                           ; UNKNOWN
05E963  40                    INC    ax                           ; UNKNOWN
05E964  83 F8 07              CMP    ax, 7                        ; UNKNOWN
05E967  7C 5A                 JL     0x5e9c3                      ; UNKNOWN
05E969  8B C1                 MOV    ax, cx                       ; UNKNOWN
05E96B  2B 46 E4              SUB    ax, word ptr [bp - 0x1c]     ; UNKNOWN
05E96E  0B C0                 OR     ax, ax                       ; UNKNOWN
05E970  7F 08                 JG     0x5e97a                      ; UNKNOWN
05E972  8B C1                 MOV    ax, cx                       ; UNKNOWN
05E974  2B 46 E4              SUB    ax, word ptr [bp - 0x1c]     ; UNKNOWN
05E977  F7 D0                 NOT    ax                           ; UNKNOWN
05E979  40                    INC    ax                           ; UNKNOWN
05E97A  83 F8 07              CMP    ax, 7                        ; UNKNOWN
05E97D  7C 44                 JL     0x5e9c3                      ; UNKNOWN
05E97F  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
05E982  8B 46 E0              MOV    ax, word ptr [bp - 0x20]     ; UNKNOWN
05E985  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
05E989  7F 03                 JG     0x5e98e                      ; UNKNOWN
05E98B  E9 7C 01              JMP    0x5eb0a                      ; UNKNOWN
05E98E  69 D8 CA 00           IMUL   bx, ax, 0xca                 ; UNKNOWN
05E992  8A                    DB     0x8A                         ; UNKNOWN (raw)
