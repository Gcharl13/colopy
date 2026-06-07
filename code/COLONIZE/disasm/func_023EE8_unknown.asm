; ============================================================================
; func_023EE8_unknown
; Region   : load_image
; Bytes    : file 0x023EE8..0x023F96  (174 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023EE8  C8 60 00 00           ENTER  0x60, 0                      ; UNKNOWN
023EEC  53                    PUSH   bx                           ; UNKNOWN
023EED  52                    PUSH   dx                           ; UNKNOWN
023EEE  50                    PUSH   ax                           ; UNKNOWN
023EEF  57                    PUSH   di                           ; UNKNOWN
023EF0  56                    PUSH   si                           ; UNKNOWN
023EF1  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
023EF4  89 5E A0              MOV    word ptr [bp - 0x60], bx     ; UNKNOWN
023EF7  8A 87 DE 79           MOV    al, byte ptr [bx + 0x79de]   ; UNKNOWN
023EFB  2A E4                 SUB    ah, ah                       ; UNKNOWN
023EFD  83 E8 04              SUB    ax, 4                        ; UNKNOWN
023F00  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
023F03  6B D8 4E              IMUL   bx, ax, 0x4e                 ; UNKNOWN
023F06  8A 87 C6 7F           MOV    al, byte ptr [bx + 0x7fc6]   ; UNKNOWN
023F0A  2A E4                 SUB    ah, ah                       ; UNKNOWN
023F0C  8B F0                 MOV    si, ax                       ; UNKNOWN
023F0E  83 7E 06 64           CMP    word ptr [bp + 6], 0x64      ; UNKNOWN
023F12  7D 14                 JGE    0x23f28                      ; UNKNOWN
023F14  8A 0E 34 0B           MOV    cl, byte ptr [0xb34]         ; UNKNOWN
023F18  B8 02 00              MOV    ax, 2                        ; UNKNOWN
023F1B  D3 F8                 SAR    ax, cl                       ; UNKNOWN
023F1D  29 46 9C              SUB    word ptr [bp - 0x64], ax     ; UNKNOWN
023F20  A1 7C 82              MOV    ax, word ptr [0x827c]        ; UNKNOWN
023F23  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
023F26  EB 05                 JMP    0x23f2d                      ; UNKNOWN
023F28  C7 46 F6 10 00        MOV    word ptr [bp - 0xa], 0x10    ; UNKNOWN
023F2D  8B 46 9E              MOV    ax, word ptr [bp - 0x62]     ; UNKNOWN
023F30  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
023F33  48                    DEC    ax                           ; UNKNOWN
023F34  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
023F37  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
023F3B  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
023F3F  50                    PUSH   ax                           ; UNKNOWN
023F40  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
023F43  8B C6                 MOV    ax, si                       ; UNKNOWN
023F45  83 F8 03              CMP    ax, 3                        ; UNKNOWN
023F48  7E 03                 JLE    0x23f4d                      ; UNKNOWN
023F4A  B8 03 00              MOV    ax, 3                        ; UNKNOWN
023F4D  83 C0 0B              ADD    ax, 0xb                      ; UNKNOWN
023F50  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
023F53  D1 FA                 SAR    dx, 1                        ; UNKNOWN
023F55  03 56 9C              ADD    dx, word ptr [bp - 0x64]     ; UNKNOWN
023F58  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
023F5B  8D 5E 08              LEA    bx, [bp + 8]                 ; UNKNOWN
023F5E  9A 02 00 35 5D        LCALL  0x5d35, 2                    ; UNKNOWN
023F63  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
023F66  8A 87 7E 09           MOV    al, byte ptr [bx + 0x97e]    ; UNKNOWN
023F6A  88 46 F8              MOV    byte ptr [bp - 8], al        ; UNKNOWN
023F6D  83 7E 06 64           CMP    word ptr [bp + 6], 0x64      ; UNKNOWN
023F71  74 03                 JE     0x23f76                      ; UNKNOWN
023F73  E9 BC 00              JMP    0x24032                      ; UNKNOWN
023F76  0B F6                 OR     si, si                       ; UNKNOWN
023F78  75 68                 JNE    0x23fe2                      ; UNKNOWN
023F7A  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
023F7D  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
023F80  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
023F83  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
023F86  6A 01                 PUSH   1                            ; UNKNOWN
023F88  50                    PUSH   ax                           ; UNKNOWN
023F89  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
023F8C  83 C0 03              ADD    ax, 3                        ; UNKNOWN
023F8F  8B 56 9E              MOV    dx, word ptr [bp - 0x62]     ; UNKNOWN
023F92  83 C2 04              ADD    dx, 4                        ; UNKNOWN
023F95  BB                    DB     0xBB                         ; UNKNOWN (raw)
