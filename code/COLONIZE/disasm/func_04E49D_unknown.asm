; ============================================================================
; func_04E49D_unknown
; Region   : load_image
; Bytes    : file 0x04E49D..0x04E4D2  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E49D  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
04E4A1  57                    PUSH   di                           ; UNKNOWN
04E4A2  56                    PUSH   si                           ; UNKNOWN
04E4A3  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04E4A6  0E                    PUSH   cs                           ; UNKNOWN
04E4A7  E8 41 FE              CALL   0x4e2eb                      ; UNKNOWN
04E4AA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E4AD  89 46 0A              MOV    word ptr [bp + 0xa], ax      ; UNKNOWN
04E4B0  8A 4E 12              MOV    cl, byte ptr [bp + 0x12]     ; UNKNOWN
04E4B3  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
04E4B6  D3 F8                 SAR    ax, cl                       ; UNKNOWN
04E4B8  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
04E4BB  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
04E4BE  BA 01 00              MOV    dx, 1                        ; UNKNOWN
04E4C1  D3 E2                 SHL    dx, cl                       ; UNKNOWN
04E4C3  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
04E4C6  8B D8                 MOV    bx, ax                       ; UNKNOWN
04E4C8  48                    DEC    ax                           ; UNKNOWN
04E4C9  F7 D8                 NEG    ax                           ; UNKNOWN
04E4CB  01 46 10              ADD    word ptr [bp + 0x10], ax     ; UNKNOWN
04E4CE  8B C2                 MOV    ax, dx                       ; UNKNOWN
04E4D0  8B D3                 MOV    dx, bx                       ; UNKNOWN
