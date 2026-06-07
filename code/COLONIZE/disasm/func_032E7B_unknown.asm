; ============================================================================
; func_032E7B_unknown
; Region   : load_image
; Bytes    : file 0x032E7B..0x032ED2  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032E7B  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
032E7F  57                    PUSH   di                           ; UNKNOWN
032E80  56                    PUSH   si                           ; UNKNOWN
032E81  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0      ; UNKNOWN
032E86  8B 5E A2              MOV    bx, word ptr [bp - 0x5e]     ; UNKNOWN
032E89  D1 E3                 SHL    bx, 1                        ; UNKNOWN
032E8B  8B 87 62 3E           MOV    ax, word ptr [bx + 0x3e62]   ; UNKNOWN
032E8F  99                    CDQ                                 ; UNKNOWN
032E90  8B 76 A2              MOV    si, word ptr [bp - 0x5e]     ; UNKNOWN
032E93  C1 E6 02              SHL    si, 2                        ; UNKNOWN
032E96  89 42 B4              MOV    word ptr [bp + si - 0x4c], ax ; UNKNOWN
032E99  89 52 B6              MOV    word ptr [bp + si - 0x4a], dx ; UNKNOWN
032E9C  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
032EA1  6B 5E AC 4F           IMUL   bx, word ptr [bp - 0x54], 0x4f ; UNKNOWN
032EA5  03 5E A2              ADD    bx, word ptr [bp - 0x5e]     ; UNKNOWN
032EA8  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
032EAB  8B 87 A6 75           MOV    ax, word ptr [bx + 0x75a6]   ; UNKNOWN
032EAF  8B 97 A8 75           MOV    dx, word ptr [bx + 0x75a8]   ; UNKNOWN
032EB3  0B D2                 OR     dx, dx                       ; UNKNOWN
032EB5  7F 06                 JG     0x32ebd                      ; UNKNOWN
032EB7  7D 04                 JGE    0x32ebd                      ; UNKNOWN
032EB9  2B D2                 SUB    dx, dx                       ; UNKNOWN
032EBB  2B C0                 SUB    ax, ax                       ; UNKNOWN
032EBD  8B 76 A2              MOV    si, word ptr [bp - 0x5e]     ; UNKNOWN
032EC0  C1 E6 02              SHL    si, 2                        ; UNKNOWN
032EC3  01 42 B4              ADD    word ptr [bp + si - 0x4c], ax ; UNKNOWN
032EC6  11 52 B6              ADC    word ptr [bp + si - 0x4a], dx ; UNKNOWN
032EC9  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
032ECC  83 7E AC 04           CMP    word ptr [bp - 0x54], 4      ; UNKNOWN
032ED0  7C CF                 JL     0x32ea1                      ; UNKNOWN
