; ============================================================================
; func_00CDD4_unknown
; Region   : load_image
; Bytes    : file 0x00CDD4..0x00CDE5  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CDD4  55                    PUSH   bp ; STACK_PUSH
00CDD5  8B EC                 MOV    bp, sp ; MOV
00CDD7  6A 00                 PUSH   0 ; STACK_PUSH
00CDD9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00CDDC  6A 27                 PUSH   0x27 ; PUSH_CONST
00CDDE  6A 38                 PUSH   0x38 ; PUSH_CONST
00CDE0  FF 36 C2 49           PUSH   word ptr [0x49c2] ; PUSH_GLOBAL
00CDE4  FF                    DB     0xFF ; DATA_BYTE
