; ============================================================================
; func_025E11_unknown
; Region   : load_image
; Bytes    : file 0x025E11..0x025F0A  (249 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025E11  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
025E15  56                    PUSH   si                           ; UNKNOWN
025E16  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
025E1B  2B C0                 SUB    ax, ax                       ; UNKNOWN
025E1D  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
025E20  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
025E23  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
025E26  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
025E29  26 39 47 08           CMP    word ptr es:[bx + 8], ax     ; UNKNOWN
025E2D  74 12                 JE     0x25e41                      ; UNKNOWN
025E2F  26 39 47 02           CMP    word ptr es:[bx + 2], ax     ; UNKNOWN
025E33  74 0C                 JE     0x25e41                      ; UNKNOWN
025E35  26 89 47 08           MOV    word ptr es:[bx + 8], ax     ; UNKNOWN
025E39  26 89 47 62           MOV    word ptr es:[bx + 0x62], ax  ; UNKNOWN
025E3D  26 89 47 60           MOV    word ptr es:[bx + 0x60], ax  ; UNKNOWN
025E41  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
025E44  26 8B 47 0C           MOV    ax, word ptr es:[bx + 0xc]   ; UNKNOWN
025E48  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax  ; UNKNOWN
025E4C  26 8B 47 0E           MOV    ax, word ptr es:[bx + 0xe]   ; UNKNOWN
025E50  26 89 47 12           MOV    word ptr es:[bx + 0x12], ax  ; UNKNOWN
025E54  26 C7 47 14 00 00     MOV    word ptr es:[bx + 0x14], 0   ; UNKNOWN
025E5A  26 8B 47 4A           MOV    ax, word ptr es:[bx + 0x4a]  ; UNKNOWN
025E5E  D1 E0                 SHL    ax, 1                        ; UNKNOWN
025E60  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46]  ; UNKNOWN
025E64  26 89 47 16           MOV    word ptr es:[bx + 0x16], ax  ; UNKNOWN
025E68  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa]   ; UNKNOWN
025E6C  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
025E6F  83 F8 01              CMP    ax, 1                        ; UNKNOWN
025E72  1B C0                 SBB    ax, ax                       ; UNKNOWN
025E74  83 E0 03              AND    ax, 3                        ; UNKNOWN
025E77  26 89 47 2A           MOV    word ptr es:[bx + 0x2a], ax  ; UNKNOWN
025E7B  8B C8                 MOV    cx, ax                       ; UNKNOWN
025E7D  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46]  ; UNKNOWN
025E81  26 89 47 2C           MOV    word ptr es:[bx + 0x2c], ax  ; UNKNOWN
025E85  26 89 4F 24           MOV    word ptr es:[bx + 0x24], cx  ; UNKNOWN
025E89  26 89 47 26           MOV    word ptr es:[bx + 0x26], ax  ; UNKNOWN
025E8D  26 8B 47 28           MOV    ax, word ptr es:[bx + 0x28]  ; UNKNOWN
025E91  26 3B 47 20           CMP    ax, word ptr es:[bx + 0x20]  ; UNKNOWN
025E95  7D 04                 JGE    0x25e9b                      ; UNKNOWN
025E97  26 8B 47 20           MOV    ax, word ptr es:[bx + 0x20]  ; UNKNOWN
025E9B  26 3B 47 34           CMP    ax, word ptr es:[bx + 0x34]  ; UNKNOWN
025E9F  7D 04                 JGE    0x25ea5                      ; UNKNOWN
025EA1  26 8B 47 34           MOV    ax, word ptr es:[bx + 0x34]  ; UNKNOWN
025EA5  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax  ; UNKNOWN
025EA9  26 89 47 34           MOV    word ptr es:[bx + 0x34], ax  ; UNKNOWN
025EAD  26 89 47 20           MOV    word ptr es:[bx + 0x20], ax  ; UNKNOWN
025EB1  26 8B 47 02           MOV    ax, word ptr es:[bx + 2]     ; UNKNOWN
025EB5  26 03 47 04           ADD    ax, word ptr es:[bx + 4]     ; UNKNOWN
025EB9  26 03 47 06           ADD    ax, word ptr es:[bx + 6]     ; UNKNOWN
025EBD  26 03 47 08           ADD    ax, word ptr es:[bx + 8]     ; UNKNOWN
025EC1  75 03                 JNE    0x25ec6                      ; UNKNOWN
025EC3  E9 B5 04              JMP    0x2637b                      ; UNKNOWN
025EC6  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
025ECB  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
025ECE  26 8B 47 5E           MOV    ax, word ptr es:[bx + 0x5e]  ; UNKNOWN
025ED2  26 0B 47 5C           OR     ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
025ED6  74 49                 JE     0x25f21                      ; UNKNOWN
025ED8  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48]  ; UNKNOWN
025EDC  26 03 47 2E           ADD    ax, word ptr es:[bx + 0x2e]  ; UNKNOWN
025EE0  26 03 47 30           ADD    ax, word ptr es:[bx + 0x30]  ; UNKNOWN
025EE4  26 03 47 32           ADD    ax, word ptr es:[bx + 0x32]  ; UNKNOWN
025EE8  26 01 47 14           ADD    word ptr es:[bx + 0x14], ax  ; UNKNOWN
025EEC  26 01 47 2A           ADD    word ptr es:[bx + 0x2a], ax  ; UNKNOWN
025EF0  26 01 47 24           ADD    word ptr es:[bx + 0x24], ax  ; UNKNOWN
025EF4  26 01 47 36           ADD    word ptr es:[bx + 0x36], ax  ; UNKNOWN
025EF8  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
025EFC  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e]  ; UNKNOWN
025F00  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
025F03  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
025F06  8B C2                 MOV    ax, dx                       ; UNKNOWN
025F08  0B                    DB     0x0B                         ; UNKNOWN (raw)
025F09  46                    DB     0x46                         ; UNKNOWN (raw)
