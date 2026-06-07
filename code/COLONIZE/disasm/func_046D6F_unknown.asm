; ============================================================================
; func_046D6F_unknown
; Region   : load_image
; Bytes    : file 0x046D6F..0x046D8D  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046D6F  C8 1C 00 00           ENTER  0x1c, 0                      ; UNKNOWN
046D73  53                    PUSH   bx                           ; UNKNOWN
046D74  52                    PUSH   dx                           ; UNKNOWN
046D75  50                    PUSH   ax                           ; UNKNOWN
046D76  56                    PUSH   si                           ; UNKNOWN
046D77  2B C0                 SUB    ax, ax                       ; UNKNOWN
046D79  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
046D7C  A3 DE C5              MOV    word ptr [0xc5de], ax        ; UNKNOWN
046D7F  83 FB 01              CMP    bx, 1                        ; UNKNOWN
046D82  7D 03                 JGE    0x46d87                      ; UNKNOWN
046D84  E9 20 03              JMP    0x470a7                      ; UNKNOWN
046D87  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
046D8A  48                    DEC    ax                           ; UNKNOWN
046D8B  3B C3                 CMP    ax, bx                       ; UNKNOWN
