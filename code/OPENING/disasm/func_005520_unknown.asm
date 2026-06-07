; ============================================================================
; func_005520_unknown
; Region   : load_image
; Bytes    : file 0x005520..0x005539  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005520  55                    PUSH   bp ; STACK_PUSH
005521  8B EC                 MOV    bp, sp ; MOV
005523  50                    PUSH   ax ; STACK_PUSH
005524  52                    PUSH   dx ; STACK_PUSH
005525  83 FB FF              CMP    bx, -1 ; CMP
005528  74 10                 JE     0x553a ; CJUMP
00552A  B8 00 44              MOV    ax, 0x4400 ; CONST_LOAD
00552D  CD 21                 INT    0x21 ; SYS
00552F  72 0F                 JB     0x5540 ; CJUMP
005531  0A D2                 OR     dl, dl ; LOGIC
005533  79 0B                 JNS    0x5540 ; CJUMP
005535  F6 C2 03              TEST   dl, 3 ; LOGIC
005538  74                    DB     0x74 ; DATA_BYTE
