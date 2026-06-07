; ============================================================================
; func_03D3E8_unknown
; Region   : load_image
; Bytes    : file 0x03D3E8..0x03D425  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D3E8  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03D3EC  6A 30                 PUSH   0x30                         ; UNKNOWN
03D3EE  6A 01                 PUSH   1                            ; UNKNOWN
03D3F0  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D3F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D3F8  40                    INC    ax                           ; UNKNOWN
03D3F9  40                    INC    ax                           ; UNKNOWN
03D3FA  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D3FD  E9 D9 00              JMP    0x3d4d9                      ; UNKNOWN
03D400  A0 56 85              MOV    al, byte ptr [0x8556]        ; UNKNOWN
03D403  98                    CWDE                                ; UNKNOWN
03D404  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D407  7C 03                 JL     0x3d40c                      ; UNKNOWN
03D409  E9 DA 00              JMP    0x3d4e6                      ; UNKNOWN
03D40C  A0 54 85              MOV    al, byte ptr [0x8554]        ; UNKNOWN
03D40F  98                    CWDE                                ; UNKNOWN
03D410  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D413  7F 03                 JG     0x3d418                      ; UNKNOWN
03D415  E9 CE 00              JMP    0x3d4e6                      ; UNKNOWN
03D418  A0 57 85              MOV    al, byte ptr [0x8557]        ; UNKNOWN
03D41B  98                    CWDE                                ; UNKNOWN
03D41C  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03D41F  7C 03                 JL     0x3d424                      ; UNKNOWN
03D421  E9 C2 00              JMP    0x3d4e6                      ; UNKNOWN
03D424  A0                    DB     0xA0                         ; UNKNOWN (raw)
