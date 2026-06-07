; ============================================================================
; func_04D34C_unknown
; Region   : load_image
; Bytes    : file 0x04D34C..0x04D37F  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04D34C  C8 6A 00 00           ENTER  0x6a, 0                      ; UNKNOWN
04D350  56                    PUSH   si                           ; UNKNOWN
04D351  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04D354  0E                    PUSH   cs                           ; UNKNOWN
04D355  E8 9C FE              CALL   0x4d1f4                      ; UNKNOWN
04D358  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D35B  C7 46 AA 02 00        MOV    word ptr [bp - 0x56], 2      ; UNKNOWN
04D360  C7 46 A8 2A 00        MOV    word ptr [bp - 0x58], 0x2a   ; UNKNOWN
04D365  2B C0                 SUB    ax, ax                       ; UNKNOWN
04D367  89 46 AE              MOV    word ptr [bp - 0x52], ax     ; UNKNOWN
04D36A  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
04D36D  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04D370  E9 6F 02              JMP    0x4d5e2                      ; UNKNOWN
04D373  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
04D376  6A 00                 PUSH   0                            ; UNKNOWN
04D378  6A 64                 PUSH   0x64                         ; UNKNOWN
04D37A  8B 5E AA              MOV    bx, word ptr [bp - 0x56]     ; UNKNOWN
04D37D  83                    DB     0x83                         ; UNKNOWN (raw)
04D37E  C3                    DB     0xC3                         ; UNKNOWN (raw)
