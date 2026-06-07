; ============================================================================
; func_06339C_unknown
; Region   : load_image
; Bytes    : file 0x06339C..0x0633CC  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06339C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0633A0  56                    PUSH   si                           ; UNKNOWN
0633A1  8B F3                 MOV    si, bx                       ; UNKNOWN
0633A3  80 3C 30              CMP    byte ptr [si], 0x30          ; UNKNOWN
0633A6  75 41                 JNE    0x633e9                      ; UNKNOWN
0633A8  8A 5C 01              MOV    bl, byte ptr [si + 1]        ; UNKNOWN
0633AB  88 5E FF              MOV    byte ptr [bp - 1], bl        ; UNKNOWN
0633AE  2A FF                 SUB    bh, bh                       ; UNKNOWN
0633B0  F6 87 BB 13 02        TEST   byte ptr [bx + 0x13bb], 2    ; UNKNOWN
0633B5  74 04                 JE     0x633bb                      ; UNKNOWN
0633B7  80 6E FF 20           SUB    byte ptr [bp - 1], 0x20      ; UNKNOWN
0633BB  80 7E FF 58           CMP    byte ptr [bp - 1], 0x58      ; UNKNOWN
0633BF  75 0B                 JNE    0x633cc                      ; UNKNOWN
0633C1  8D 5C 02              LEA    bx, [si + 2]                 ; UNKNOWN
0633C4  9A 04 00 6B 5E        LCALL  0x5e6b, 4                    ; UNKNOWN
0633C9  5E                    POP    si                           ; UNKNOWN
0633CA  C9                    LEAVE                               ; UNKNOWN
0633CB  CB                    RETF                                ; UNKNOWN
