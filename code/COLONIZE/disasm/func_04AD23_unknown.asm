; ============================================================================
; func_04AD23_unknown
; Region   : load_image
; Bytes    : file 0x04AD23..0x04AD74  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04AD23  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04AD27  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04AD2A  E9 65 01              JMP    0x4ae92                      ; UNKNOWN
04AD2D  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04AD32  EB 03                 JMP    0x4ad37                      ; UNKNOWN
04AD34  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
04AD37  83 7E FC 10           CMP    word ptr [bp - 4], 0x10      ; UNKNOWN
04AD3B  7C 03                 JL     0x4ad40                      ; UNKNOWN
04AD3D  E9 6D 01              JMP    0x4aead                      ; UNKNOWN
04AD40  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04AD43  6A 00                 PUSH   0                            ; UNKNOWN
04AD45  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
04AD48  D1 E3                 SHL    bx, 1                        ; UNKNOWN
04AD4A  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
04AD4E  0E                    PUSH   cs                           ; UNKNOWN
04AD4F  E8 8F DD              CALL   0x48ae1                      ; UNKNOWN
04AD52  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04AD55  EB DD                 JMP    0x4ad34                      ; UNKNOWN
04AD57  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04AD5C  EB 03                 JMP    0x4ad61                      ; UNKNOWN
04AD5E  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
04AD61  83 7E FC 17           CMP    word ptr [bp - 4], 0x17      ; UNKNOWN
04AD65  7C 03                 JL     0x4ad6a                      ; UNKNOWN
04AD67  E9 43 01              JMP    0x4aead                      ; UNKNOWN
04AD6A  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04AD6D  6A 01                 PUSH   1                            ; UNKNOWN
04AD6F  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
04AD72  8B C3                 MOV    ax, bx                       ; UNKNOWN
