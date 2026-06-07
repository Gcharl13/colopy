; ============================================================================
; func_02DCB2_unknown
; Region   : load_image
; Bytes    : file 0x02DCB2..0x02DCFC  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DCB2  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
02DCB6  57                    PUSH   di                           ; UNKNOWN
02DCB7  56                    PUSH   si                           ; UNKNOWN
02DCB8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DCBB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DCBE  0E                    PUSH   cs                           ; UNKNOWN
02DCBF  E8 01 FF              CALL   0x2dbc3                      ; UNKNOWN
02DCC2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DCC5  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02DCC8  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DCCC  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02DCCF  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DCD1  50                    PUSH   ax                           ; UNKNOWN
02DCD2  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02DCD4  50                    PUSH   ax                           ; UNKNOWN
02DCD5  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
02DCDA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DCDD  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DCE0  83 7E F4 00           CMP    word ptr [bp - 0xc], 0       ; UNKNOWN
02DCE4  7D 03                 JGE    0x2dce9                      ; UNKNOWN
02DCE6  E9 D7 01              JMP    0x2dec0                      ; UNKNOWN
02DCE9  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
02DCEC  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DCF0  8B 76 F4              MOV    si, word ptr [bp - 0xc]      ; UNKNOWN
02DCF3  88 40 70              MOV    byte ptr [bx + si + 0x70], al ; UNKNOWN
02DCF6  0A C0                 OR     al, al                       ; UNKNOWN
02DCF8  7D 03                 JGE    0x2dcfd                      ; UNKNOWN
02DCFA  E9                    DB     0xE9                         ; UNKNOWN (raw)
02DCFB  C3                    DB     0xC3                         ; UNKNOWN (raw)
