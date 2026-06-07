; ============================================================================
; func_00E8A6_unknown
; Region   : load_image
; Bytes    : file 0x00E8A6..0x00E8D2  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E8A6  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
00E8AA  56                    PUSH   si                           ; UNKNOWN
00E8AB  2B C0                 SUB    ax, ax                       ; UNKNOWN
00E8AD  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00E8B0  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
00E8B3  A1 52 05              MOV    ax, word ptr [0x552]         ; UNKNOWN
00E8B6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00E8B9  3B 46 0C              CMP    ax, word ptr [bp + 0xc]      ; UNKNOWN
00E8BC  7D 03                 JGE    0xe8c1                       ; UNKNOWN
00E8BE  89 46 0C              MOV    word ptr [bp + 0xc], ax      ; UNKNOWN
00E8C1  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
00E8C4  99                    CDQ                                 ; UNKNOWN
00E8C5  F7 7E FE              IDIV   word ptr [bp - 2]            ; UNKNOWN
00E8C8  89 56 08              MOV    word ptr [bp + 8], dx        ; UNKNOWN
00E8CB  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00E8CE  2B C2                 SUB    ax, dx                       ; UNKNOWN
00E8D0  3B                    DB     0x3B                         ; UNKNOWN (raw)
00E8D1  46                    DB     0x46                         ; UNKNOWN (raw)
