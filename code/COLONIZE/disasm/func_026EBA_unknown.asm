; ============================================================================
; func_026EBA_unknown
; Region   : load_image
; Bytes    : file 0x026EBA..0x026FB4  (250 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026EBA  C8 38 00 00           ENTER  0x38, 0                      ; UNKNOWN
026EBE  56                    PUSH   si                           ; UNKNOWN
026EBF  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
026EC4  83 3E 04 0A 07        CMP    word ptr [0xa04], 7          ; UNKNOWN
026EC9  7E 05                 JLE    0x26ed0                      ; UNKNOWN
026ECB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
026ECE  EB 02                 JMP    0x26ed2                      ; UNKNOWN
026ED0  2B C0                 SUB    ax, ax                       ; UNKNOWN
026ED2  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
026ED5  2B C0                 SUB    ax, ax                       ; UNKNOWN
026ED7  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
026EDA  A3 10 0A              MOV    word ptr [0xa10], ax         ; UNKNOWN
026EDD  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026EE0  26 F6 47 0A 10        TEST   byte ptr es:[bx + 0xa], 0x10 ; UNKNOWN
026EE5  74 08                 JE     0x26eef                      ; UNKNOWN
026EE7  C7 06 1A 0A 01 00     MOV    word ptr [0xa1a], 1          ; UNKNOWN
026EED  EB 03                 JMP    0x26ef2                      ; UNKNOWN
026EEF  A3 1A 0A              MOV    word ptr [0xa1a], ax         ; UNKNOWN
026EF2  A3 0A 0A              MOV    word ptr [0xa0a], ax         ; UNKNOWN
026EF5  9A 0A 00 09 45        LCALL  0x4509, 0xa                  ; UNKNOWN
026EFA  EB 05                 JMP    0x26f01                      ; UNKNOWN
026EFC  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
026F01  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
026F06  0B C0                 OR     ax, ax                       ; UNKNOWN
026F08  75 F2                 JNE    0x26efc                      ; UNKNOWN
026F0A  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026F0D  26 F6 47 0A 04        TEST   byte ptr es:[bx + 0xa], 4    ; UNKNOWN
026F12  74 2D                 JE     0x26f41                      ; UNKNOWN
026F14  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
026F17  EB 1C                 JMP    0x26f35                      ; UNKNOWN
026F19  8B C8                 MOV    cx, ax                       ; UNKNOWN
026F1B  2A ED                 SUB    ch, ch                       ; UNKNOWN
026F1D  BA 01 00              MOV    dx, 1                        ; UNKNOWN
026F20  D3 E2                 SHL    dx, cl                       ; UNKNOWN
026F22  23 16 FC 09           AND    dx, word ptr [0x9fc]         ; UNKNOWN
026F26  52                    PUSH   dx                           ; UNKNOWN
026F27  40                    INC    ax                           ; UNKNOWN
026F28  50                    PUSH   ax                           ; UNKNOWN
026F29  06                    PUSH   es                           ; UNKNOWN
026F2A  53                    PUSH   bx                           ; UNKNOWN
026F2B  0E                    PUSH   cs                           ; UNKNOWN
026F2C  E8 E3 E3              CALL   0x25312                      ; UNKNOWN
026F2F  83 C4 08              ADD    sp, 8                        ; UNKNOWN
026F32  FF 46 DE              INC    word ptr [bp - 0x22]         ; UNKNOWN
026F35  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
026F38  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026F3B  26 39 47 02           CMP    word ptr es:[bx + 2], ax     ; UNKNOWN
026F3F  7F D8                 JG     0x26f19                      ; UNKNOWN
026F41  26 C7 07 00 00        MOV    word ptr es:[bx], 0          ; UNKNOWN
026F46  26 FF B7 82 00        PUSH   word ptr es:[bx + 0x82]      ; UNKNOWN
026F4B  26 FF B7 80 00        PUSH   word ptr es:[bx + 0x80]      ; UNKNOWN
026F50  E8 15 E9              CALL   0x25868                      ; UNKNOWN
026F53  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026F56  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026F59  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46]  ; UNKNOWN
026F5D  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
026F60  83 3E 04 0A 00        CMP    word ptr [0xa04], 0          ; UNKNOWN
026F65  7C 05                 JL     0x26f6c                      ; UNKNOWN
026F67  06                    PUSH   es                           ; UNKNOWN
026F68  53                    PUSH   bx                           ; UNKNOWN
026F69  E8 45 DA              CALL   0x249b1                      ; UNKNOWN
026F6C  83 3E 06 0A 00        CMP    word ptr [0xa06], 0          ; UNKNOWN
026F71  7C 09                 JL     0x26f7c                      ; UNKNOWN
026F73  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026F76  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026F79  E8 B3 DA              CALL   0x24a2f                      ; UNKNOWN
026F7C  83 3E 08 0A 00        CMP    word ptr [0xa08], 0          ; UNKNOWN
026F81  7C 09                 JL     0x26f8c                      ; UNKNOWN
026F83  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026F86  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026F89  E8 CC DA              CALL   0x24a58                      ; UNKNOWN
026F8C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026F8F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026F92  E8 EC DA              CALL   0x24a81                      ; UNKNOWN
026F95  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026F98  26 8B 47 6A           MOV    ax, word ptr es:[bx + 0x6a]  ; UNKNOWN
026F9C  26 0B 47 68           OR     ax, word ptr es:[bx + 0x68]  ; UNKNOWN
026FA0  74 20                 JE     0x26fc2                      ; UNKNOWN
026FA2  26 8B 47 68           MOV    ax, word ptr es:[bx + 0x68]  ; UNKNOWN
026FA6  26 8B 57 6A           MOV    dx, word ptr es:[bx + 0x6a]  ; UNKNOWN
026FAA  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
026FAD  89 56 EC              MOV    word ptr [bp - 0x14], dx     ; UNKNOWN
026FB0  8E C2                 MOV    es, dx                       ; UNKNOWN
026FB2  8B D8                 MOV    bx, ax                       ; UNKNOWN
