; ============================================================================
; func_02304B_unknown
; Region   : load_image
; Bytes    : file 0x02304B..0x0230A1  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02304B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02304F  57                    PUSH   di                           ; UNKNOWN
023050  56                    PUSH   si                           ; UNKNOWN
023051  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
023054  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
023057  0E                    PUSH   cs                           ; UNKNOWN
023058  E8 6E FD              CALL   0x22dc9                      ; UNKNOWN
02305B  8B C6                 MOV    ax, si                       ; UNKNOWN
02305D  3B 36 B0 3E           CMP    si, word ptr [0x3eb0]        ; UNKNOWN
023061  7D 04                 JGE    0x23067                      ; UNKNOWN
023063  8B 36 B0 3E           MOV    si, word ptr [0x3eb0]        ; UNKNOWN
023067  89 76 FE              MOV    word ptr [bp - 2], si        ; UNKNOWN
02306A  03 46 0C              ADD    ax, word ptr [bp + 0xc]      ; UNKNOWN
02306D  48                    DEC    ax                           ; UNKNOWN
02306E  8B 0E B0 3E           MOV    cx, word ptr [0x3eb0]        ; UNKNOWN
023072  83 C1 26              ADD    cx, 0x26                     ; UNKNOWN
023075  3B C1                 CMP    ax, cx                       ; UNKNOWN
023077  7E 02                 JLE    0x2307b                      ; UNKNOWN
023079  8B C1                 MOV    ax, cx                       ; UNKNOWN
02307B  2B C6                 SUB    ax, si                       ; UNKNOWN
02307D  40                    INC    ax                           ; UNKNOWN
02307E  79 02                 JNS    0x23082                      ; UNKNOWN
023080  2B C0                 SUB    ax, ax                       ; UNKNOWN
023082  89 46 0C              MOV    word ptr [bp + 0xc], ax      ; UNKNOWN
023085  8B C7                 MOV    ax, di                       ; UNKNOWN
023087  03 7E 0A              ADD    di, word ptr [bp + 0xa]      ; UNKNOWN
02308A  3B 06 B2 3E           CMP    ax, word ptr [0x3eb2]        ; UNKNOWN
02308E  7D 03                 JGE    0x23093                      ; UNKNOWN
023090  A1 B2 3E              MOV    ax, word ptr [0x3eb2]        ; UNKNOWN
023093  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
023096  8D 4D FF              LEA    cx, [di - 1]                 ; UNKNOWN
023099  8B 16 B2 3E           MOV    dx, word ptr [0x3eb2]        ; UNKNOWN
02309D  83 C2 37              ADD    dx, 0x37                     ; UNKNOWN
0230A0  3B                    DB     0x3B                         ; UNKNOWN (raw)
