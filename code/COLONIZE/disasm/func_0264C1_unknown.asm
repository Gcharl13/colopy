; ============================================================================
; func_0264C1_unknown
; Region   : load_image
; Bytes    : file 0x0264C1..0x026577  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0264C1  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
0264C5  50                    PUSH   ax                           ; UNKNOWN
0264C6  57                    PUSH   di                           ; UNKNOWN
0264C7  56                    PUSH   si                           ; UNKNOWN
0264C8  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
0264CB  26 8B 4F 24           MOV    cx, word ptr es:[bx + 0x24]  ; UNKNOWN
0264CF  26 03 4F 48           ADD    cx, word ptr es:[bx + 0x48]  ; UNKNOWN
0264D3  26 03 4F 22           ADD    cx, word ptr es:[bx + 0x22]  ; UNKNOWN
0264D7  89 4E F8              MOV    word ptr [bp - 8], cx        ; UNKNOWN
0264DA  26 8B 57 26           MOV    dx, word ptr es:[bx + 0x26]  ; UNKNOWN
0264DE  89 56 F6              MOV    word ptr [bp - 0xa], dx      ; UNKNOWN
0264E1  26 8B 77 54           MOV    si, word ptr es:[bx + 0x54]  ; UNKNOWN
0264E5  26 8B 7F 56           MOV    di, word ptr es:[bx + 0x56]  ; UNKNOWN
0264E9  89 76 F0              MOV    word ptr [bp - 0x10], si     ; UNKNOWN
0264EC  89 7E F2              MOV    word ptr [bp - 0xe], di      ; UNKNOWN
0264EF  0B C0                 OR     ax, ax                       ; UNKNOWN
0264F1  74 68                 JE     0x2655b                      ; UNKNOWN
0264F3  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0264F7  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
0264FB  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
0264FF  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
026503  26 FF B7 82 00        PUSH   word ptr es:[bx + 0x82]      ; UNKNOWN
026508  26 FF B7 80 00        PUSH   word ptr es:[bx + 0x80]      ; UNKNOWN
02650D  E8 58 F3              CALL   0x25868                      ; UNKNOWN
026510  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026513  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
026516  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46]  ; UNKNOWN
02651A  26 F7 6F 02           IMUL   word ptr es:[bx + 2]         ; UNKNOWN
02651E  50                    PUSH   ax                           ; UNKNOWN
02651F  26 FF 77 10           PUSH   word ptr es:[bx + 0x10]      ; UNKNOWN
026523  26 FF 77 12           PUSH   word ptr es:[bx + 0x12]      ; UNKNOWN
026527  26 FF 77 14           PUSH   word ptr es:[bx + 0x14]      ; UNKNOWN
02652B  26 8A 47 3C           MOV    al, byte ptr es:[bx + 0x3c]  ; UNKNOWN
02652F  50                    PUSH   ax                           ; UNKNOWN
026530  26 8A 47 3E           MOV    al, byte ptr es:[bx + 0x3e]  ; UNKNOWN
026534  50                    PUSH   ax                           ; UNKNOWN
026535  6A 00                 PUSH   0                            ; UNKNOWN
026537  6A 00                 PUSH   0                            ; UNKNOWN
026539  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48]  ; UNKNOWN
02653D  26 8B 4F 20           MOV    cx, word ptr es:[bx + 0x20]  ; UNKNOWN
026541  BB 01 00              MOV    bx, 1                        ; UNKNOWN
026544  2B D8                 SUB    bx, ax                       ; UNKNOWN
026546  8B 76 04              MOV    si, word ptr [bp + 4]        ; UNKNOWN
026549  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02654C  26 2B 44 22           SUB    ax, word ptr es:[si + 0x22]  ; UNKNOWN
026550  48                    DEC    ax                           ; UNKNOWN
026551  D1 E3                 SHL    bx, 1                        ; UNKNOWN
026553  03 D9                 ADD    bx, cx                       ; UNKNOWN
026555  8B 56 F6              MOV    dx, word ptr [bp - 0xa]      ; UNKNOWN
026558  E8 4C E7              CALL   0x24ca7                      ; UNKNOWN
02655B  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
02655E  0B 46 F0              OR     ax, word ptr [bp - 0x10]     ; UNKNOWN
026561  75 03                 JNE    0x26566                      ; UNKNOWN
026563  E9 BC 01              JMP    0x26722                      ; UNKNOWN
026566  C4 5E F0              LES    bx, ptr [bp - 0x10]          ; UNKNOWN
026569  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
02656C  83 E0 02              AND    ax, 2                        ; UNKNOWN
02656F  A3 0A 0A              MOV    word ptr [0xa0a], ax         ; UNKNOWN
026572  C4 76 04              LES    si, ptr [bp + 4]             ; UNKNOWN
026575  8B C3                 MOV    ax, bx                       ; UNKNOWN
