; ============================================================================
; func_034991_unknown
; Region   : load_image
; Bytes    : file 0x034991..0x0349C3  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034991  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
034995  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
034999  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
03499D  83 7E 08 64           CMP    word ptr [bp + 8], 0x64      ; UNKNOWN
0349A1  7C 05                 JL     0x349a8                      ; UNKNOWN
0349A3  B8 17 00              MOV    ax, 0x17                     ; UNKNOWN
0349A6  EB 03                 JMP    0x349ab                      ; UNKNOWN
0349A8  B8 27 00              MOV    ax, 0x27                     ; UNKNOWN
0349AB  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
0349AE  2B D2                 SUB    dx, dx                       ; UNKNOWN
0349B0  9A 00 00 BC 5C        LCALL  0x5cbc, 0                    ; UNKNOWN
0349B5  C7 06 BE 79 01 00     MOV    word ptr [0x79be], 1         ; UNKNOWN
0349BB  C7 06 BA 79 0A 00     MOV    word ptr [0x79ba], 0xa       ; UNKNOWN
0349C1  C9                    LEAVE                               ; UNKNOWN
0349C2  CB                    RETF                                ; UNKNOWN
