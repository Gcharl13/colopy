; ============================================================================
; func_029708_unknown
; Region   : load_image
; Bytes    : file 0x029708..0x029786  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029708  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02970C  57                    PUSH   di                           ; UNKNOWN
02970D  56                    PUSH   si                           ; UNKNOWN
02970E  68 FD 19              PUSH   0x19fd                       ; UNKNOWN
029711  6A 00                 PUSH   0                            ; UNKNOWN
029713  6A 00                 PUSH   0                            ; UNKNOWN
029715  0E                    PUSH   cs                           ; UNKNOWN
029716  E8 12 F3              CALL   0x28a2b                      ; UNKNOWN
029719  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02971C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02971F  0B C0                 OR     ax, ax                       ; UNKNOWN
029721  7D 03                 JGE    0x29726                      ; UNKNOWN
029723  E9 E6 00              JMP    0x2980c                      ; UNKNOWN
029726  50                    PUSH   ax                           ; UNKNOWN
029727  0E                    PUSH   cs                           ; UNKNOWN
029728  E8 79 EB              CALL   0x282a4                      ; UNKNOWN
02972B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02972E  FF 36 8C 40           PUSH   word ptr [0x408c]            ; UNKNOWN
029732  FF 36 8A 40           PUSH   word ptr [0x408a]            ; UNKNOWN
029736  6A 00                 PUSH   0                            ; UNKNOWN
029738  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
02973D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
029740  8D 1E 09 1A           LEA    bx, [0x1a09]                 ; UNKNOWN
029744  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
029749  48                    DEC    ax                           ; UNKNOWN
02974A  74 03                 JE     0x2974f                      ; UNKNOWN
02974C  E9 BD 00              JMP    0x2980c                      ; UNKNOWN
02974F  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
029754  EB 1C                 JMP    0x29772                      ; UNKNOWN
029756  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
029759  39 46 FC              CMP    word ptr [bp - 4], ax        ; UNKNOWN
02975C  7E 11                 JLE    0x2976f                      ; UNKNOWN
02975E  FF 4E FC              DEC    word ptr [bp - 4]            ; UNKNOWN
029761  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
029764  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
029767  9A 58 0F B7 36        LCALL  0x36b7, 0xf58                ; UNKNOWN
02976C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02976F  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
029772  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
029775  39 06 14 3E           CMP    word ptr [0x3e14], ax        ; UNKNOWN
029779  7E 5B                 JLE    0x297d6                      ; UNKNOWN
02977B  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02977E  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
029782  2A FF                 SUB    bh, bh                       ; UNKNOWN
029784  8B C3                 MOV    ax, bx                       ; UNKNOWN
