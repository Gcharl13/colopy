; ============================================================================
; func_067476_unknown
; Region   : overlay
; Bytes    : file 0x067476..0x0674A8  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067476  55                    PUSH   bp ; STACK_PUSH
067477  8B EC                 MOV    bp, sp ; MOV
067479  83 3E A2 1E 00        CMP    word ptr [0x1ea2], 0 ; CMP
06747E  74 1A                 JE     0x6749a ; CJUMP
067480  6A 00                 PUSH   0 ; STACK_PUSH
067482  6A 01                 PUSH   1 ; STACK_PUSH
067484  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
067488  0E                    PUSH   cs ; STACK_PUSH
067489  E8 B3 01              CALL   0x6763f ; CALL_NEAR
06748C  8B E5                 MOV    sp, bp ; MOV
06748E  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
067492  74 12                 JE     0x674a6 ; CJUMP
067494  6A 01                 PUSH   1 ; STACK_PUSH
067496  6A 01                 PUSH   1 ; STACK_PUSH
067498  EB 04                 JMP    0x6749e ; JUMP
06749A  6A 00                 PUSH   0 ; STACK_PUSH
06749C  6A 00                 PUSH   0 ; STACK_PUSH
06749E  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
0674A2  0E                    PUSH   cs ; STACK_PUSH
0674A3  E8 99 01              CALL   0x6763f ; CALL_NEAR
0674A6  C9                    LEAVE ; EPILOGUE
0674A7  CB                    RETF ; RETURN
