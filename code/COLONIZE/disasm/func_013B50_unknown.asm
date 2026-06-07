; ============================================================================
; func_013B50_unknown
; Region   : load_image
; Bytes    : file 0x013B50..0x013C7E  (302 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013B50  C8 36 00 00           ENTER  0x36, 0                      ; UNKNOWN
013B54  56                    PUSH   si                           ; UNKNOWN
013B55  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
013B59  7D 12                 JGE    0x13b6d                      ; UNKNOWN
013B5B  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
013B5F  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
013B64  75 07                 JNE    0x13b6d                      ; UNKNOWN
013B66  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1      ; UNKNOWN
013B6B  EB 05                 JMP    0x13b72                      ; UNKNOWN
013B6D  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
013B72  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
013B76  74 3C                 JE     0x13bb4                      ; UNKNOWN
013B78  6A 03                 PUSH   3                            ; UNKNOWN
013B7A  6A 00                 PUSH   0                            ; UNKNOWN
013B7C  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013B81  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013B84  0B C0                 OR     ax, ax                       ; UNKNOWN
013B86  75 2C                 JNE    0x13bb4                      ; UNKNOWN
013B88  6A 05                 PUSH   5                            ; UNKNOWN
013B8A  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
013B8F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013B92  83 3E 3A 82 00        CMP    word ptr [0x823a], 0         ; UNKNOWN
013B97  75 0A                 JNE    0x13ba3                      ; UNKNOWN
013B99  6A 07                 PUSH   7                            ; UNKNOWN
013B9B  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
013BA0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013BA3  83 3E 3A 82 01        CMP    word ptr [0x823a], 1         ; UNKNOWN
013BA8  75 0A                 JNE    0x13bb4                      ; UNKNOWN
013BAA  6A 06                 PUSH   6                            ; UNKNOWN
013BAC  9A FB 02 28 1A        LCALL  0x1a28, 0x2fb                ; UNKNOWN
013BB1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013BB4  0E                    PUSH   cs                           ; UNKNOWN
013BB5  E8 BE EA              CALL   0x12676                      ; UNKNOWN
013BB8  FF 36 8E 3E           PUSH   word ptr [0x3e8e]            ; UNKNOWN
013BBC  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
013BC1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
013BC4  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
013BC8  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
013BCB  2A E4                 SUB    ah, ah                       ; UNKNOWN
013BCD  2B D2                 SUB    dx, dx                       ; UNKNOWN
013BCF  8A F2                 MOV    dh, dl                       ; UNKNOWN
013BD1  8A D4                 MOV    dl, ah                       ; UNKNOWN
013BD3  8A E0                 MOV    ah, al                       ; UNKNOWN
013BD5  2A C0                 SUB    al, al                       ; UNKNOWN
013BD7  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
013BD9  2A ED                 SUB    ch, ch                       ; UNKNOWN
013BDB  03 C1                 ADD    ax, cx                       ; UNKNOWN
013BDD  83 D2 00              ADC    dx, 0                        ; UNKNOWN
013BE0  03 06 8A 3E           ADD    ax, word ptr [0x3e8a]        ; UNKNOWN
013BE4  13 16 8C 3E           ADC    dx, word ptr [0x3e8c]        ; UNKNOWN
013BE8  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
013BEB  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
013BEE  52                    PUSH   dx                           ; UNKNOWN
013BEF  50                    PUSH   ax                           ; UNKNOWN
013BF0  9A 64 00 AA 0D        LCALL  0xdaa, 0x64                  ; UNKNOWN
013BF5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013BF8  C7 06 6C 82 00 00     MOV    word ptr [0x826c], 0         ; UNKNOWN
013BFE  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
013C02  80 7F 02 01           CMP    byte ptr [bx + 2], 1         ; UNKNOWN
013C06  73 0C                 JAE    0x13c14                      ; UNKNOWN
013C08  2B C0                 SUB    ax, ax                       ; UNKNOWN
013C0A  A3 74 82              MOV    word ptr [0x8274], ax        ; UNKNOWN
013C0D  A3 68 82              MOV    word ptr [0x8268], ax        ; UNKNOWN
013C10  D1 3E 5C 82           SAR    word ptr [0x825c], 1         ; UNKNOWN
013C14  80 7F 02 02           CMP    byte ptr [bx + 2], 2         ; UNKNOWN
013C18  73 15                 JAE    0x13c2f                      ; UNKNOWN
013C1A  2B C0                 SUB    ax, ax                       ; UNKNOWN
013C1C  A3 72 82              MOV    word ptr [0x8272], ax        ; UNKNOWN
013C1F  A3 70 82              MOV    word ptr [0x8270], ax        ; UNKNOWN
013C22  A3 6A 82              MOV    word ptr [0x826a], ax        ; UNKNOWN
013C25  A1 5C 82              MOV    ax, word ptr [0x825c]        ; UNKNOWN
013C28  C1 F8 02              SAR    ax, 2                        ; UNKNOWN
013C2B  29 06 5C 82           SUB    word ptr [0x825c], ax        ; UNKNOWN
013C2F  80 7F 02 03           CMP    byte ptr [bx + 2], 3         ; UNKNOWN
013C33  73 06                 JAE    0x13c3b                      ; UNKNOWN
013C35  C7 06 6E 82 00 00     MOV    word ptr [0x826e], 0         ; UNKNOWN
013C3B  80 7F 02 03           CMP    byte ptr [bx + 2], 3         ; UNKNOWN
013C3F  75 09                 JNE    0x13c4a                      ; UNKNOWN
013C41  A1 6A 82              MOV    ax, word ptr [0x826a]        ; UNKNOWN
013C44  D1 F8                 SAR    ax, 1                        ; UNKNOWN
013C46  01 06 6A 82           ADD    word ptr [0x826a], ax        ; UNKNOWN
013C4A  2B C0                 SUB    ax, ax                       ; UNKNOWN
013C4C  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
013C4F  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
013C52  EB 0F                 JMP    0x13c63                      ; UNKNOWN
013C54  8B 5E E0              MOV    bx, word ptr [bp - 0x20]     ; UNKNOWN
013C57  D1 E3                 SHL    bx, 1                        ; UNKNOWN
013C59  8B 87 5C 82           MOV    ax, word ptr [bx - 0x7da4]   ; UNKNOWN
013C5D  01 46 EA              ADD    word ptr [bp - 0x16], ax     ; UNKNOWN
013C60  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
013C63  83 7E E0 10           CMP    word ptr [bp - 0x20], 0x10   ; UNKNOWN
013C67  7C EB                 JL     0x13c54                      ; UNKNOWN
013C69  FF 76 EA              PUSH   word ptr [bp - 0x16]         ; UNKNOWN
013C6C  6A 01                 PUSH   1                            ; UNKNOWN
013C6E  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
013C73  83 C4 04              ADD    sp, 4                        ; UNKNOWN
013C76  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
013C79  C7 46 CA FF FF        MOV    word ptr [bp - 0x36], 0xffff ; UNKNOWN
