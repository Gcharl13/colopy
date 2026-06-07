; ============================================================================
; func_00E83E_unknown
; Region   : load_image
; Bytes    : file 0x00E83E..0x00E872  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E83E  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
00E842  A1 52 05              MOV    ax, word ptr [0x552]         ; UNKNOWN
00E845  0B C0                 OR     ax, ax                       ; UNKNOWN
00E847  7E 27                 JLE    0xe870                       ; UNKNOWN
00E849  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
00E84E  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00E851  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E854  8B 87 5E 05           MOV    ax, word ptr [bx + 0x55e]    ; UNKNOWN
00E858  89 87 7E 05           MOV    word ptr [bx + 0x57e], ax    ; UNKNOWN
00E85C  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E85F  8B 87 60 05           MOV    ax, word ptr [bx + 0x560]    ; UNKNOWN
00E863  89 87 80 05           MOV    word ptr [bx + 0x580], ax    ; UNKNOWN
00E867  83 46 FA 04           ADD    word ptr [bp - 6], 4         ; UNKNOWN
00E86B  FF 4E F8              DEC    word ptr [bp - 8]            ; UNKNOWN
00E86E  75 E1                 JNE    0xe851                       ; UNKNOWN
00E870  C9                    LEAVE                               ; UNKNOWN
00E871  CB                    RETF                                ; UNKNOWN
