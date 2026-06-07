; ============================================================================
; func_0175AA_unknown
; Region   : load_image
; Bytes    : file 0x0175AA..0x0175DD  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0175AA  C8 6E 00 00           ENTER  0x6e, 0                      ; UNKNOWN
0175AE  57                    PUSH   di                           ; UNKNOWN
0175AF  56                    PUSH   si                           ; UNKNOWN
0175B0  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0175B4  7D 03                 JGE    0x175b9                      ; UNKNOWN
0175B6  E9 E8 01              JMP    0x177a1                      ; UNKNOWN
0175B9  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0175BC  C1 F8 03              SAR    ax, 3                        ; UNKNOWN
0175BF  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
0175C2  8B D8                 MOV    bx, ax                       ; UNKNOWN
0175C4  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0175C7  83 E6 07              AND    si, 7                        ; UNKNOWN
0175CA  89 76 AE              MOV    word ptr [bp - 0x52], si     ; UNKNOWN
0175CD  8B C6                 MOV    ax, si                       ; UNKNOWN
0175CF  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0175D2  03 F0                 ADD    si, ax                       ; UNKNOWN
0175D4  F6 80 B0 73 10        TEST   byte ptr [bx + si + 0x73b0], 0x10 ; UNKNOWN
0175D9  74 03                 JE     0x175de                      ; UNKNOWN
0175DB  E9                    DB     0xE9                         ; UNKNOWN (raw)
0175DC  C3                    DB     0xC3                         ; UNKNOWN (raw)
