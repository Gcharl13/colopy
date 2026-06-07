; ============================================================================
; func_020E0D_unknown
; Region   : load_image
; Bytes    : file 0x020E0D..0x020E52  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020E0D  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
020E11  A1 84 82              MOV    ax, word ptr [0x8284]        ; UNKNOWN
020E14  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
020E18  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
020E1B  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
020E1F  83 C0 08              ADD    ax, 8                        ; UNKNOWN
020E22  8B C8                 MOV    cx, ax                       ; UNKNOWN
020E24  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
020E27  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
020E2B  8B D0                 MOV    dx, ax                       ; UNKNOWN
020E2D  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
020E30  8B DA                 MOV    bx, dx                       ; UNKNOWN
020E32  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
020E36  51                    PUSH   cx                           ; UNKNOWN
020E37  53                    PUSH   bx                           ; UNKNOWN
020E38  50                    PUSH   ax                           ; UNKNOWN
020E39  A1 82 82              MOV    ax, word ptr [0x8282]        ; UNKNOWN
020E3C  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
020E40  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
020E43  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
020E47  8B D8                 MOV    bx, ax                       ; UNKNOWN
020E49  8B D1                 MOV    dx, cx                       ; UNKNOWN
020E4B  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
020E50  C9                    LEAVE                               ; UNKNOWN
020E51  CB                    RETF                                ; UNKNOWN
