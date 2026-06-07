; ============================================================================
; func_065A22_unknown
; Region   : load_image
; Bytes    : file 0x065A22..0x065A91  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065A22  C8 32 01 00           ENTER  0x132, 0                     ; UNKNOWN
065A26  50                    PUSH   ax                           ; UNKNOWN
065A27  57                    PUSH   di                           ; UNKNOWN
065A28  56                    PUSH   si                           ; UNKNOWN
065A29  B8 11 00              MOV    ax, 0x11                     ; UNKNOWN
065A2C  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
065A2F  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
065A32  2B C0                 SUB    ax, ax                       ; UNKNOWN
065A34  B9 04 00              MOV    cx, 4                        ; UNKNOWN
065A37  8D 7E F4              LEA    di, [bp - 0xc]               ; UNKNOWN
065A3A  16                    PUSH   ss                           ; UNKNOWN
065A3B  07                    POP    es                           ; UNKNOWN
065A3C  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
065A3E  8D 86 CE FE           LEA    ax, [bp - 0x132]             ; UNKNOWN
065A42  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
065A45  8C 56 F6              MOV    word ptr [bp - 0xa], ss      ; UNKNOWN
065A48  16                    PUSH   ss                           ; UNKNOWN
065A49  50                    PUSH   ax                           ; UNKNOWN
065A4A  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
065A4D  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
065A50  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
065A52  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
065A57  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
065A5A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
065A5D  6A 00                 PUSH   0                            ; UNKNOWN
065A5F  2B D2                 SUB    dx, dx                       ; UNKNOWN
065A61  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
065A64  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
065A67  8B 86 CC FE           MOV    ax, word ptr [bp - 0x134]    ; UNKNOWN
065A6B  8D 5E F0              LEA    bx, [bp - 0x10]              ; UNKNOWN
065A6E  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
065A73  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
065A78  8D 86 DE FE           LEA    ax, [bp - 0x122]             ; UNKNOWN
065A7C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
065A7F  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
065A82  8B F8                 MOV    di, ax                       ; UNKNOWN
065A84  8B 4E F8              MOV    cx, word ptr [bp - 8]        ; UNKNOWN
065A87  8B 56 FA              MOV    dx, word ptr [bp - 6]        ; UNKNOWN
065A8A  80 3D FF              CMP    byte ptr [di], 0xff          ; UNKNOWN
065A8D  74 02                 JE     0x65a91                      ; UNKNOWN
065A8F  8B CB                 MOV    cx, bx                       ; UNKNOWN
