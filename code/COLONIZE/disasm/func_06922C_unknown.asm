; ============================================================================
; func_06922C_unknown
; Region   : load_image
; Bytes    : file 0x06922C..0x0692B2  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06922C  55                    PUSH   bp                           ; UNKNOWN
06922D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06922F  83 EC 08              SUB    sp, 8                        ; UNKNOWN
069232  56                    PUSH   si                           ; UNKNOWN
069233  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
069236  0B F6                 OR     si, si                       ; UNKNOWN
069238  7C 06                 JL     0x69240                      ; UNKNOWN
06923A  39 36 45 12           CMP    word ptr [0x1245], si        ; UNKNOWN
06923E  7F 0C                 JG     0x6924c                      ; UNKNOWN
069240  C7 06 38 12 09 00     MOV    word ptr [0x1238], 9         ; UNKNOWN
069246  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
069249  99                    CDQ                                 ; UNKNOWN
06924A  EB 61                 JMP    0x692ad                      ; UNKNOWN
06924C  B8 01 00              MOV    ax, 1                        ; UNKNOWN
06924F  50                    PUSH   ax                           ; UNKNOWN
069250  2B C0                 SUB    ax, ax                       ; UNKNOWN
069252  50                    PUSH   ax                           ; UNKNOWN
069253  50                    PUSH   ax                           ; UNKNOWN
069254  56                    PUSH   si                           ; UNKNOWN
069255  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
06925A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06925D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
069260  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
069263  3D FF FF              CMP    ax, 0xffff                   ; UNKNOWN
069266  75 0C                 JNE    0x69274                      ; UNKNOWN
069268  3B D0                 CMP    dx, ax                       ; UNKNOWN
06926A  75 08                 JNE    0x69274                      ; UNKNOWN
06926C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06926F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
069272  EB 33                 JMP    0x692a7                      ; UNKNOWN
069274  B8 02 00              MOV    ax, 2                        ; UNKNOWN
069277  50                    PUSH   ax                           ; UNKNOWN
069278  2B C0                 SUB    ax, ax                       ; UNKNOWN
06927A  50                    PUSH   ax                           ; UNKNOWN
06927B  50                    PUSH   ax                           ; UNKNOWN
06927C  56                    PUSH   si                           ; UNKNOWN
06927D  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
069282  83 C4 08              ADD    sp, 8                        ; UNKNOWN
069285  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
069288  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
06928B  3B 46 F8              CMP    ax, word ptr [bp - 8]        ; UNKNOWN
06928E  75 05                 JNE    0x69295                      ; UNKNOWN
069290  3B 56 FA              CMP    dx, word ptr [bp - 6]        ; UNKNOWN
069293  74 12                 JE     0x692a7                      ; UNKNOWN
069295  2B C0                 SUB    ax, ax                       ; UNKNOWN
069297  50                    PUSH   ax                           ; UNKNOWN
069298  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
06929B  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
06929E  56                    PUSH   si                           ; UNKNOWN
06929F  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
0692A4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0692A7  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0692AA  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
0692AD  5E                    POP    si                           ; UNKNOWN
0692AE  8B E5                 MOV    sp, bp                       ; UNKNOWN
0692B0  5D                    POP    bp                           ; UNKNOWN
0692B1  CB                    RETF                                ; UNKNOWN
