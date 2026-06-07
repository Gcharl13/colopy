; ============================================================================
; func_064F32_unknown
; Region   : load_image
; Bytes    : file 0x064F32..0x064F66  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064F32  55                    PUSH   bp                           ; UNKNOWN
064F33  8B EC                 MOV    bp, sp                       ; UNKNOWN
064F35  57                    PUSH   di                           ; UNKNOWN
064F36  56                    PUSH   si                           ; UNKNOWN
064F37  C7 06 7C 0C 01 00     MOV    word ptr [0xc7c], 1          ; UNKNOWN
064F3D  8B 1E 7A 0C           MOV    bx, word ptr [0xc7a]         ; UNKNOWN
064F41  BB 00 03              MOV    bx, 0x300                    ; UNKNOWN
064F44  BF 00 03              MOV    di, 0x300                    ; UNKNOWN
064F47  1E                    PUSH   ds                           ; UNKNOWN
064F48  C5 76 06              LDS    si, ptr [bp + 6]             ; UNKNOWN
064F4B  BA C8 03              MOV    dx, 0x3c8                    ; UNKNOWN
064F4E  32 C0                 XOR    al, al                       ; UNKNOWN
064F50  EE                    OUT    dx, al                       ; UNKNOWN
064F51  42                    INC    dx                           ; UNKNOWN
064F52  52                    PUSH   dx                           ; UNKNOWN
064F53  BA DA 03              MOV    dx, 0x3da                    ; UNKNOWN
064F56  B4 08                 MOV    ah, 8                        ; UNKNOWN
064F58  EC                    IN     al, dx                       ; UNKNOWN
064F59  22 C4                 AND    al, ah                       ; UNKNOWN
064F5B  75 FB                 JNE    0x64f58                      ; UNKNOWN
064F5D  EC                    IN     al, dx                       ; UNKNOWN
064F5E  22 C4                 AND    al, ah                       ; UNKNOWN
064F60  74 FB                 JE     0x64f5d                      ; UNKNOWN
064F62  FA                    CLI                                 ; UNKNOWN
064F63  5A                    POP    dx                           ; UNKNOWN
064F64  8B CF                 MOV    cx, di                       ; UNKNOWN
