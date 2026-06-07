; ============================================================================
; func_00944A_unknown
; Region   : load_image
; Bytes    : file 0x00944A..0x009464  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00944A  55                    PUSH   bp                           ; UNKNOWN
00944B  8B EC                 MOV    bp, sp                       ; UNKNOWN
00944D  B8 03 58              MOV    ax, 0x5803                   ; UNKNOWN
009450  32 FF                 XOR    bh, bh                       ; UNKNOWN
009452  8A 5E 04              MOV    bl, byte ptr [bp + 4]        ; UNKNOWN
009455  CD 21                 INT    0x21                         ; UNKNOWN
009457  72 02                 JB     0x945b                       ; UNKNOWN
009459  33 C0                 XOR    ax, ax                       ; UNKNOWN
00945B  F7 D8                 NEG    ax                           ; UNKNOWN
00945D  1B C0                 SBB    ax, ax                       ; UNKNOWN
00945F  40                    INC    ax                           ; UNKNOWN
009460  C9                    LEAVE                               ; UNKNOWN
009461  C2 02 00              RET    2                            ; UNKNOWN
