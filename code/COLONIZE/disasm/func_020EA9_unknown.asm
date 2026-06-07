; ============================================================================
; func_020EA9_unknown
; Region   : load_image
; Bytes    : file 0x020EA9..0x020F0C  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020EA9  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
020EAD  50                    PUSH   ax                           ; UNKNOWN
020EAE  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
020EB3  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
020EB8  74 0E                 JE     0x20ec8                      ; UNKNOWN
020EBA  C7 06 30 0B B4 2E     MOV    word ptr [0xb30], 0x2eb4     ; UNKNOWN
020EC0  C7 06 32 0B 00 00     MOV    word ptr [0xb32], 0          ; UNKNOWN
020EC6  EB 0F                 JMP    0x20ed7                      ; UNKNOWN
020EC8  A1 8A 82              MOV    ax, word ptr [0x828a]        ; UNKNOWN
020ECB  F7 2E 88 82           IMUL   word ptr [0x8288]            ; UNKNOWN
020ECF  99                    CDQ                                 ; UNKNOWN
020ED0  A3 30 0B              MOV    word ptr [0xb30], ax         ; UNKNOWN
020ED3  89 16 32 0B           MOV    word ptr [0xb32], dx         ; UNKNOWN
020ED7  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
020EDB  74 0C                 JE     0x20ee9                      ; UNKNOWN
020EDD  C7 06 30 0B E0 2E     MOV    word ptr [0xb30], 0x2ee0     ; UNKNOWN
020EE3  C7 06 32 0B 00 00     MOV    word ptr [0xb32], 0          ; UNKNOWN
020EE9  C7 06 9C 82 F0 00     MOV    word ptr [0x829c], 0xf0      ; UNKNOWN
020EEF  C7 06 9E 82 C0 00     MOV    word ptr [0x829e], 0xc0      ; UNKNOWN
020EF5  A1 30 0B              MOV    ax, word ptr [0xb30]         ; UNKNOWN
020EF8  8B 16 32 0B           MOV    dx, word ptr [0xb32]         ; UNKNOWN
020EFC  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
020F01  A3 0C 0B              MOV    word ptr [0xb0c], ax         ; UNKNOWN
020F04  89 16 0E 0B           MOV    word ptr [0xb0e], dx         ; UNKNOWN
020F08  8B C2                 MOV    ax, dx                       ; UNKNOWN
020F0A  0B                    DB     0x0B                         ; UNKNOWN (raw)
020F0B  06                    DB     0x06                         ; UNKNOWN (raw)
