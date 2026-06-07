; ============================================================================
; func_03E664_unknown
; Region   : overlay
; Bytes    : file 0x03E664..0x03E673  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03E664  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
03E668  57                    PUSH   di ; STACK_PUSH
03E669  56                    PUSH   si ; STACK_PUSH
03E66A  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03E66F  74 03                 JE     0x3e674 ; CJUMP
03E671  E9                    DB     0xE9 ; DATA_BYTE
03E672  CB                    DB     0xCB ; DATA_BYTE
