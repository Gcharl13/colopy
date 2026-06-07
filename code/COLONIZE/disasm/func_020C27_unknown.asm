; ============================================================================
; func_020C27_unknown
; Region   : load_image
; Bytes    : file 0x020C27..0x020C88  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020C27  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
020C2B  57                    PUSH   di                           ; UNKNOWN
020C2C  56                    PUSH   si                           ; UNKNOWN
020C2D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
020C30  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
020C32  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
020C35  03 04                 ADD    ax, word ptr [si]            ; UNKNOWN
020C37  48                    DEC    ax                           ; UNKNOWN
020C38  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
020C3B  8B 7E 0C              MOV    di, word ptr [bp + 0xc]      ; UNKNOWN
020C3E  8B 05                 MOV    ax, word ptr [di]            ; UNKNOWN
020C40  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
020C43  03 07                 ADD    ax, word ptr [bx]            ; UNKNOWN
020C45  48                    DEC    ax                           ; UNKNOWN
020C46  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
020C49  A1 50 85              MOV    ax, word ptr [0x8550]        ; UNKNOWN
020C4C  3B 46 FE              CMP    ax, word ptr [bp - 2]        ; UNKNOWN
020C4F  7E 03                 JLE    0x20c54                      ; UNKNOWN
020C51  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
020C54  8B 0C                 MOV    cx, word ptr [si]            ; UNKNOWN
020C56  3B 0E 80 82           CMP    cx, word ptr [0x8280]        ; UNKNOWN
020C5A  7D 04                 JGE    0x20c60                      ; UNKNOWN
020C5C  8B 0E 80 82           MOV    cx, word ptr [0x8280]        ; UNKNOWN
020C60  89 0C                 MOV    word ptr [si], cx            ; UNKNOWN
020C62  2B C1                 SUB    ax, cx                       ; UNKNOWN
020C64  40                    INC    ax                           ; UNKNOWN
020C65  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
020C68  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
020C6A  8B 0E 52 85           MOV    cx, word ptr [0x8552]        ; UNKNOWN
020C6E  3B 4E FC              CMP    cx, word ptr [bp - 4]        ; UNKNOWN
020C71  7E 03                 JLE    0x20c76                      ; UNKNOWN
020C73  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
020C76  8B 17                 MOV    dx, word ptr [bx]            ; UNKNOWN
020C78  3B 16 86 82           CMP    dx, word ptr [0x8286]        ; UNKNOWN
020C7C  7D 04                 JGE    0x20c82                      ; UNKNOWN
020C7E  8B 16 86 82           MOV    dx, word ptr [0x8286]        ; UNKNOWN
020C82  89 17                 MOV    word ptr [bx], dx            ; UNKNOWN
020C84  2B CA                 SUB    cx, dx                       ; UNKNOWN
020C86  41                    INC    cx                           ; UNKNOWN
020C87  89                    DB     0x89                         ; UNKNOWN (raw)
