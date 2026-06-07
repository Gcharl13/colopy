; ============================================================================
; func_03B657_unknown
; Region   : load_image
; Bytes    : file 0x03B657..0x03B6C0  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B657  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03B65B  9A A1 36 97 1B        LCALL  0x1b97, 0x36a1               ; UNKNOWN
03B660  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03B665  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03B668  8B C8                 MOV    cx, ax                       ; UNKNOWN
03B66A  40                    INC    ax                           ; UNKNOWN
03B66B  2A ED                 SUB    ch, ch                       ; UNKNOWN
03B66D  BA 01 00              MOV    dx, 1                        ; UNKNOWN
03B670  D3 E2                 SHL    dx, cl                       ; UNKNOWN
03B672  23 16 A8 09           AND    dx, word ptr [0x9a8]         ; UNKNOWN
03B676  9A A8 36 97 1B        LCALL  0x1b97, 0x36a8               ; UNKNOWN
03B67B  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03B67E  83 7E FE 07           CMP    word ptr [bp - 2], 7         ; UNKNOWN
03B682  7C E1                 JL     0x3b665                      ; UNKNOWN
03B684  8D 1E F8 23           LEA    bx, [0x23f8]                 ; UNKNOWN
03B688  8D 06 F0 23           LEA    ax, [0x23f0]                 ; UNKNOWN
03B68C  2B D2                 SUB    dx, dx                       ; UNKNOWN
03B68E  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
03B693  2B C0                 SUB    ax, ax                       ; UNKNOWN
03B695  A3 A8 09              MOV    word ptr [0x9a8], ax         ; UNKNOWN
03B698  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03B69B  EB 1B                 JMP    0x3b6b8                      ; UNKNOWN
03B69D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03B6A0  40                    INC    ax                           ; UNKNOWN
03B6A1  9A D1 36 97 1B        LCALL  0x1b97, 0x36d1               ; UNKNOWN
03B6A6  83 F8 01              CMP    ax, 1                        ; UNKNOWN
03B6A9  1B C0                 SBB    ax, ax                       ; UNKNOWN
03B6AB  40                    INC    ax                           ; UNKNOWN
03B6AC  8A 4E FE              MOV    cl, byte ptr [bp - 2]        ; UNKNOWN
03B6AF  D3 E0                 SHL    ax, cl                       ; UNKNOWN
03B6B1  09 06 A8 09           OR     word ptr [0x9a8], ax         ; UNKNOWN
03B6B5  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
03B6B8  83 7E FE 07           CMP    word ptr [bp - 2], 7         ; UNKNOWN
03B6BC  7C DF                 JL     0x3b69d                      ; UNKNOWN
03B6BE  C9                    LEAVE                               ; UNKNOWN
03B6BF  CB                    RETF                                ; UNKNOWN
