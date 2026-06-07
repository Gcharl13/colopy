; ============================================================================
; func_038948_unknown
; Region   : load_image
; Bytes    : file 0x038948..0x0389C3  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038948  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
03894C  56                    PUSH   si                           ; UNKNOWN
03894D  C7 46 A8 00 00        MOV    word ptr [bp - 0x58], 0      ; UNKNOWN
038952  8B 1E 9A 79           MOV    bx, word ptr [0x799a]        ; UNKNOWN
038956  80 BF AE 86 00        CMP    byte ptr [bx - 0x7952], 0    ; UNKNOWN
03895B  75 03                 JNE    0x38960                      ; UNKNOWN
03895D  E9 49 02              JMP    0x38ba9                      ; UNKNOWN
038960  83 3E 06 3E 1E        CMP    word ptr [0x3e06], 0x1e      ; UNKNOWN
038965  7D 03                 JGE    0x3896a                      ; UNKNOWN
038967  E9 3F 02              JMP    0x38ba9                      ; UNKNOWN
03896A  C7 46 A4 12 00        MOV    word ptr [bp - 0x5c], 0x12   ; UNKNOWN
03896F  81 3E 02 3E 40 06     CMP    word ptr [0x3e02], 0x640     ; UNKNOWN
038975  7E 05                 JLE    0x3897c                      ; UNKNOWN
038977  C7 46 A4 0F 00        MOV    word ptr [bp - 0x5c], 0xf    ; UNKNOWN
03897C  81 3E 02 3E A4 06     CMP    word ptr [0x3e02], 0x6a4     ; UNKNOWN
038982  7E 04                 JLE    0x38988                      ; UNKNOWN
038984  83 6E A4 03           SUB    word ptr [bp - 0x5c], 3      ; UNKNOWN
038988  81 3E 02 3E D6 06     CMP    word ptr [0x3e02], 0x6d6     ; UNKNOWN
03898E  7E 04                 JLE    0x38994                      ; UNKNOWN
038990  83 6E A4 03           SUB    word ptr [bp - 0x5c], 3      ; UNKNOWN
038994  83 FB 04              CMP    bx, 4                        ; UNKNOWN
038997  7D 16                 JGE    0x389af                      ; UNKNOWN
038999  6B DB 34              IMUL   bx, bx, 0x34                 ; UNKNOWN
03899C  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0389A1  75 0C                 JNE    0x389af                      ; UNKNOWN
0389A3  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0389A6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0389A8  48                    DEC    ax                           ; UNKNOWN
0389A9  48                    DEC    ax                           ; UNKNOWN
0389AA  89 46 9E              MOV    word ptr [bp - 0x62], ax     ; UNKNOWN
0389AD  EB 05                 JMP    0x389b4                      ; UNKNOWN
0389AF  C7 46 9E 00 00        MOV    word ptr [bp - 0x62], 0      ; UNKNOWN
0389B4  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
0389B7  8B 4E A4              MOV    cx, word ptr [bp - 0x5c]     ; UNKNOWN
0389BA  8B 56 9E              MOV    dx, word ptr [bp - 0x62]     ; UNKNOWN
0389BD  D1 E2                 SHL    dx, 1                        ; UNKNOWN
0389BF  2B CA                 SUB    cx, dx                       ; UNKNOWN
0389C1  89                    DB     0x89                         ; UNKNOWN (raw)
0389C2  4E                    DB     0x4E                         ; UNKNOWN (raw)
