; ============================================================================
; func_03D12A_unknown
; Region   : load_image
; Bytes    : file 0x03D12A..0x03D148  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D12A  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
03D12E  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
03D133  83 3E 40 0B 00        CMP    word ptr [0xb40], 0          ; UNKNOWN
03D138  75 03                 JNE    0x3d13d                      ; UNKNOWN
03D13A  E9 D0 00              JMP    0x3d20d                      ; UNKNOWN
03D13D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D140  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D143  0E                    PUSH   cs                           ; UNKNOWN
03D144  E8 CA FE              CALL   0x3d011                      ; UNKNOWN
03D147  83                    DB     0x83                         ; UNKNOWN (raw)
