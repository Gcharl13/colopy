; ============================================================================
; func_02B45E_unknown
; Region   : load_image
; Bytes    : file 0x02B45E..0x02B490  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B45E  55                    PUSH   bp                           ; UNKNOWN
02B45F  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B461  56                    PUSH   si                           ; UNKNOWN
02B462  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B465  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B468  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
02B46D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B470  2A E4                 SUB    ah, ah                       ; UNKNOWN
02B472  24 1F                 AND    al, 0x1f                     ; UNKNOWN
02B474  8B F0                 MOV    si, ax                       ; UNKNOWN
02B476  83 FE 08              CMP    si, 8                        ; UNKNOWN
02B479  7C 05                 JL     0x2b480                      ; UNKNOWN
02B47B  83 FE 10              CMP    si, 0x10                     ; UNKNOWN
02B47E  7C 0A                 JL     0x2b48a                      ; UNKNOWN
02B480  83 FE 10              CMP    si, 0x10                     ; UNKNOWN
02B483  7C 0B                 JL     0x2b490                      ; UNKNOWN
02B485  83 FE 18              CMP    si, 0x18                     ; UNKNOWN
02B488  7D 06                 JGE    0x2b490                      ; UNKNOWN
02B48A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02B48D  5E                    POP    si                           ; UNKNOWN
02B48E  C9                    LEAVE                               ; UNKNOWN
02B48F  CB                    RETF                                ; UNKNOWN
