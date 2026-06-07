; ============================================================================
; func_042E82_unknown
; Region   : load_image
; Bytes    : file 0x042E82..0x042F48  (198 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042E82  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
042E86  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
042E8A  80 C1 04              ADD    cl, 4                        ; UNKNOWN
042E8D  B0 01                 MOV    al, 1                        ; UNKNOWN
042E8F  D2 E0                 SHL    al, cl                       ; UNKNOWN
042E91  88 46 F7              MOV    byte ptr [bp - 9], al        ; UNKNOWN
042E94  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
042E97  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
042E9A  48                    DEC    ax                           ; UNKNOWN
042E9B  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
042E9E  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
042EA1  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
042EA4  48                    DEC    ax                           ; UNKNOWN
042EA5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
042EA8  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
042EAB  50                    PUSH   ax                           ; UNKNOWN
042EAC  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
042EAF  50                    PUSH   ax                           ; UNKNOWN
042EB0  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
042EB3  50                    PUSH   ax                           ; UNKNOWN
042EB4  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
042EB7  50                    PUSH   ax                           ; UNKNOWN
042EB8  9A 02 00 BE 17        LCALL  0x17be, 2                    ; UNKNOWN
042EBD  83 C4 08              ADD    sp, 8                        ; UNKNOWN
042EC0  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
042EC5  83 3E 12 3E 00        CMP    word ptr [0x3e12], 0         ; UNKNOWN
042ECA  7F 03                 JG     0x42ecf                      ; UNKNOWN
042ECC  E9 99 00              JMP    0x42f68                      ; UNKNOWN
042ECF  C7 46 FA DC 79        MOV    word ptr [bp - 6], 0x79dc    ; UNKNOWN
042ED4  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
042ED7  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
042ED9  2A E4                 SUB    ah, ah                       ; UNKNOWN
042EDB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
042EDE  8A 4F 01              MOV    cl, byte ptr [bx + 1]        ; UNKNOWN
042EE1  2A ED                 SUB    ch, ch                       ; UNKNOWN
042EE3  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
042EE6  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
042EE9  7C 6B                 JL     0x42f56                      ; UNKNOWN
042EEB  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
042EEE  7C 66                 JL     0x42f56                      ; UNKNOWN
042EF0  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
042EF3  3B C8                 CMP    cx, ax                       ; UNKNOWN
042EF5  7C 5F                 JL     0x42f56                      ; UNKNOWN
042EF7  8B C1                 MOV    ax, cx                       ; UNKNOWN
042EF9  39 46 F2              CMP    word ptr [bp - 0xe], ax      ; UNKNOWN
042EFC  7C 58                 JL     0x42f56                      ; UNKNOWN
042EFE  50                    PUSH   ax                           ; UNKNOWN
042EFF  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
042F02  9A E8 02 C9 33        LCALL  0x33c9, 0x2e8                ; UNKNOWN
042F07  83 C4 04              ADD    sp, 4                        ; UNKNOWN
042F0A  84 46 F7              TEST   byte ptr [bp - 9], al        ; UNKNOWN
042F0D  75 07                 JNE    0x42f16                      ; UNKNOWN
042F0F  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
042F14  74 40                 JE     0x42f56                      ; UNKNOWN
042F16  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
042F1A  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
042F1E  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
042F22  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
042F26  FF 36 36 0B           PUSH   word ptr [0xb36]             ; UNKNOWN
042F2A  A1 82 82              MOV    ax, word ptr [0x8282]        ; UNKNOWN
042F2D  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
042F31  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
042F34  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
042F38  8B D0                 MOV    dx, ax                       ; UNKNOWN
042F3A  A1 84 82              MOV    ax, word ptr [0x8284]        ; UNKNOWN
042F3D  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
042F41  03 46 FE              ADD    ax, word ptr [bp - 2]        ; UNKNOWN
042F44  8B CA                 MOV    cx, dx                       ; UNKNOWN
042F46  F7                    DB     0xF7                         ; UNKNOWN (raw)
042F47  2E                    DB     0x2E                         ; UNKNOWN (raw)
