; ============================================================================
; func_06815A_unknown
; Region   : load_image
; Bytes    : file 0x06815A..0x068198  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06815A  C8 A2 05 00           ENTER  0x5a2, 0                     ; UNKNOWN
06815E  8A CC                 MOV    cl, ah                       ; UNKNOWN
068160  B8 01 00              MOV    ax, 1                        ; UNKNOWN
068163  D3 E0                 SHL    ax, cl                       ; UNKNOWN
068165  A3 08 00              MOV    word ptr [8], ax             ; UNKNOWN
068168  80 E9 04              SUB    cl, 4                        ; UNKNOWN
06816B  B8 01 00              MOV    ax, 1                        ; UNKNOWN
06816E  D3 E0                 SHL    ax, cl                       ; UNKNOWN
068170  A3 0A 00              MOV    word ptr [0xa], ax           ; UNKNOWN
068173  80 E9 04              SUB    cl, 4                        ; UNKNOWN
068176  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
068178  D2 E0                 SHL    al, cl                       ; UNKNOWN
06817A  A2 06 00              MOV    byte ptr [6], al             ; UNKNOWN
06817D  81 FE 0F 08           CMP    si, 0x80f                    ; UNKNOWN
068181  72 03                 JB     0x68186                      ; UNKNOWN
068183  E8 2B 01              CALL   0x682b1                      ; UNKNOWN
068186  AD                    LODSW  ax, word ptr [si]            ; UNKNOWN
068187  8B E8                 MOV    bp, ax                       ; UNKNOWN
068189  BA 10 00              MOV    dx, 0x10                     ; UNKNOWN
06818C  EB 0A                 JMP    0x68198                      ; UNKNOWN
06818E  B8 16 00              MOV    ax, 0x16                     ; UNKNOWN
068191  1F                    POP    ds                           ; UNKNOWN
068192  5F                    POP    di                           ; UNKNOWN
068193  5E                    POP    si                           ; UNKNOWN
068194  C9                    LEAVE                               ; UNKNOWN
068195  CA 0C 00              RETF   0xc                          ; UNKNOWN
