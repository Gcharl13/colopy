; ============================================================================
; func_044AD0_unknown
; Region   : load_image
; Bytes    : file 0x044AD0..0x044B3A  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044AD0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
044AD4  52                    PUSH   dx                           ; UNKNOWN
044AD5  50                    PUSH   ax                           ; UNKNOWN
044AD6  C7 46 FC 08 00        MOV    word ptr [bp - 4], 8         ; UNKNOWN
044ADB  0B C0                 OR     ax, ax                       ; UNKNOWN
044ADD  7E 05                 JLE    0x44ae4                      ; UNKNOWN
044ADF  B8 01 00              MOV    ax, 1                        ; UNKNOWN
044AE2  EB 0B                 JMP    0x44aef                      ; UNKNOWN
044AE4  0B C0                 OR     ax, ax                       ; UNKNOWN
044AE6  7C 04                 JL     0x44aec                      ; UNKNOWN
044AE8  2B C0                 SUB    ax, ax                       ; UNKNOWN
044AEA  EB 03                 JMP    0x44aef                      ; UNKNOWN
044AEC  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
044AEF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
044AF2  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
044AF6  7E 05                 JLE    0x44afd                      ; UNKNOWN
044AF8  B8 01 00              MOV    ax, 1                        ; UNKNOWN
044AFB  EB 0D                 JMP    0x44b0a                      ; UNKNOWN
044AFD  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
044B01  7C 04                 JL     0x44b07                      ; UNKNOWN
044B03  2B C0                 SUB    ax, ax                       ; UNKNOWN
044B05  EB 03                 JMP    0x44b0a                      ; UNKNOWN
044B07  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
044B0A  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
044B0D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
044B12  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
044B15  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
044B19  98                    CWDE                                ; UNKNOWN
044B1A  3B 46 F8              CMP    ax, word ptr [bp - 8]        ; UNKNOWN
044B1D  75 0D                 JNE    0x44b2c                      ; UNKNOWN
044B1F  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
044B23  98                    CWDE                                ; UNKNOWN
044B24  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
044B27  75 03                 JNE    0x44b2c                      ; UNKNOWN
044B29  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
044B2C  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
044B2F  83 7E FE 08           CMP    word ptr [bp - 2], 8         ; UNKNOWN
044B33  7C DD                 JL     0x44b12                      ; UNKNOWN
044B35  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
044B38  C9                    LEAVE                               ; UNKNOWN
044B39  CB                    RETF                                ; UNKNOWN
