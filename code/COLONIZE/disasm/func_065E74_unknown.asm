; ============================================================================
; func_065E74_unknown
; Region   : load_image
; Bytes    : file 0x065E74..0x065EA0  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065E74  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
065E78  50                    PUSH   ax                           ; UNKNOWN
065E79  57                    PUSH   di                           ; UNKNOWN
065E7A  56                    PUSH   si                           ; UNKNOWN
065E7B  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
065E80  1E                    PUSH   ds                           ; UNKNOWN
065E81  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
065E84  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
065E87  8B DE                 MOV    bx, si                       ; UNKNOWN
065E89  8B 56 EE              MOV    dx, word ptr [bp - 0x12]     ; UNKNOWN
065E8C  4A                    DEC    dx                           ; UNKNOWN
065E8D  3B F2                 CMP    si, dx                       ; UNKNOWN
065E8F  7C 03                 JL     0x65e94                      ; UNKNOWN
065E91  E9 96 00              JMP    0x65f2a                      ; UNKNOWN
065E94  26 8A 41 01           MOV    al, byte ptr es:[bx + di + 1] ; UNKNOWN
065E98  26 3A 01              CMP    al, byte ptr es:[bx + di]    ; UNKNOWN
065E9B  72 09                 JB     0x65ea6                      ; UNKNOWN
065E9D  46                    INC    si                           ; UNKNOWN
065E9E  83                    DB     0x83                         ; UNKNOWN (raw)
065E9F  C3                    DB     0xC3                         ; UNKNOWN (raw)
