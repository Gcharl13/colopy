; ============================================================================
; func_037623_unknown
; Region   : load_image
; Bytes    : file 0x037623..0x037706  (227 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037623  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
037627  57                    PUSH   di                           ; UNKNOWN
037628  56                    PUSH   si                           ; UNKNOWN
037629  2B C0                 SUB    ax, ax                       ; UNKNOWN
03762B  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
03762E  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
037631  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
037635  8A 47 06              MOV    al, byte ptr [bx + 6]        ; UNKNOWN
037638  2A E4                 SUB    ah, ah                       ; UNKNOWN
03763A  8A 0E 1E 3E           MOV    cl, byte ptr [0x3e1e]        ; UNKNOWN
03763E  2A ED                 SUB    ch, ch                       ; UNKNOWN
037640  03 C1                 ADD    ax, cx                       ; UNKNOWN
037642  83 C0 07              ADD    ax, 7                        ; UNKNOWN
037645  6B C0 14              IMUL   ax, ax, 0x14                 ; UNKNOWN
037648  B9 05 00              MOV    cx, 5                        ; UNKNOWN
03764B  8B F0                 MOV    si, ax                       ; UNKNOWN
03764D  99                    CDQ                                 ; UNKNOWN
03764E  F7 F9                 IDIV   cx                           ; UNKNOWN
037650  83 F8 64              CMP    ax, 0x64                     ; UNKNOWN
037653  7D 03                 JGE    0x37658                      ; UNKNOWN
037655  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
037658  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03765B  8B 47 30              MOV    ax, word ptr [bx + 0x30]     ; UNKNOWN
03765E  99                    CDQ                                 ; UNKNOWN
03765F  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
037662  8B F9                 MOV    di, cx                       ; UNKNOWN
037664  2B C8                 SUB    cx, ax                       ; UNKNOWN
037666  1B FA                 SBB    di, dx                       ; UNKNOWN
037668  57                    PUSH   di                           ; UNKNOWN
037669  51                    PUSH   cx                           ; UNKNOWN
03766A  8B C6                 MOV    ax, si                       ; UNKNOWN
03766C  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
03766F  F7 6F 2E              IMUL   word ptr [bx + 0x2e]         ; UNKNOWN
037672  52                    PUSH   dx                           ; UNKNOWN
037673  50                    PUSH   ax                           ; UNKNOWN
037674  9A D2 11 65 5F        LCALL  0x5f65, 0x11d2               ; UNKNOWN
037679  03 F0                 ADD    si, ax                       ; UNKNOWN
03767B  89 76 A4              MOV    word ptr [bp - 0x5c], si     ; UNKNOWN
03767E  8B C6                 MOV    ax, si                       ; UNKNOWN
037680  83 F8 0A              CMP    ax, 0xa                      ; UNKNOWN
037683  7D 03                 JGE    0x37688                      ; UNKNOWN
037685  B8 0A 00              MOV    ax, 0xa                      ; UNKNOWN
037688  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
03768B  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03768F  75 06                 JNE    0x37697                      ; UNKNOWN
037691  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
037695  74 05                 JE     0x3769c                      ; UNKNOWN
037697  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0      ; UNKNOWN
03769C  8B 46 A4              MOV    ax, word ptr [bp - 0x5c]     ; UNKNOWN
03769F  99                    CDQ                                 ; UNKNOWN
0376A0  A3 2A 3F              MOV    word ptr [0x3f2a], ax        ; UNKNOWN
0376A3  89 16 2C 3F           MOV    word ptr [0x3f2c], dx        ; UNKNOWN
0376A7  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0376AB  74 10                 JE     0x376bd                      ; UNKNOWN
0376AD  C7 06 06 0A 03 00     MOV    word ptr [0xa06], 3          ; UNKNOWN
0376B3  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0376B7  8D 06 1A 21           LEA    ax, [0x211a]                 ; UNKNOWN
0376BB  EB 38                 JMP    0x376f5                      ; UNKNOWN
0376BD  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0376C1  74 24                 JE     0x376e7                      ; UNKNOWN
0376C3  C7 06 06 0A 04 00     MOV    word ptr [0xa06], 4          ; UNKNOWN
0376C9  8B 1E 9A 79           MOV    bx, word ptr [0x799a]        ; UNKNOWN
0376CD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0376CF  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
0376D3  6A 00                 PUSH   0                            ; UNKNOWN
0376D5  9A E4 03 97 1B        LCALL  0x1b97, 0x3e4                ; UNKNOWN
0376DA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0376DD  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0376E1  8D 06 24 21           LEA    ax, [0x2124]                 ; UNKNOWN
0376E5  EB 0E                 JMP    0x376f5                      ; UNKNOWN
0376E7  C7 06 06 0A 02 00     MOV    word ptr [0xa06], 2          ; UNKNOWN
0376ED  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0376F1  8D 06 32 21           LEA    ax, [0x2132]                 ; UNKNOWN
0376F5  2B D2                 SUB    dx, dx                       ; UNKNOWN
0376F7  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
0376FC  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
0376FF  89 56 A8              MOV    word ptr [bp - 0x58], dx     ; UNKNOWN
037702  8B C2                 MOV    ax, dx                       ; UNKNOWN
037704  0B                    DB     0x0B                         ; UNKNOWN (raw)
037705  46                    DB     0x46                         ; UNKNOWN (raw)
