; ============================================================================
; func_03B004_unknown
; Region   : load_image
; Bytes    : file 0x03B004..0x03B07F  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B004  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03B008  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
03B00D  6A 17                 PUSH   0x17                         ; UNKNOWN
03B00F  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
03B013  8D 06 86 23           LEA    ax, [0x2386]                 ; UNKNOWN
03B017  8D 16 85 23           LEA    dx, [0x2385]                 ; UNKNOWN
03B01B  9A 99 37 97 1B        LCALL  0x1b97, 0x3799               ; UNKNOWN
03B020  0B C0                 OR     ax, ax                       ; UNKNOWN
03B022  74 03                 JE     0x3b027                      ; UNKNOWN
03B024  E9 A8 00              JMP    0x3b0cf                      ; UNKNOWN
03B027  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B02A  EB 63                 JMP    0x3b08f                      ; UNKNOWN
03B02C  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
03B02F  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
03B032  7D 61                 JGE    0x3b095                      ; UNKNOWN
03B034  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03B037  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
03B03C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03B03F  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
03B042  40                    INC    ax                           ; UNKNOWN
03B043  40                    INC    ax                           ; UNKNOWN
03B044  50                    PUSH   ax                           ; UNKNOWN
03B045  68 DA 3E              PUSH   0x3eda                       ; UNKNOWN
03B048  9A BA 0C 65 5F        LCALL  0x5f65, 0xcba                ; UNKNOWN
03B04D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03B050  0B C0                 OR     ax, ax                       ; UNKNOWN
03B052  75 38                 JNE    0x3b08c                      ; UNKNOWN
03B054  83 3E 0E 3E 04        CMP    word ptr [0x3e0e], 4         ; UNKNOWN
03B059  7D 2B                 JGE    0x3b086                      ; UNKNOWN
03B05B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
03B05F  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
03B062  2A E4                 SUB    ah, ah                       ; UNKNOWN
03B064  50                    PUSH   ax                           ; UNKNOWN
03B065  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
03B067  50                    PUSH   ax                           ; UNKNOWN
03B068  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
03B06D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03B070  2A E4                 SUB    ah, ah                       ; UNKNOWN
03B072  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
03B076  BA 10 00              MOV    dx, 0x10                     ; UNKNOWN
03B079  D3 E2                 SHL    dx, cl                       ; UNKNOWN
03B07B  85 C2                 TEST   dx, ax                       ; UNKNOWN
03B07D  75 07                 JNE    0x3b086                      ; UNKNOWN
