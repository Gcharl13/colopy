; ============================================================================
; func_067F24_unknown
; Region   : load_image
; Bytes    : file 0x067F24..0x067F62  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067F24  C8 A2 05 00           ENTER  0x5a2, 0                     ; UNKNOWN
067F28  8A CC                 MOV    cl, ah                       ; UNKNOWN
067F2A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
067F2D  D3 E0                 SHL    ax, cl                       ; UNKNOWN
067F2F  A3 08 00              MOV    word ptr [8], ax             ; UNKNOWN
067F32  80 E9 04              SUB    cl, 4                        ; UNKNOWN
067F35  B8 01 00              MOV    ax, 1                        ; UNKNOWN
067F38  D3 E0                 SHL    ax, cl                       ; UNKNOWN
067F3A  A3 0A 00              MOV    word ptr [0xa], ax           ; UNKNOWN
067F3D  80 E9 04              SUB    cl, 4                        ; UNKNOWN
067F40  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
067F42  D2 E0                 SHL    al, cl                       ; UNKNOWN
067F44  A2 06 00              MOV    byte ptr [6], al             ; UNKNOWN
067F47  81 FE 1B 08           CMP    si, 0x81b                    ; UNKNOWN
067F4B  72 03                 JB     0x67f50                      ; UNKNOWN
067F4D  E8 05 01              CALL   0x68055                      ; UNKNOWN
067F50  AD                    LODSW  ax, word ptr [si]            ; UNKNOWN
067F51  8B E8                 MOV    bp, ax                       ; UNKNOWN
067F53  BA 10 00              MOV    dx, 0x10                     ; UNKNOWN
067F56  EB 0A                 JMP    0x67f62                      ; UNKNOWN
067F58  B8 16 00              MOV    ax, 0x16                     ; UNKNOWN
067F5B  1F                    POP    ds                           ; UNKNOWN
067F5C  5F                    POP    di                           ; UNKNOWN
067F5D  5E                    POP    si                           ; UNKNOWN
067F5E  C9                    LEAVE                               ; UNKNOWN
067F5F  CA 0C 00              RETF   0xc                          ; UNKNOWN
