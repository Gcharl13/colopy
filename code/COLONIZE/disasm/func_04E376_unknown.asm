; ============================================================================
; func_04E376_unknown
; Region   : load_image
; Bytes    : file 0x04E376..0x04E3E7  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E376  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
04E37A  57                    PUSH   di                           ; UNKNOWN
04E37B  56                    PUSH   si                           ; UNKNOWN
04E37C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
04E37F  0E                    PUSH   cs                           ; UNKNOWN
04E380  E8 68 FF              CALL   0x4e2eb                      ; UNKNOWN
04E383  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E386  89 46 0A              MOV    word ptr [bp + 0xa], ax      ; UNKNOWN
04E389  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
04E38C  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
04E38F  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
04E392  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
04E397  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04E39A  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04E39D  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
04E3A0  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
04E3A3  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04E3A6  83 E8 10              SUB    ax, 0x10                     ; UNKNOWN
04E3A9  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04E3AC  8A 66 0A              MOV    ah, byte ptr [bp + 0xa]      ; UNKNOWN
04E3AF  2A C0                 SUB    al, al                       ; UNKNOWN
04E3B1  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
04E3B4  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
04E3B7  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04E3BA  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
04E3BD  1E                    PUSH   ds                           ; UNKNOWN
04E3BE  C4 7E FC              LES    di, ptr [bp - 4]             ; UNKNOWN
04E3C1  C5 76 F4              LDS    si, ptr [bp - 0xc]           ; UNKNOWN
04E3C4  BB 10 00              MOV    bx, 0x10                     ; UNKNOWN
04E3C7  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
04E3CA  B9 10 00              MOV    cx, 0x10                     ; UNKNOWN
04E3CD  26 8A 05              MOV    al, byte ptr es:[di]         ; UNKNOWN
04E3D0  0A C0                 OR     al, al                       ; UNKNOWN
04E3D2  75 05                 JNE    0x4e3d9                      ; UNKNOWN
04E3D4  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
04E3D5  E2 F6                 LOOP   0x4e3cd                      ; UNKNOWN
04E3D7  EB 04                 JMP    0x4e3dd                      ; UNKNOWN
04E3D9  47                    INC    di                           ; UNKNOWN
04E3DA  46                    INC    si                           ; UNKNOWN
04E3DB  E2 F0                 LOOP   0x4e3cd                      ; UNKNOWN
04E3DD  03 FA                 ADD    di, dx                       ; UNKNOWN
04E3DF  4B                    DEC    bx                           ; UNKNOWN
04E3E0  75 E8                 JNE    0x4e3ca                      ; UNKNOWN
04E3E2  1F                    POP    ds                           ; UNKNOWN
04E3E3  5E                    POP    si                           ; UNKNOWN
04E3E4  5F                    POP    di                           ; UNKNOWN
04E3E5  C9                    LEAVE                               ; UNKNOWN
04E3E6  CB                    RETF                                ; UNKNOWN
