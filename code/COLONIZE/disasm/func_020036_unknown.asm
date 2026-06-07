; ============================================================================
; func_020036_unknown
; Region   : load_image
; Bytes    : file 0x020036..0x020099  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020036  C8 24 03 00           ENTER  0x324, 0                     ; UNKNOWN
02003A  57                    PUSH   di                           ; UNKNOWN
02003B  56                    PUSH   si                           ; UNKNOWN
02003C  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
02003F  89 86 DC FC           MOV    word ptr [bp - 0x324], ax    ; UNKNOWN
020043  50                    PUSH   ax                           ; UNKNOWN
020044  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
020049  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02004C  A1 02 3E              MOV    ax, word ptr [0x3e02]        ; UNKNOWN
02004F  B9 64 00              MOV    cx, 0x64                     ; UNKNOWN
020052  99                    CDQ                                 ; UNKNOWN
020053  F7 F9                 IDIV   cx                           ; UNKNOWN
020055  88 16 20 3E           MOV    byte ptr [0x3e20], dl        ; UNKNOWN
020059  A1 02 3E              MOV    ax, word ptr [0x3e02]        ; UNKNOWN
02005C  99                    CDQ                                 ; UNKNOWN
02005D  F7 F9                 IDIV   cx                           ; UNKNOWN
02005F  A2 1F 3E              MOV    byte ptr [0x3e1f], al        ; UNKNOWN
020062  2B C0                 SUB    ax, ax                       ; UNKNOWN
020064  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
020067  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
02006B  89 47 0C              MOV    word ptr [bx + 0xc], ax      ; UNKNOWN
02006E  39 06 4A 3E           CMP    word ptr [0x3e4a], ax        ; UNKNOWN
020072  7D 04                 JGE    0x20078                      ; UNKNOWN
020074  0E                    PUSH   cs                           ; UNKNOWN
020075  E8 D1 E7              CALL   0x1e849                      ; UNKNOWN
020078  6A 03                 PUSH   3                            ; UNKNOWN
02007A  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
02007F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
020082  0E                    PUSH   cs                           ; UNKNOWN
020083  E8 97 FB              CALL   0x1fc1d                      ; UNKNOWN
020086  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0       ; UNKNOWN
02008B  8A 46 F2              MOV    al, byte ptr [bp - 0xe]      ; UNKNOWN
02008E  8B 76 F2              MOV    si, word ptr [bp - 0xe]      ; UNKNOWN
020091  88 42 EE              MOV    byte ptr [bp + si - 0x12], al ; UNKNOWN
020094  8A 84 C2 86           MOV    al, byte ptr [si - 0x793e]   ; UNKNOWN
020098  2A                    DB     0x2A                         ; UNKNOWN (raw)
