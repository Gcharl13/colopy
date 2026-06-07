; ============================================================================
; func_047824_unknown
; Region   : load_image
; Bytes    : file 0x047824..0x047872  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047824  55                    PUSH   bp                           ; UNKNOWN
047825  8B EC                 MOV    bp, sp                       ; UNKNOWN
047827  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04782B  80 AF 95 88 14        SUB    byte ptr [bx - 0x776b], 0x14 ; UNKNOWN
047830  80 BF 95 88 14        CMP    byte ptr [bx - 0x776b], 0x14 ; UNKNOWN
047835  73 39                 JAE    0x47870                      ; UNKNOWN
047837  2A C0                 SUB    al, al                       ; UNKNOWN
047839  88 87 95 88           MOV    byte ptr [bx - 0x776b], al   ; UNKNOWN
04783D  88 87 82 88           MOV    byte ptr [bx - 0x777e], al   ; UNKNOWN
047841  80 BF 97 88 18        CMP    byte ptr [bx - 0x7769], 0x18 ; UNKNOWN
047846  75 05                 JNE    0x4784d                      ; UNKNOWN
047848  C6 87 82 88 03        MOV    byte ptr [bx - 0x777e], 3    ; UNKNOWN
04784D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
047851  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
047855  24 0F                 AND    al, 0xf                      ; UNKNOWN
047857  3C 04                 CMP    al, 4                        ; UNKNOWN
047859  73 15                 JAE    0x47870                      ; UNKNOWN
04785B  2A E4                 SUB    ah, ah                       ; UNKNOWN
04785D  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
047860  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
047864  75 0A                 JNE    0x47870                      ; UNKNOWN
047866  6A 03                 PUSH   3                            ; UNKNOWN
047868  68 10 29              PUSH   0x2910                       ; UNKNOWN
04786B  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
047870  C9                    LEAVE                               ; UNKNOWN
047871  CB                    RETF                                ; UNKNOWN
