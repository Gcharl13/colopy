; ============================================================================
; func_05C1FF_unknown
; Region   : load_image
; Bytes    : file 0x05C1FF..0x05C258  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C1FF  C8 56 00 00           ENTER  0x56, 0                      ; UNKNOWN
05C203  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
05C206  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
05C209  68 EE 2D              PUSH   0x2dee                       ; UNKNOWN
05C20C  68 86 09              PUSH   0x986                        ; UNKNOWN
05C20F  9A 24 00 09 45        LCALL  0x4509, 0x24                 ; UNKNOWN
05C214  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05C217  0B C0                 OR     ax, ax                       ; UNKNOWN
05C219  75 27                 JNE    0x5c242                      ; UNKNOWN
05C21B  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
05C21F  1B C0                 SBB    ax, ax                       ; UNKNOWN
05C221  83 E0 01              AND    ax, 1                        ; UNKNOWN
05C224  40                    INC    ax                           ; UNKNOWN
05C225  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
05C228  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0      ; UNKNOWN
05C22D  EB 0B                 JMP    0x5c23a                      ; UNKNOWN
05C22F  9A 0F 01 09 45        LCALL  0x4509, 0x10f                ; UNKNOWN
05C234  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
05C237  FF 46 AC              INC    word ptr [bp - 0x54]         ; UNKNOWN
05C23A  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
05C23D  39 46 AE              CMP    word ptr [bp - 0x52], ax     ; UNKNOWN
05C240  7F ED                 JG     0x5c22f                      ; UNKNOWN
05C242  1E                    PUSH   ds                           ; UNKNOWN
05C243  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
05C246  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05C249  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
05C24E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
05C251  9A 0A 00 09 45        LCALL  0x4509, 0xa                  ; UNKNOWN
05C256  C9                    LEAVE                               ; UNKNOWN
05C257  CB                    RETF                                ; UNKNOWN
