; ============================================================================
; func_02DC01_unknown
; Region   : load_image
; Bytes    : file 0x02DC01..0x02DC48  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DC01  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02DC05  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02DC0A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DC0D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DC10  0E                    PUSH   cs                           ; UNKNOWN
02DC11  E8 AF FF              CALL   0x2dbc3                      ; UNKNOWN
02DC14  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DC17  0B C0                 OR     ax, ax                       ; UNKNOWN
02DC19  7C 28                 JL     0x2dc43                      ; UNKNOWN
02DC1B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DC1F  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02DC22  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DC24  48                    DEC    ax                           ; UNKNOWN
02DC25  48                    DEC    ax                           ; UNKNOWN
02DC26  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
02DC29  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DC2C  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02DC2E  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DC30  48                    DEC    ax                           ; UNKNOWN
02DC31  48                    DEC    ax                           ; UNKNOWN
02DC32  01 46 06              ADD    word ptr [bp + 6], ax        ; UNKNOWN
02DC35  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DC38  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02DC3D  83 E0 10              AND    ax, 0x10                     ; UNKNOWN
02DC40  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02DC43  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DC46  C9                    LEAVE                               ; UNKNOWN
02DC47  CB                    RETF                                ; UNKNOWN
