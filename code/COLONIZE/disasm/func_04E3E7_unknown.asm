; ============================================================================
; func_04E3E7_unknown
; Region   : load_image
; Bytes    : file 0x04E3E7..0x04E41C  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E3E7  C8 1A 00 00           ENTER  0x1a, 0                      ; UNKNOWN
04E3EB  57                    PUSH   di                           ; UNKNOWN
04E3EC  56                    PUSH   si                           ; UNKNOWN
04E3ED  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04E3F0  0E                    PUSH   cs                           ; UNKNOWN
04E3F1  E8 F7 FE              CALL   0x4e2eb                      ; UNKNOWN
04E3F4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E3F7  89 46 0A              MOV    word ptr [bp + 0xa], ax      ; UNKNOWN
04E3FA  8A 4E 12              MOV    cl, byte ptr [bp + 0x12]     ; UNKNOWN
04E3FD  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
04E400  D3 F8                 SAR    ax, cl                       ; UNKNOWN
04E402  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
04E405  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
04E408  BA 01 00              MOV    dx, 1                        ; UNKNOWN
04E40B  D3 E2                 SHL    dx, cl                       ; UNKNOWN
04E40D  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
04E410  8B D8                 MOV    bx, ax                       ; UNKNOWN
04E412  48                    DEC    ax                           ; UNKNOWN
04E413  F7 D8                 NEG    ax                           ; UNKNOWN
04E415  01 46 10              ADD    word ptr [bp + 0x10], ax     ; UNKNOWN
04E418  8B C2                 MOV    ax, dx                       ; UNKNOWN
04E41A  8B D3                 MOV    dx, bx                       ; UNKNOWN
