; ============================================================================
; func_04DE4F_unknown
; Region   : load_image
; Bytes    : file 0x04DE4F..0x04DEC9  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DE4F  C8 16 03 00           ENTER  0x316, 0                     ; UNKNOWN
04DE53  50                    PUSH   ax                           ; UNKNOWN
04DE54  57                    PUSH   di                           ; UNKNOWN
04DE55  56                    PUSH   si                           ; UNKNOWN
04DE56  8D 86 F2 FC           LEA    ax, [bp - 0x30e]             ; UNKNOWN
04DE5A  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04DE5D  8C 56 FA              MOV    word ptr [bp - 6], ss        ; UNKNOWN
04DE60  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
04DE63  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
04DE66  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
04DE69  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
04DE6C  2B C9                 SUB    cx, cx                       ; UNKNOWN
04DE6E  89 0E C6 CE           MOV    word ptr [0xcec6], cx        ; UNKNOWN
04DE72  89 0E C4 CE           MOV    word ptr [0xcec4], cx        ; UNKNOWN
04DE76  6A 03                 PUSH   3                            ; UNKNOWN
04DE78  16                    PUSH   ss                           ; UNKNOWN
04DE79  50                    PUSH   ax                           ; UNKNOWN
04DE7A  B8 00 FC              MOV    ax, 0xfc00                   ; UNKNOWN
04DE7D  BA 00 A0              MOV    dx, 0xa000                   ; UNKNOWN
04DE80  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04DE83  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
04DE86  52                    PUSH   dx                           ; UNKNOWN
04DE87  50                    PUSH   ax                           ; UNKNOWN
04DE88  0E                    PUSH   cs                           ; UNKNOWN
04DE89  E8 EC FE              CALL   0x4dd78                      ; UNKNOWN
04DE8C  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04DE8F  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
04DE94  9A 20 00 23 5E        LCALL  0x5e23, 0x20                 ; UNKNOWN
04DE99  8B C8                 MOV    cx, ax                       ; UNKNOWN
04DE9B  8B 86 E8 FC           MOV    ax, word ptr [bp - 0x318]    ; UNKNOWN
04DE9F  8B DA                 MOV    bx, dx                       ; UNKNOWN
04DEA1  99                    CDQ                                 ; UNKNOWN
04DEA2  03 C1                 ADD    ax, cx                       ; UNKNOWN
04DEA4  13 D3                 ADC    dx, bx                       ; UNKNOWN
04DEA6  89 86 EE FC           MOV    word ptr [bp - 0x312], ax    ; UNKNOWN
04DEAA  89 96 F0 FC           MOV    word ptr [bp - 0x310], dx    ; UNKNOWN
04DEAE  1E                    PUSH   ds                           ; UNKNOWN
04DEAF  C4 5E F8              LES    bx, ptr [bp - 8]             ; UNKNOWN
04DEB2  C4 7E FC              LES    di, ptr [bp - 4]             ; UNKNOWN
04DEB5  C5 76 F4              LDS    si, ptr [bp - 0xc]           ; UNKNOWN
04DEB8  B9 00 03              MOV    cx, 0x300                    ; UNKNOWN
04DEBB  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
04DEBC  26 8A 25              MOV    ah, byte ptr es:[di]         ; UNKNOWN
04DEBF  86 C4                 XCHG   ah, al                       ; UNKNOWN
04DEC1  36 8A 17              MOV    dl, byte ptr ss:[bx]         ; UNKNOWN
04DEC4  43                    INC    bx                           ; UNKNOWN
04DEC5  02 C2                 ADD    al, dl                       ; UNKNOWN
04DEC7  38 E0                 CMP    al, ah                       ; UNKNOWN
