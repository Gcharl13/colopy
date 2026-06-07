; ============================================================================
; func_020D3B_unknown
; Region   : load_image
; Bytes    : file 0x020D3B..0x020D91  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020D3B  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
020D3F  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1       ; UNKNOWN
020D44  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
020D49  2B C0                 SUB    ax, ax                       ; UNKNOWN
020D4B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
020D4E  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
020D51  A1 92 82              MOV    ax, word ptr [0x8292]        ; UNKNOWN
020D54  F7 2E 90 82           IMUL   word ptr [0x8290]            ; UNKNOWN
020D58  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
020D5B  2B C0                 SUB    ax, ax                       ; UNKNOWN
020D5D  A3 C6 CE              MOV    word ptr [0xcec6], ax        ; UNKNOWN
020D60  A3 C4 CE              MOV    word ptr [0xcec4], ax        ; UNKNOWN
020D63  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
020D66  D1 E8                 SHR    ax, 1                        ; UNKNOWN
020D68  73 03                 JAE    0x20d6d                      ; UNKNOWN
020D6A  35 00 B4              XOR    ax, 0xb400                   ; UNKNOWN
020D6D  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
020D70  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
020D73  48                    DEC    ax                           ; UNKNOWN
020D74  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
020D77  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
020D7A  73 70                 JAE    0x20dec                      ; UNKNOWN
020D7C  2B D2                 SUB    dx, dx                       ; UNKNOWN
020D7E  F7 36 90 82           DIV    word ptr [0x8290]            ; UNKNOWN
020D82  8B C8                 MOV    cx, ax                       ; UNKNOWN
020D84  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
020D87  2B D2                 SUB    dx, dx                       ; UNKNOWN
020D89  F7 36 90 82           DIV    word ptr [0x8290]            ; UNKNOWN
020D8D  8B C2                 MOV    ax, dx                       ; UNKNOWN
020D8F  03                    DB     0x03                         ; UNKNOWN (raw)
020D90  06                    DB     0x06                         ; UNKNOWN (raw)
