; ============================================================================
; func_04C69C_unknown
; Region   : load_image
; Bytes    : file 0x04C69C..0x04C6E9  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C69C  C8 66 00 00           ENTER  0x66, 0                      ; UNKNOWN
04C6A0  56                    PUSH   si                           ; UNKNOWN
04C6A1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04C6A4  0E                    PUSH   cs                           ; UNKNOWN
04C6A5  E8 DC FE              CALL   0x4c584                      ; UNKNOWN
04C6A8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C6AB  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
04C6B0  C7 46 A8 2A 00        MOV    word ptr [bp - 0x58], 0x2a   ; UNKNOWN
04C6B5  2B C0                 SUB    ax, ax                       ; UNKNOWN
04C6B7  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
04C6BA  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
04C6BD  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
04C6C0  E9 5A 01              JMP    0x4c81d                      ; UNKNOWN
04C6C3  50                    PUSH   ax                           ; UNKNOWN
04C6C4  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
04C6C9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04C6CC  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
04C6CF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04C6D3  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
04C6D6  74 03                 JE     0x4c6db                      ; UNKNOWN
04C6D8  E9 3F 01              JMP    0x4c81a                      ; UNKNOWN
04C6DB  68 92 00              PUSH   0x92                         ; UNKNOWN
04C6DE  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04C6E1  40                    INC    ax                           ; UNKNOWN
04C6E2  40                    INC    ax                           ; UNKNOWN
04C6E3  50                    PUSH   ax                           ; UNKNOWN
04C6E4  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
04C6E7  8B C3                 MOV    ax, bx                       ; UNKNOWN
