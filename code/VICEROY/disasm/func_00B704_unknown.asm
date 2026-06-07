; ============================================================================
; func_00B704_unknown
; Region   : load_image
; Bytes    : file 0x00B704..0x00B72D  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B704  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
00B708  56                    PUSH   si ; STACK_PUSH
00B709  C7 46 FE FE FF        MOV    word ptr [bp - 2], 0xfffe ; LOCAL_STORE
00B70E  83 7E 06 13           CMP    word ptr [bp + 6], 0x13 ; CMP
00B712  7C 03                 JL     0xb717 ; CJUMP
00B714  E9 8F 00              JMP    0xb7a6 ; JUMP
00B717  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B71A  0E                    PUSH   cs ; STACK_PUSH
00B71B  E8 7E D6              CALL   0x8d9c ; CALL_NEAR
00B71E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00B721  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
00B724  0B C0                 OR     ax, ax ; LOGIC
00B726  7C 0F                 JL     0xb737 ; CJUMP
00B728  50                    PUSH   ax ; STACK_PUSH
00B729  0E                    PUSH   cs ; STACK_PUSH
00B72A  E8 11 CF              CALL   0x863e ; CALL_NEAR
