; ============================================================================
; func_04E999_unknown
; Region   : load_image
; Bytes    : file 0x04E999..0x04E9D8  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E999  C8 78 00 00           ENTER  0x78, 0                      ; UNKNOWN
04E99D  57                    PUSH   di                           ; UNKNOWN
04E99E  56                    PUSH   si                           ; UNKNOWN
04E99F  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1      ; UNKNOWN
04E9A4  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
04E9A9  74 0C                 JE     0x4e9b7                      ; UNKNOWN
04E9AB  FF 36 4A 3E           PUSH   word ptr [0x3e4a]            ; UNKNOWN
04E9AF  9A 15 00 3E 36        LCALL  0x363e, 0x15                 ; UNKNOWN
04E9B4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E9B7  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
04E9BB  9A 15 00 3E 36        LCALL  0x363e, 0x15                 ; UNKNOWN
04E9C0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E9C3  8B 1E 10 3E           MOV    bx, word ptr [0x3e10]        ; UNKNOWN
04E9C7  C6 87 AE 86 00        MOV    byte ptr [bx - 0x7952], 0    ; UNKNOWN
04E9CC  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0      ; UNKNOWN
04E9D1  EB 18                 JMP    0x4e9eb                      ; UNKNOWN
04E9D3  69 D8 CA 00           IMUL   bx, ax, 0xca                 ; UNKNOWN
04E9D7  A0                    DB     0xA0                         ; UNKNOWN (raw)
