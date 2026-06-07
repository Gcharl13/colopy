; ============================================================================
; func_04103C_unknown
; Region   : load_image
; Bytes    : file 0x04103C..0x041081  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04103C  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
041040  57                    PUSH   di                           ; UNKNOWN
041041  56                    PUSH   si                           ; UNKNOWN
041042  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
041047  C7 46 FC 0F 27        MOV    word ptr [bp - 4], 0x270f    ; UNKNOWN
04104C  2B F6                 SUB    si, si                       ; UNKNOWN
04104E  39 36 14 3E           CMP    word ptr [0x3e14], si        ; UNKNOWN
041052  7E 44                 JLE    0x41098                      ; UNKNOWN
041054  BF 83 88              MOV    di, 0x8883                   ; UNKNOWN
041057  8A 05                 MOV    al, byte ptr [di]            ; UNKNOWN
041059  24 0F                 AND    al, 0xf                      ; UNKNOWN
04105B  3A 46 06              CMP    al, byte ptr [bp + 6]        ; UNKNOWN
04105E  75 2E                 JNE    0x4108e                      ; UNKNOWN
041060  39 76 08              CMP    word ptr [bp + 8], si        ; UNKNOWN
041063  74 29                 JE     0x4108e                      ; UNKNOWN
041065  8A 45 FE              MOV    al, byte ptr [di - 2]        ; UNKNOWN
041068  2A E4                 SUB    ah, ah                       ; UNKNOWN
04106A  2B 46 0C              SUB    ax, word ptr [bp + 0xc]      ; UNKNOWN
04106D  F7 D8                 NEG    ax                           ; UNKNOWN
04106F  50                    PUSH   ax                           ; UNKNOWN
041070  8A 45 FD              MOV    al, byte ptr [di - 3]        ; UNKNOWN
041073  2A E4                 SUB    ah, ah                       ; UNKNOWN
041075  2B 46 0A              SUB    ax, word ptr [bp + 0xa]      ; UNKNOWN
041078  F7 D8                 NEG    ax                           ; UNKNOWN
04107A  50                    PUSH   ax                           ; UNKNOWN
04107B  9A 3A 00 C2 44        LCALL  0x44c2, 0x3a                 ; UNKNOWN
041080  83                    DB     0x83                         ; UNKNOWN (raw)
