; ============================================================================
; func_030645_unknown
; Region   : load_image
; Bytes    : file 0x030645..0x0306C3  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030645  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
030649  56                    PUSH   si                           ; UNKNOWN
03064A  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
03064F  EB 50                 JMP    0x306a1                      ; UNKNOWN
030651  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030654  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030657  0E                    PUSH   cs                           ; UNKNOWN
030658  E8 27 FF              CALL   0x30582                      ; UNKNOWN
03065B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03065E  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
030661  75 3B                 JNE    0x3069e                      ; UNKNOWN
030663  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
030666  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030669  0E                    PUSH   cs                           ; UNKNOWN
03066A  E8 62 FF              CALL   0x305cf                      ; UNKNOWN
03066D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030670  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
030673  83 E8 64              SUB    ax, 0x64                     ; UNKNOWN
030676  F7 D8                 NEG    ax                           ; UNKNOWN
030678  0B C0                 OR     ax, ax                       ; UNKNOWN
03067A  74 22                 JE     0x3069e                      ; UNKNOWN
03067C  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
03067F  7E 03                 JLE    0x30684                      ; UNKNOWN
030681  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
030684  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030687  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
03068A  50                    PUSH   ax                           ; UNKNOWN
03068B  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03068E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030691  0E                    PUSH   cs                           ; UNKNOWN
030692  E8 4E FF              CALL   0x305e3                      ; UNKNOWN
030695  83 C4 06              ADD    sp, 6                        ; UNKNOWN
030698  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03069B  29 46 0A              SUB    word ptr [bp + 0xa], ax      ; UNKNOWN
03069E  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
0306A1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0306A5  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
0306A9  2A E4                 SUB    ah, ah                       ; UNKNOWN
0306AB  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
0306AE  7F A1                 JG     0x30651                      ; UNKNOWN
0306B0  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0306B4  74 4D                 JE     0x30703                      ; UNKNOWN
0306B6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0306BA  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
0306BE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0306C1  8B CB                 MOV    cx, bx                       ; UNKNOWN
