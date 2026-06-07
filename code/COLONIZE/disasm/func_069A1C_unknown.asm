; ============================================================================
; func_069A1C_unknown
; Region   : load_image
; Bytes    : file 0x069A1C..0x069A3D  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069A1C  55                    PUSH   bp                           ; UNKNOWN
069A1D  8B EC                 MOV    bp, sp                       ; UNKNOWN
069A1F  57                    PUSH   di                           ; UNKNOWN
069A20  56                    PUSH   si                           ; UNKNOWN
069A21  1E                    PUSH   ds                           ; UNKNOWN
069A22  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069A25  C5 76 0A              LDS    si, ptr [bp + 0xa]           ; UNKNOWN
069A28  8B DF                 MOV    bx, di                       ; UNKNOWN
069A2A  8B 4E 0E              MOV    cx, word ptr [bp + 0xe]      ; UNKNOWN
069A2D  E3 0C                 JCXZ   0x69a3b                      ; UNKNOWN
069A2F  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
069A30  0A C0                 OR     al, al                       ; UNKNOWN
069A32  74 03                 JE     0x69a37                      ; UNKNOWN
069A34  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
069A35  E2 F8                 LOOP   0x69a2f                      ; UNKNOWN
069A37  32 C0                 XOR    al, al                       ; UNKNOWN
069A39  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
069A3B  8B C3                 MOV    ax, bx                       ; UNKNOWN
