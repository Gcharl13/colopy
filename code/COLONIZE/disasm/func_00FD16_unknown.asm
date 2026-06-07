; ============================================================================
; func_00FD16_unknown
; Region   : load_image
; Bytes    : file 0x00FD16..0x00FE3F  (297 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FD16  C8 40 00 00           ENTER  0x40, 0                      ; UNKNOWN
00FD1A  56                    PUSH   si                           ; UNKNOWN
00FD1B  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
00FD1F  7D 13                 JGE    0xfd34                       ; UNKNOWN
00FD21  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
00FD25  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
00FD2A  75 08                 JNE    0xfd34                       ; UNKNOWN
00FD2C  C7 46 D8 01 00        MOV    word ptr [bp - 0x28], 1      ; UNKNOWN
00FD31  EB 06                 JMP    0xfd39                       ; UNKNOWN
00FD33  90                    NOP                                 ; UNKNOWN
00FD34  C7 46 D8 00 00        MOV    word ptr [bp - 0x28], 0      ; UNKNOWN
00FD39  83 7E D8 00           CMP    word ptr [bp - 0x28], 0      ; UNKNOWN
00FD3D  74 3C                 JE     0xfd7b                       ; UNKNOWN
00FD3F  6A 03                 PUSH   3                            ; UNKNOWN
00FD41  6A 00                 PUSH   0                            ; UNKNOWN
00FD43  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00FD48  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FD4B  0B C0                 OR     ax, ax                       ; UNKNOWN
00FD4D  75 2C                 JNE    0xfd7b                       ; UNKNOWN
00FD4F  6A 05                 PUSH   5                            ; UNKNOWN
00FD51  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
00FD56  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FD59  83 3E 3A 82 00        CMP    word ptr [0x823a], 0         ; UNKNOWN
00FD5E  75 0A                 JNE    0xfd6a                       ; UNKNOWN
00FD60  6A 07                 PUSH   7                            ; UNKNOWN
00FD62  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
00FD67  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FD6A  83 3E 3A 82 01        CMP    word ptr [0x823a], 1         ; UNKNOWN
00FD6F  75 0A                 JNE    0xfd7b                       ; UNKNOWN
00FD71  6A 06                 PUSH   6                            ; UNKNOWN
00FD73  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
00FD78  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FD7B  9A B6 2B AC 06        LCALL  0x6ac, 0x2bb6                ; UNKNOWN
00FD80  FF 36 8E 3E           PUSH   word ptr [0x3e8e]            ; UNKNOWN
00FD84  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
00FD89  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00FD8C  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
00FD90  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
00FD93  2A E4                 SUB    ah, ah                       ; UNKNOWN
00FD95  2B D2                 SUB    dx, dx                       ; UNKNOWN
00FD97  8A F2                 MOV    dh, dl                       ; UNKNOWN
00FD99  8A D4                 MOV    dl, ah                       ; UNKNOWN
00FD9B  8A E0                 MOV    ah, al                       ; UNKNOWN
00FD9D  2A C0                 SUB    al, al                       ; UNKNOWN
00FD9F  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
00FDA1  2A ED                 SUB    ch, ch                       ; UNKNOWN
00FDA3  03 C1                 ADD    ax, cx                       ; UNKNOWN
00FDA5  83 D2 00              ADC    dx, 0                        ; UNKNOWN
00FDA8  03 06 8A 3E           ADD    ax, word ptr [0x3e8a]        ; UNKNOWN
00FDAC  13 16 8C 3E           ADC    dx, word ptr [0x3e8c]        ; UNKNOWN
00FDB0  52                    PUSH   dx                           ; UNKNOWN
00FDB1  50                    PUSH   ax                           ; UNKNOWN
00FDB2  9A 64 00 AA 0D        LCALL  0xdaa, 0x64                  ; UNKNOWN
00FDB7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FDBA  C7 06 6C 82 00 00     MOV    word ptr [0x826c], 0         ; UNKNOWN
00FDC0  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
00FDC4  43                    INC    bx                           ; UNKNOWN
00FDC5  43                    INC    bx                           ; UNKNOWN
00FDC6  89 5E C4              MOV    word ptr [bp - 0x3c], bx     ; UNKNOWN
00FDC9  80 3F 01              CMP    byte ptr [bx], 1             ; UNKNOWN
00FDCC  73 0C                 JAE    0xfdda                       ; UNKNOWN
00FDCE  2B C0                 SUB    ax, ax                       ; UNKNOWN
00FDD0  A3 74 82              MOV    word ptr [0x8274], ax        ; UNKNOWN
00FDD3  A3 68 82              MOV    word ptr [0x8268], ax        ; UNKNOWN
00FDD6  D1 3E 5C 82           SAR    word ptr [0x825c], 1         ; UNKNOWN
00FDDA  80 3F 02              CMP    byte ptr [bx], 2             ; UNKNOWN
00FDDD  73 15                 JAE    0xfdf4                       ; UNKNOWN
00FDDF  2B C0                 SUB    ax, ax                       ; UNKNOWN
00FDE1  A3 72 82              MOV    word ptr [0x8272], ax        ; UNKNOWN
00FDE4  A3 70 82              MOV    word ptr [0x8270], ax        ; UNKNOWN
00FDE7  A3 6A 82              MOV    word ptr [0x826a], ax        ; UNKNOWN
00FDEA  A1 5C 82              MOV    ax, word ptr [0x825c]        ; UNKNOWN
00FDED  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
00FDF0  29 06 5C 82           SUB    word ptr [0x825c], ax        ; UNKNOWN
00FDF4  80 3F 03              CMP    byte ptr [bx], 3             ; UNKNOWN
00FDF7  73 06                 JAE    0xfdff                       ; UNKNOWN
00FDF9  C7 06 6E 82 00 00     MOV    word ptr [0x826e], 0         ; UNKNOWN
00FDFF  80 3F 03              CMP    byte ptr [bx], 3             ; UNKNOWN
00FE02  75 09                 JNE    0xfe0d                       ; UNKNOWN
00FE04  A1 6A 82              MOV    ax, word ptr [0x826a]        ; UNKNOWN
00FE07  D1 F8                 SAR    ax, 1                        ; UNKNOWN
00FE09  01 06 6A 82           ADD    word ptr [0x826a], ax        ; UNKNOWN
00FE0D  C7 46 CC 00 00        MOV    word ptr [bp - 0x34], 0      ; UNKNOWN
00FE12  C7 46 C8 5C 82        MOV    word ptr [bp - 0x38], 0x825c ; UNKNOWN
00FE17  8B 5E C8              MOV    bx, word ptr [bp - 0x38]     ; UNKNOWN
00FE1A  83 46 C8 02           ADD    word ptr [bp - 0x38], 2      ; UNKNOWN
00FE1E  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
00FE20  01 46 CC              ADD    word ptr [bp - 0x34], ax     ; UNKNOWN
00FE23  81 7E C8 7C 82        CMP    word ptr [bp - 0x38], 0x827c ; UNKNOWN
00FE28  72 ED                 JB     0xfe17                       ; UNKNOWN
00FE2A  FF 76 CC              PUSH   word ptr [bp - 0x34]         ; UNKNOWN
00FE2D  6A 01                 PUSH   1                            ; UNKNOWN
00FE2F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00FE34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FE37  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
00FE3A  C7 46 CA FF FF        MOV    word ptr [bp - 0x36], 0xffff ; UNKNOWN
