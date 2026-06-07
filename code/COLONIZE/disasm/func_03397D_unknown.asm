; ============================================================================
; func_03397D_unknown
; Region   : load_image
; Bytes    : file 0x03397D..0x0339D2  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03397D  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
033981  56                    PUSH   si                           ; UNKNOWN
033982  6A 15                 PUSH   0x15                         ; UNKNOWN
033984  68 40 01              PUSH   0x140                        ; UNKNOWN
033987  68 B3 00              PUSH   0xb3                         ; UNKNOWN
03398A  6A 00                 PUSH   0                            ; UNKNOWN
03398C  0E                    PUSH   cs                           ; UNKNOWN
03398D  E8 C0 FC              CALL   0x33650                      ; UNKNOWN
033990  83 C4 08              ADD    sp, 8                        ; UNKNOWN
033993  C7 46 98 01 00        MOV    word ptr [bp - 0x68], 1      ; UNKNOWN
033998  C7 46 96 B5 00        MOV    word ptr [bp - 0x6a], 0xb5   ; UNKNOWN
03399D  C7 46 8E 00 00        MOV    word ptr [bp - 0x72], 0      ; UNKNOWN
0339A2  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0339A6  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0339AA  FF 76 96              PUSH   word ptr [bp - 0x6a]         ; UNKNOWN
0339AD  8B 46 8E              MOV    ax, word ptr [bp - 0x72]     ; UNKNOWN
0339B0  8B F0                 MOV    si, ax                       ; UNKNOWN
0339B2  8B C8                 MOV    cx, ax                       ; UNKNOWN
0339B4  D1 E6                 SHL    si, 1                        ; UNKNOWN
0339B6  03 F1                 ADD    si, cx                       ; UNKNOWN
0339B8  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0339BB  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
0339BE  8B 56 98              MOV    dx, word ptr [bp - 0x68]     ; UNKNOWN
0339C1  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
0339C5  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; UNKNOWN
0339CA  D1 F9                 SAR    cx, 1                        ; UNKNOWN
0339CC  2B D1                 SUB    dx, cx                       ; UNKNOWN
0339CE  83 C2 09              ADD    dx, 9                        ; UNKNOWN
0339D1  89                    DB     0x89                         ; UNKNOWN (raw)
