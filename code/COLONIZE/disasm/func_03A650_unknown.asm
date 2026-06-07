; ============================================================================
; func_03A650_unknown
; Region   : load_image
; Bytes    : file 0x03A650..0x03A692  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A650  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
03A654  56                    PUSH   si                           ; UNKNOWN
03A655  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A658  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
03A65B  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A65E  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03A662  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A664  50                    PUSH   ax                           ; UNKNOWN
03A665  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A669  50                    PUSH   ax                           ; UNKNOWN
03A66A  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
03A66F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A672  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03A675  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
03A678  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
03A67B  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
03A680  74 10                 JE     0x3a692                      ; UNKNOWN
03A682  6A 01                 PUSH   1                            ; UNKNOWN
03A684  68 BF 22              PUSH   0x22bf                       ; UNKNOWN
03A687  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03A68C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A68F  5E                    POP    si                           ; UNKNOWN
03A690  C9                    LEAVE                               ; UNKNOWN
03A691  CB                    RETF                                ; UNKNOWN
