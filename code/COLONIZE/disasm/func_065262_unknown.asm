; ============================================================================
; func_065262_unknown
; Region   : load_image
; Bytes    : file 0x065262..0x0652AC  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065262  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
065266  53                    PUSH   bx                           ; UNKNOWN
065267  51                    PUSH   cx                           ; UNKNOWN
065268  52                    PUSH   dx                           ; UNKNOWN
065269  06                    PUSH   es                           ; UNKNOWN
06526A  6A 00                 PUSH   0                            ; UNKNOWN
06526C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06526F  9A 0C 00 4C 5E        LCALL  0x5e4c, 0xc                  ; UNKNOWN
065274  83 C4 04              ADD    sp, 4                        ; UNKNOWN
065277  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
06527A  A3 9C CE              MOV    word ptr [0xce9c], ax        ; UNKNOWN
06527D  A3 9E CE              MOV    word ptr [0xce9e], ax        ; UNKNOWN
065280  B8 CE 0D              MOV    ax, 0xdce                    ; UNKNOWN
065283  A3 A0 CE              MOV    word ptr [0xcea0], ax        ; UNKNOWN
065286  B8 F7 62              MOV    ax, 0x62f7                   ; UNKNOWN
065289  A3 A2 CE              MOV    word ptr [0xcea2], ax        ; UNKNOWN
06528C  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06528F  A3 A4 CE              MOV    word ptr [0xcea4], ax        ; UNKNOWN
065292  C7 06 92 CE 00 00     MOV    word ptr [0xce92], 0         ; UNKNOWN
065298  C7 06 94 CE 00 00     MOV    word ptr [0xce94], 0         ; UNKNOWN
06529E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0652A3  B8 33 35              MOV    ax, 0x3533                   ; UNKNOWN
0652A6  CD 21                 INT    0x21                         ; UNKNOWN
0652A8  8C C0                 MOV    ax, es                       ; UNKNOWN
0652AA  0B C3                 OR     ax, bx                       ; UNKNOWN
