; ============================================================================
; func_06B042_unknown
; Region   : load_image
; Bytes    : file 0x06B042..0x06B0AB  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B042  55                    PUSH   bp                           ; UNKNOWN
06B043  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B045  83 EC 04              SUB    sp, 4                        ; UNKNOWN
06B048  32 FF                 XOR    bh, bh                       ; UNKNOWN
06B04A  88 7E FE              MOV    byte ptr [bp - 2], bh        ; UNKNOWN
06B04D  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06B050  8B C8                 MOV    cx, ax                       ; UNKNOWN
06B052  C6 46 FC 00           MOV    byte ptr [bp - 4], 0         ; UNKNOWN
06B056  A9 00 80              TEST   ax, 0x8000                   ; UNKNOWN
06B059  75 10                 JNE    0x6b06b                      ; UNKNOWN
06B05B  A9 00 40              TEST   ax, 0x4000                   ; UNKNOWN
06B05E  75 07                 JNE    0x6b067                      ; UNKNOWN
06B060  F6 06 8B 15 80        TEST   byte ptr [0x158b], 0x80      ; UNKNOWN
06B065  75 04                 JNE    0x6b06b                      ; UNKNOWN
06B067  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80      ; UNKNOWN
06B06B  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
06B06E  24 03                 AND    al, 3                        ; UNKNOWN
06B070  0A C7                 OR     al, bh                       ; UNKNOWN
06B072  B4 3D                 MOV    ah, 0x3d                     ; UNKNOWN
06B074  CD 21                 INT    0x21                         ; UNKNOWN
06B076  73 12                 JAE    0x6b08a                      ; UNKNOWN
06B078  3D 02 00              CMP    ax, 2                        ; UNKNOWN
06B07B  75 09                 JNE    0x6b086                      ; UNKNOWN
06B07D  F7 C1 00 01           TEST   cx, 0x100                    ; UNKNOWN
06B081  74 03                 JE     0x6b086                      ; UNKNOWN
06B083  E9 9F 00              JMP    0x6b125                      ; UNKNOWN
06B086  F9                    STC                                 ; UNKNOWN
06B087  E9 E7 ED              JMP    0x69e71                      ; UNKNOWN
06B08A  93                    XCHG   bx, ax                       ; UNKNOWN
06B08B  8B C1                 MOV    ax, cx                       ; UNKNOWN
06B08D  25 00 05              AND    ax, 0x500                    ; UNKNOWN
06B090  3D 00 05              CMP    ax, 0x500                    ; UNKNOWN
06B093  75 09                 JNE    0x6b09e                      ; UNKNOWN
06B095  B4 3E                 MOV    ah, 0x3e                     ; UNKNOWN
06B097  CD 21                 INT    0x21                         ; UNKNOWN
06B099  B8 00 11              MOV    ax, 0x1100                   ; UNKNOWN
06B09C  EB E8                 JMP    0x6b086                      ; UNKNOWN
06B09E  C6 46 FD 01           MOV    byte ptr [bp - 3], 1         ; UNKNOWN
06B0A2  B8 00 44              MOV    ax, 0x4400                   ; UNKNOWN
06B0A5  CD 21                 INT    0x21                         ; UNKNOWN
06B0A7  F6 C2 80              TEST   dl, 0x80                     ; UNKNOWN
06B0AA  74                    DB     0x74                         ; UNKNOWN (raw)
