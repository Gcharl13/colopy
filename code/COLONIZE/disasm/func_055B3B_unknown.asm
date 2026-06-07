; ============================================================================
; func_055B3B_unknown
; Region   : load_image
; Bytes    : file 0x055B3B..0x055C64  (297 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

055B3B  C8 44 00 00           ENTER  0x44, 0                      ; UNKNOWN
055B3F  57                    PUSH   di                           ; UNKNOWN
055B40  56                    PUSH   si                           ; UNKNOWN
055B41  2B C0                 SUB    ax, ax                       ; UNKNOWN
055B43  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
055B46  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
055B49  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
055B4C  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
055B4F  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
055B52  89 46 D0              MOV    word ptr [bp - 0x30], ax     ; UNKNOWN
055B55  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
055B58  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
055B5B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
055B5E  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
055B63  83 C4 02              ADD    sp, 2                        ; UNKNOWN
055B66  A1 02 3E              MOV    ax, word ptr [0x3e02]        ; UNKNOWN
055B69  2D DC 05              SUB    ax, 0x5dc                    ; UNKNOWN
055B6C  B9 32 00              MOV    cx, 0x32                     ; UNKNOWN
055B6F  99                    CDQ                                 ; UNKNOWN
055B70  F7 F9                 IDIV   cx                           ; UNKNOWN
055B72  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
055B75  8A 8F AE 86           MOV    cl, byte ptr [bx - 0x7952]   ; UNKNOWN
055B79  2A ED                 SUB    ch, ch                       ; UNKNOWN
055B7B  03 C8                 ADD    cx, ax                       ; UNKNOWN
055B7D  89 4E F0              MOV    word ptr [bp - 0x10], cx     ; UNKNOWN
055B80  83 3E 06 3E 14        CMP    word ptr [0x3e06], 0x14      ; UNKNOWN
055B85  7D 05                 JGE    0x55b8c                      ; UNKNOWN
055B87  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
055B8C  81 3E 02 3E A4 06     CMP    word ptr [0x3e02], 0x6a4     ; UNKNOWN
055B92  7C 03                 JL     0x55b97                      ; UNKNOWN
055B94  D1 66 F0              SHL    word ptr [bp - 0x10], 1      ; UNKNOWN
055B97  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
055B9A  2A E4                 SUB    ah, ah                       ; UNKNOWN
055B9C  F7 6E F0              IMUL   word ptr [bp - 0x10]         ; UNKNOWN
055B9F  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
055BA2  80 3E 1E 3E 03        CMP    byte ptr [0x3e1e], 3         ; UNKNOWN
055BA7  75 08                 JNE    0x55bb1                      ; UNKNOWN
055BA9  D1 F8                 SAR    ax, 1                        ; UNKNOWN
055BAB  03 46 D4              ADD    ax, word ptr [bp - 0x2c]     ; UNKNOWN
055BAE  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
055BB1  80 3E 1E 3E 04        CMP    byte ptr [0x3e1e], 4         ; UNKNOWN
055BB6  75 03                 JNE    0x55bbb                      ; UNKNOWN
055BB8  D1 66 D4              SHL    word ptr [bp - 0x2c], 1      ; UNKNOWN
055BBB  C1 66 D4 02           SHL    word ptr [bp - 0x2c], 2      ; UNKNOWN
055BBF  8B 46 D4              MOV    ax, word ptr [bp - 0x2c]     ; UNKNOWN
055BC2  99                    CDQ                                 ; UNKNOWN
055BC3  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
055BC7  01 47 2A              ADD    word ptr [bx + 0x2a], ax     ; UNKNOWN
055BCA  11 57 2C              ADC    word ptr [bx + 0x2c], dx     ; UNKNOWN
055BCD  C7 46 CC 00 00        MOV    word ptr [bp - 0x34], 0      ; UNKNOWN
055BD2  EB 33                 JMP    0x55c07                      ; UNKNOWN
055BD4  83 7E EE 00           CMP    word ptr [bp - 0x12], 0      ; UNKNOWN
055BD8  75 35                 JNE    0x55c0f                      ; UNKNOWN
055BDA  FF 76 CC              PUSH   word ptr [bp - 0x34]         ; UNKNOWN
055BDD  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
055BE2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
055BE5  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
055BE8  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
055BEC  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
055BEF  75 13                 JNE    0x55c04                      ; UNKNOWN
055BF1  6A 0D                 PUSH   0xd                          ; UNKNOWN
055BF3  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
055BF8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
055BFB  0B C0                 OR     ax, ax                       ; UNKNOWN
055BFD  74 05                 JE     0x55c04                      ; UNKNOWN
055BFF  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
055C04  FF 46 CC              INC    word ptr [bp - 0x34]         ; UNKNOWN
055C07  A1 16 3E              MOV    ax, word ptr [0x3e16]        ; UNKNOWN
055C0A  39 46 CC              CMP    word ptr [bp - 0x34], ax     ; UNKNOWN
055C0D  7C C5                 JL     0x55bd4                      ; UNKNOWN
055C0F  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
055C14  74 46                 JE     0x55c5c                      ; UNKNOWN
055C16  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
055C19  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
055C1C  8B D0                 MOV    dx, ax                       ; UNKNOWN
055C1E  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
055C23  EB 08                 JMP    0x55c2d                      ; UNKNOWN
055C25  8B 46 BE              MOV    ax, word ptr [bp - 0x42]     ; UNKNOWN
055C28  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
055C2D  89 46 BE              MOV    word ptr [bp - 0x42], ax     ; UNKNOWN
055C30  0B C0                 OR     ax, ax                       ; UNKNOWN
055C32  7C 28                 JL     0x55c5c                      ; UNKNOWN
055C34  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
055C37  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
055C3B  24 0F                 AND    al, 0xf                      ; UNKNOWN
055C3D  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
055C40  75 E3                 JNE    0x55c25                      ; UNKNOWN
055C42  6B 5E BE 1C           IMUL   bx, word ptr [bp - 0x42], 0x1c ; UNKNOWN
055C46  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
055C4B  75 D8                 JNE    0x55c25                      ; UNKNOWN
055C4D  FF 76 BE              PUSH   word ptr [bp - 0x42]         ; UNKNOWN
055C50  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
055C55  83 C4 02              ADD    sp, 2                        ; UNKNOWN
055C58  FF 06 56 3E           INC    word ptr [0x3e56]            ; UNKNOWN
055C5C  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
055C5F  80 BF C2 86 01        CMP    byte ptr [bx - 0x793e], 1    ; UNKNOWN
