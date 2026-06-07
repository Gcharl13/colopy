; ============================================================================
; func_020C9D_unknown
; Region   : load_image
; Bytes    : file 0x020C9D..0x020CF9  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020C9D  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
020CA1  A1 84 82              MOV    ax, word ptr [0x8284]        ; UNKNOWN
020CA4  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
020CA8  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
020CAB  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
020CAF  8B C8                 MOV    cx, ax                       ; UNKNOWN
020CB1  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
020CB4  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
020CB8  8B D0                 MOV    dx, ax                       ; UNKNOWN
020CBA  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
020CBD  8B DA                 MOV    bx, dx                       ; UNKNOWN
020CBF  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
020CC3  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
020CC7  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
020CCB  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
020CCF  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
020CD3  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
020CD7  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
020CDB  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
020CDF  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
020CE3  8B D1                 MOV    dx, cx                       ; UNKNOWN
020CE5  83 C1 08              ADD    cx, 8                        ; UNKNOWN
020CE8  51                    PUSH   cx                           ; UNKNOWN
020CE9  53                    PUSH   bx                           ; UNKNOWN
020CEA  50                    PUSH   ax                           ; UNKNOWN
020CEB  A1 82 82              MOV    ax, word ptr [0x8282]        ; UNKNOWN
020CEE  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
020CF2  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
020CF5  8B CA                 MOV    cx, dx                       ; UNKNOWN
020CF7  F7                    DB     0xF7                         ; UNKNOWN (raw)
020CF8  2E                    DB     0x2E                         ; UNKNOWN (raw)
