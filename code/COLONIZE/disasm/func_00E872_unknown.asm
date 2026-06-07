; ============================================================================
; func_00E872_unknown
; Region   : load_image
; Bytes    : file 0x00E872..0x00E8A6  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E872  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
00E876  A1 52 05              MOV    ax, word ptr [0x552]         ; UNKNOWN
00E879  0B C0                 OR     ax, ax                       ; UNKNOWN
00E87B  7E 27                 JLE    0xe8a4                       ; UNKNOWN
00E87D  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
00E882  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00E885  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E888  8B 87 7E 05           MOV    ax, word ptr [bx + 0x57e]    ; UNKNOWN
00E88C  89 87 5E 05           MOV    word ptr [bx + 0x55e], ax    ; UNKNOWN
00E890  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
00E893  8B 87 80 05           MOV    ax, word ptr [bx + 0x580]    ; UNKNOWN
00E897  89 87 60 05           MOV    word ptr [bx + 0x560], ax    ; UNKNOWN
00E89B  83 46 FA 04           ADD    word ptr [bp - 6], 4         ; UNKNOWN
00E89F  FF 4E F8              DEC    word ptr [bp - 8]            ; UNKNOWN
00E8A2  75 E1                 JNE    0xe885                       ; UNKNOWN
00E8A4  C9                    LEAVE                               ; UNKNOWN
00E8A5  CB                    RETF                                ; UNKNOWN
