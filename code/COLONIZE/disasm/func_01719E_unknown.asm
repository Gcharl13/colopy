; ============================================================================
; func_01719E_unknown
; Region   : load_image
; Bytes    : file 0x01719E..0x0171C4  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01719E  C8 38 00 00           ENTER  0x38, 0                      ; UNKNOWN
0171A2  57                    PUSH   di                           ; UNKNOWN
0171A3  56                    PUSH   si                           ; UNKNOWN
0171A4  9A 3F 14 5F 24        LCALL  0x245f, 0x143f               ; UNKNOWN
0171A9  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
0171AE  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
0171B0  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
0171B3  88 87 50 74           MOV    byte ptr [bx + 0x7450], al   ; UNKNOWN
0171B7  88 87 41 74           MOV    byte ptr [bx + 0x7441], al   ; UNKNOWN
0171BB  8B F3                 MOV    si, bx                       ; UNKNOWN
0171BD  D1 E6                 SHL    si, 1                        ; UNKNOWN
0171BF  C7 42 CA FF FF        MOV    word ptr [bp + si - 0x36], 0xffff ; UNKNOWN
