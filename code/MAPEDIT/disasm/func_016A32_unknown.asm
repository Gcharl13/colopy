; ============================================================================
; func_016A32_unknown
; Region   : load_image
; Bytes    : file 0x016A32..0x016A52  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016A32  55                    PUSH   bp ; STACK_PUSH
016A33  8B EC                 MOV    bp, sp ; MOV
016A35  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
016A38  3B 1E 75 45           CMP    bx, word ptr [0x4575] ; CMP
016A3C  72 06                 JB     0x16a44 ; CJUMP
016A3E  B8 00 09              MOV    ax, 0x900 ; CONST_LOAD
016A41  F9                    STC ; FLAG
016A42  EB 0B                 JMP    0x16a4f ; JUMP
016A44  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
016A46  CD 21                 INT    0x21 ; SYS
016A48  72 05                 JB     0x16a4f ; CJUMP
016A4A  C6 87 77 45 00        MOV    byte ptr [bx + 0x4577], 0 ; MOV
016A4F  E9 66 F6              JMP    0x160b8 ; JUMP
