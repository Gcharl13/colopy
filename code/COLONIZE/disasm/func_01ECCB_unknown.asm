; ============================================================================
; func_01ECCB_unknown
; Region   : load_image
; Bytes    : file 0x01ECCB..0x01ED05  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01ECCB  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
01ECCF  56                    PUSH   si                           ; UNKNOWN
01ECD0  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
01ECD5  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
01ECD8  2A E4                 SUB    ah, ah                       ; UNKNOWN
01ECDA  40                    INC    ax                           ; UNKNOWN
01ECDB  50                    PUSH   ax                           ; UNKNOWN
01ECDC  2B C0                 SUB    ax, ax                       ; UNKNOWN
01ECDE  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01ECE1  50                    PUSH   ax                           ; UNKNOWN
01ECE2  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
01ECE7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01ECEA  0B C0                 OR     ax, ax                       ; UNKNOWN
01ECEC  75 03                 JNE    0x1ecf1                      ; UNKNOWN
01ECEE  E9 AF 02              JMP    0x1efa0                      ; UNKNOWN
01ECF1  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0      ; UNKNOWN
01ECF6  E9 CD 00              JMP    0x1edc6                      ; UNKNOWN
01ECF9  6B 5E EE 1C           IMUL   bx, word ptr [bp - 0x12], 0x1c ; UNKNOWN
01ECFD  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
01ED01  2A FF                 SUB    bh, bh                       ; UNKNOWN
01ED03  8B C3                 MOV    ax, bx                       ; UNKNOWN
