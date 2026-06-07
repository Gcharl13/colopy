; ============================================================================
; func_023548_unknown
; Region   : load_image
; Bytes    : file 0x023548..0x02357B  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023548  55                    PUSH   bp                           ; UNKNOWN
023549  8B EC                 MOV    bp, sp                       ; UNKNOWN
02354B  A1 DA 09              MOV    ax, word ptr [0x9da]         ; UNKNOWN
02354E  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
023551  74 26                 JE     0x23579                      ; UNKNOWN
023553  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
023556  A3 D8 09              MOV    word ptr [0x9d8], ax         ; UNKNOWN
023559  83 3E 1A 0F 00        CMP    word ptr [0xf1a], 0          ; UNKNOWN
02355E  74 0D                 JE     0x2356d                      ; UNKNOWN
023560  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
023565  75 06                 JNE    0x2356d                      ; UNKNOWN
023567  C7 06 E2 09 01 00     MOV    word ptr [0x9e2], 1          ; UNKNOWN
02356D  0B C0                 OR     ax, ax                       ; UNKNOWN
02356F  7C 08                 JL     0x23579                      ; UNKNOWN
023571  B8 01 00              MOV    ax, 1                        ; UNKNOWN
023574  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
023579  C9                    LEAVE                               ; UNKNOWN
02357A  CB                    RETF                                ; UNKNOWN
