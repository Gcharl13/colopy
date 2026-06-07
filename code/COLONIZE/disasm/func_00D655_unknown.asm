; ============================================================================
; func_00D655_unknown
; Region   : load_image
; Bytes    : file 0x00D655..0x00D73F  (234 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D655  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
00D659  56                    PUSH   si                           ; UNKNOWN
00D65A  68 32 0A              PUSH   0xa32                        ; UNKNOWN
00D65D  68 A0 82              PUSH   0x82a0                       ; UNKNOWN
00D660  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00D665  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D668  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00D66B  A3 00 3E              MOV    word ptr [0x3e00], ax        ; UNKNOWN
00D66E  C7 06 FA 3D 00 C6     MOV    word ptr [0x3dfa], 0xc600    ; UNKNOWN
00D674  C7 06 FE 3D 0E 00     MOV    word ptr [0x3dfe], 0xe       ; UNKNOWN
00D67A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00D67D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00D680  A3 1C 0F              MOV    word ptr [0xf1c], ax         ; UNKNOWN
00D683  A3 1A 0F              MOV    word ptr [0xf1a], ax         ; UNKNOWN
00D686  A3 1E 0F              MOV    word ptr [0xf1e], ax         ; UNKNOWN
00D689  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
00D68C  A3 1C 3E              MOV    word ptr [0x3e1c], ax        ; UNKNOWN
00D68F  A3 4A 3E              MOV    word ptr [0x3e4a], ax        ; UNKNOWN
00D692  A3 4C 3E              MOV    word ptr [0x3e4c], ax        ; UNKNOWN
00D695  A3 4E 3E              MOV    word ptr [0x3e4e], ax        ; UNKNOWN
00D698  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D69A  A3 0C 3E              MOV    word ptr [0x3e0c], ax        ; UNKNOWN
00D69D  A3 0E 3E              MOV    word ptr [0x3e0e], ax        ; UNKNOWN
00D6A0  A3 18 3E              MOV    word ptr [0x3e18], ax        ; UNKNOWN
00D6A3  A3 1A 3E              MOV    word ptr [0x3e1a], ax        ; UNKNOWN
00D6A6  A3 F8 3D              MOV    word ptr [0x3df8], ax        ; UNKNOWN
00D6A9  A3 48 3E              MOV    word ptr [0x3e48], ax        ; UNKNOWN
00D6AC  A3 50 3E              MOV    word ptr [0x3e50], ax        ; UNKNOWN
00D6AF  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
00D6B2  EB 0E                 JMP    0xd6c2                       ; UNKNOWN
00D6B4  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
00D6B7  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00D6B9  C7 87 40 3E FF FF     MOV    word ptr [bx + 0x3e40], 0xffff ; UNKNOWN
00D6BF  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
00D6C2  83 7E F6 04           CMP    word ptr [bp - 0xa], 4       ; UNKNOWN
00D6C6  7C EC                 JL     0xd6b4                       ; UNKNOWN
00D6C8  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
00D6CD  68 E8 03              PUSH   0x3e8                        ; UNKNOWN
00D6D0  68 58 02              PUSH   0x258                        ; UNKNOWN
00D6D3  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
00D6D8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00D6DB  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
00D6DE  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00D6E0  89 87 62 3E           MOV    word ptr [bx + 0x3e62], ax   ; UNKNOWN
00D6E4  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
00D6E7  83 7E F6 10           CMP    word ptr [bp - 0xa], 0x10    ; UNKNOWN
00D6EB  7C E0                 JL     0xd6cd                       ; UNKNOWN
00D6ED  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
00D6F2  2B C0                 SUB    ax, ax                       ; UNKNOWN
00D6F4  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
00D6F7  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00D6F9  89 87 52 3E           MOV    word ptr [bx + 0x3e52], ax   ; UNKNOWN
00D6FD  89 87 5A 3E           MOV    word ptr [bx + 0x3e5a], ax   ; UNKNOWN
00D701  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
00D704  83 7E F6 04           CMP    word ptr [bp - 0xa], 4       ; UNKNOWN
00D708  7C E8                 JL     0xd6f2                       ; UNKNOWN
00D70A  6A 04                 PUSH   4                            ; UNKNOWN
00D70C  50                    PUSH   ax                           ; UNKNOWN
00D70D  68 82 3E              PUSH   0x3e82                       ; UNKNOWN
00D710  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
00D715  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00D718  0E                    PUSH   cs                           ; UNKNOWN
00D719  E8 95 EC              CALL   0xc3b1                       ; UNKNOWN
00D71C  0B C0                 OR     ax, ax                       ; UNKNOWN
00D71E  74 03                 JE     0xd723                       ; UNKNOWN
00D720  E9 11 03              JMP    0xda34                       ; UNKNOWN
00D723  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
00D726  2A E4                 SUB    ah, ah                       ; UNKNOWN
00D728  8B C8                 MOV    cx, ax                       ; UNKNOWN
00D72A  C1 E0 03              SHL    ax, 3                        ; UNKNOWN
00D72D  83 C0 0F              ADD    ax, 0xf                      ; UNKNOWN
00D730  A3 52 3E              MOV    word ptr [0x3e52], ax        ; UNKNOWN
00D733  8B C1                 MOV    ax, cx                       ; UNKNOWN
00D735  41                    INC    cx                           ; UNKNOWN
00D736  8B D1                 MOV    dx, cx                       ; UNKNOWN
00D738  C1 E1 02              SHL    cx, 2                        ; UNKNOWN
00D73B  03 CA                 ADD    cx, dx                       ; UNKNOWN
00D73D  89                    DB     0x89                         ; UNKNOWN (raw)
00D73E  0E                    DB     0x0E                         ; UNKNOWN (raw)
