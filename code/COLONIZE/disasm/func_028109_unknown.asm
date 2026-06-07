; ============================================================================
; func_028109_unknown
; Region   : load_image
; Bytes    : file 0x028109..0x028154  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028109  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02810D  C7 06 22 0A 01 00     MOV    word ptr [0xa22], 1          ; UNKNOWN
028113  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
028116  89 0E 88 40           MOV    word ptr [0x4088], cx        ; UNKNOWN
02811A  89 16 86 40           MOV    word ptr [0x4086], dx        ; UNKNOWN
02811E  2B D2                 SUB    dx, dx                       ; UNKNOWN
028120  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
028123  0E                    PUSH   cs                           ; UNKNOWN
028124  E8 A3 FA              CALL   0x27bca                      ; UNKNOWN
028127  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02812A  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
02812D  0B D0                 OR     dx, ax                       ; UNKNOWN
02812F  74 16                 JE     0x28147                      ; UNKNOWN
028131  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
028134  50                    PUSH   ax                           ; UNKNOWN
028135  0E                    PUSH   cs                           ; UNKNOWN
028136  E8 81 ED              CALL   0x26eba                      ; UNKNOWN
028139  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02813C  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02813F  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
028142  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
028147  C7 06 22 0A 00 00     MOV    word ptr [0xa22], 0          ; UNKNOWN
02814D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
028150  C9                    LEAVE                               ; UNKNOWN
028151  CA 02 00              RETF   2                            ; UNKNOWN
