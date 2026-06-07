; ============================================================================
; func_03A8F0_unknown
; Region   : load_image
; Bytes    : file 0x03A8F0..0x03A939  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A8F0  C8 44 00 00           ENTER  0x44, 0                      ; UNKNOWN
03A8F4  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A8F7  89 46 C0              MOV    word ptr [bp - 0x40], ax     ; UNKNOWN
03A8FA  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A8FD  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A901  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A903  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
03A907  2A ED                 SUB    ch, ch                       ; UNKNOWN
03A909  51                    PUSH   cx                           ; UNKNOWN
03A90A  50                    PUSH   ax                           ; UNKNOWN
03A90B  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
03A910  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A913  0B C0                 OR     ax, ax                       ; UNKNOWN
03A915  7C 20                 JL     0x3a937                      ; UNKNOWN
03A917  50                    PUSH   ax                           ; UNKNOWN
03A918  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
03A91D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A920  FF 76 C0              PUSH   word ptr [bp - 0x40]         ; UNKNOWN
03A923  9A 8F 11 6D 3E        LCALL  0x3e6d, 0x118f               ; UNKNOWN
03A928  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A92B  0B C0                 OR     ax, ax                       ; UNKNOWN
03A92D  75 08                 JNE    0x3a937                      ; UNKNOWN
03A92F  50                    PUSH   ax                           ; UNKNOWN
03A930  6A 01                 PUSH   1                            ; UNKNOWN
03A932  9A 44 04 10 0C        LCALL  0xc10, 0x444                 ; UNKNOWN
03A937  C9                    LEAVE                               ; UNKNOWN
03A938  CB                    RETF                                ; UNKNOWN
