; ============================================================================
; func_0229FD_unknown
; Region   : load_image
; Bytes    : file 0x0229FD..0x022A54  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0229FD  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
022A01  50                    PUSH   ax                           ; UNKNOWN
022A02  57                    PUSH   di                           ; UNKNOWN
022A03  56                    PUSH   si                           ; UNKNOWN
022A04  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
022A07  2B C0                 SUB    ax, ax                       ; UNKNOWN
022A09  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
022A0C  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
022A0F  26 89 05              MOV    word ptr es:[di], ax         ; UNKNOWN
022A12  39 06 E6 0E           CMP    word ptr [0xee6], ax         ; UNKNOWN
022A16  74 78                 JE     0x22a90                      ; UNKNOWN
022A18  26 FF 75 2A           PUSH   word ptr es:[di + 0x2a]      ; UNKNOWN
022A1C  26 FF 75 28           PUSH   word ptr es:[di + 0x28]      ; UNKNOWN
022A20  8C C6                 MOV    si, es                       ; UNKNOWN
022A22  E8 4D EC              CALL   0x21672                      ; UNKNOWN
022A25  83 C4 04              ADD    sp, 4                        ; UNKNOWN
022A28  8E C6                 MOV    es, si                       ; UNKNOWN
022A2A  26 8B 75 04           MOV    si, word ptr es:[di + 4]     ; UNKNOWN
022A2E  03 F0                 ADD    si, ax                       ; UNKNOWN
022A30  46                    INC    si                           ; UNKNOWN
022A31  3B 36 E4 0E           CMP    si, word ptr [0xee4]         ; UNKNOWN
022A35  7C 59                 JL     0x22a90                      ; UNKNOWN
022A37  2B C9                 SUB    cx, cx                       ; UNKNOWN
022A39  26 C5 75 38           LDS    si, ptr es:[di + 0x38]       ; UNKNOWN
022A3D  8C D8                 MOV    ax, ds                       ; UNKNOWN
022A3F  0B C6                 OR     ax, si                       ; UNKNOWN
022A41  74 27                 JE     0x22a6a                      ; UNKNOWN
022A43  36 8B 1E E2 0E        MOV    bx, word ptr ss:[0xee2]      ; UNKNOWN
022A48  0B C9                 OR     cx, cx                       ; UNKNOWN
022A4A  75 1E                 JNE    0x22a6a                      ; UNKNOWN
022A4C  8B 44 02              MOV    ax, word ptr [si + 2]        ; UNKNOWN
022A4F  03 44 04              ADD    ax, word ptr [si + 4]        ; UNKNOWN
022A52  3B C3                 CMP    ax, bx                       ; UNKNOWN
