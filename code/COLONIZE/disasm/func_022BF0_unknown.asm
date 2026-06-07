; ============================================================================
; func_022BF0_unknown
; Region   : load_image
; Bytes    : file 0x022BF0..0x022C95  (165 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022BF0  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
022BF4  57                    PUSH   di                           ; UNKNOWN
022BF5  56                    PUSH   si                           ; UNKNOWN
022BF6  B8 01 00              MOV    ax, 1                        ; UNKNOWN
022BF9  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
022BFC  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
022BFF  8D 46 FF              LEA    ax, [bp - 1]                 ; UNKNOWN
022C02  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
022C05  8C 56 F8              MOV    word ptr [bp - 8], ss        ; UNKNOWN
022C08  8D 1E A4 18           LEA    bx, [0x18a4]                 ; UNKNOWN
022C0C  2B C0                 SUB    ax, ax                       ; UNKNOWN
022C0E  9A 04 00 61 5D        LCALL  0x5d61, 4                    ; UNKNOWN
022C13  8B F0                 MOV    si, ax                       ; UNKNOWN
022C15  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
022C18  0B D0                 OR     dx, ax                       ; UNKNOWN
022C1A  75 03                 JNE    0x22c1f                      ; UNKNOWN
022C1C  E9 D0 00              JMP    0x22cef                      ; UNKNOWN
022C1F  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
022C22  50                    PUSH   ax                           ; UNKNOWN
022C23  56                    PUSH   si                           ; UNKNOWN
022C24  6A 00                 PUSH   0                            ; UNKNOWN
022C26  8B F8                 MOV    di, ax                       ; UNKNOWN
022C28  B8 01 00              MOV    ax, 1                        ; UNKNOWN
022C2B  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
022C2E  2B D2                 SUB    dx, dx                       ; UNKNOWN
022C30  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
022C35  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
022C38  2A E4                 SUB    ah, ah                       ; UNKNOWN
022C3A  A3 B8 09              MOV    word ptr [0x9b8], ax         ; UNKNOWN
022C3D  A3 BC 09              MOV    word ptr [0x9bc], ax         ; UNKNOWN
022C40  57                    PUSH   di                           ; UNKNOWN
022C41  56                    PUSH   si                           ; UNKNOWN
022C42  6A 00                 PUSH   0                            ; UNKNOWN
022C44  B8 02 00              MOV    ax, 2                        ; UNKNOWN
022C47  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
022C4A  2B D2                 SUB    dx, dx                       ; UNKNOWN
022C4C  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
022C51  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
022C54  2A E4                 SUB    ah, ah                       ; UNKNOWN
022C56  A3 BA 09              MOV    word ptr [0x9ba], ax         ; UNKNOWN
022C59  A3 BE 09              MOV    word ptr [0x9be], ax         ; UNKNOWN
022C5C  57                    PUSH   di                           ; UNKNOWN
022C5D  56                    PUSH   si                           ; UNKNOWN
022C5E  6A 00                 PUSH   0                            ; UNKNOWN
022C60  B8 03 00              MOV    ax, 3                        ; UNKNOWN
022C63  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
022C66  2B D2                 SUB    dx, dx                       ; UNKNOWN
022C68  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
022C6D  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
022C70  2A E4                 SUB    ah, ah                       ; UNKNOWN
022C72  A3 C4 09              MOV    word ptr [0x9c4], ax         ; UNKNOWN
022C75  A3 C0 09              MOV    word ptr [0x9c0], ax         ; UNKNOWN
022C78  57                    PUSH   di                           ; UNKNOWN
022C79  56                    PUSH   si                           ; UNKNOWN
022C7A  6A 00                 PUSH   0                            ; UNKNOWN
022C7C  B8 04 00              MOV    ax, 4                        ; UNKNOWN
022C7F  8D 5E F2              LEA    bx, [bp - 0xe]               ; UNKNOWN
022C82  2B D2                 SUB    dx, dx                       ; UNKNOWN
022C84  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
022C89  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
022C8C  2A E4                 SUB    ah, ah                       ; UNKNOWN
022C8E  A3 C6 09              MOV    word ptr [0x9c6], ax         ; UNKNOWN
022C91  A3 C2 09              MOV    word ptr [0x9c2], ax         ; UNKNOWN
022C94  57                    PUSH   di                           ; UNKNOWN
