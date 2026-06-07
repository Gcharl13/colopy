; ============================================================================
; func_00E624_unknown
; Region   : load_image
; Bytes    : file 0x00E624..0x00E665  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E624  55                    PUSH   bp                           ; UNKNOWN
00E625  8B EC                 MOV    bp, sp                       ; UNKNOWN
00E627  57                    PUSH   di                           ; UNKNOWN
00E628  56                    PUSH   si                           ; UNKNOWN
00E629  B4 35                 MOV    ah, 0x35                     ; UNKNOWN
00E62B  B0 67                 MOV    al, 0x67                     ; UNKNOWN
00E62D  CD 21                 INT    0x21                         ; UNKNOWN
00E62F  BF 0A 00              MOV    di, 0xa                      ; UNKNOWN
00E632  BE BE 05              MOV    si, 0x5be                    ; UNKNOWN
00E635  B9 08 00              MOV    cx, 8                        ; UNKNOWN
00E638  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; UNKNOWN
00E63A  75 3C                 JNE    0xe678                       ; UNKNOWN
00E63C  B4 40                 MOV    ah, 0x40                     ; UNKNOWN
00E63E  CD 67                 INT    0x67                         ; UNKNOWN
00E640  8A C4                 MOV    al, ah                       ; UNKNOWN
00E642  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E644  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E647  0B C0                 OR     ax, ax                       ; UNKNOWN
00E649  75 2D                 JNE    0xe678                       ; UNKNOWN
00E64B  B4 46                 MOV    ah, 0x46                     ; UNKNOWN
00E64D  CD 67                 INT    0x67                         ; UNKNOWN
00E64F  8A D0                 MOV    dl, al                       ; UNKNOWN
00E651  8A C4                 MOV    al, ah                       ; UNKNOWN
00E653  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E655  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E658  0B C0                 OR     ax, ax                       ; UNKNOWN
00E65A  75 1C                 JNE    0xe678                       ; UNKNOWN
00E65C  8A F2                 MOV    dh, dl                       ; UNKNOWN
00E65E  C0 EA 04              SHR    dl, 4                        ; UNKNOWN
00E661  8B C2                 MOV    ax, dx                       ; UNKNOWN
00E663  32 F6                 XOR    dh, dh                       ; UNKNOWN
