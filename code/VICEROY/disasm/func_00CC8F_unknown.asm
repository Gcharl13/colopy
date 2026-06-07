; ============================================================================
; func_00CC8F_unknown
; Region   : load_image
; Bytes    : file 0x00CC8F..0x00CCEB  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CC8F  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CC93  8B C1                 MOV    ax, cx ; MOV
00CC95  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
00CC98  D1 E1                 SHL    cx, 1 ; LOGIC
00CC9A  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00CC9D  50                    PUSH   ax ; STACK_PUSH
00CC9E  51                    PUSH   cx ; STACK_PUSH
00CC9F  52                    PUSH   dx ; STACK_PUSH
00CCA0  83 3E F8 92 00        CMP    word ptr [0x92f8], 0 ; CMP
00CCA5  75 08                 JNE    0xccaf ; CJUMP
00CCA7  9A 54 00 58 0A        LCALL  0xa58, 0x54 ; LCALL
00CCAC  EB 06                 JMP    0xccb4 ; JUMP
00CCAE  90                    NOP ; NOP
00CCAF  9A CE 02 58 0A        LCALL  0xa58, 0x2ce ; LCALL
00CCB4  5A                    POP    dx ; STACK_POP
00CCB5  59                    POP    cx ; STACK_POP
00CCB6  58                    POP    ax ; STACK_POP
00CCB7  A3 FC 92              MOV    word ptr [0x92fc], ax ; GLOBAL_LOAD
00CCBA  89 16 FE 92           MOV    word ptr [0x92fe], dx ; GLOBAL_LOAD
00CCBE  83 3E AC 83 00        CMP    word ptr [0x83ac], 0 ; CMP
00CCC3  74 10                 JE     0xccd5 ; CJUMP
00CCC5  51                    PUSH   cx ; STACK_PUSH
00CCC6  52                    PUSH   dx ; STACK_PUSH
00CCC7  B8 04 00              MOV    ax, 4 ; MOV
00CCCA  CD 33                 INT    0x33 ; SYS
00CCCC  5A                    POP    dx ; STACK_POP
00CCCD  59                    POP    cx ; STACK_POP
00CCCE  83 3E F8 92 00        CMP    word ptr [0x92f8], 0 ; CMP
00CCD3  75 08                 JNE    0xccdd ; CJUMP
00CCD5  9A 0D 00 58 0A        LCALL  0xa58, 0xd ; LCALL
00CCDA  EB 0D                 JMP    0xcce9 ; JUMP
00CCDC  90                    NOP ; NOP
00CCDD  FA                    CLI ; FLAG
00CCDE  9A 07 02 58 0A        LCALL  0xa58, 0x207 ; LCALL
00CCE3  FB                    STI ; FLAG
00CCE4  9A E0 02 58 0A        LCALL  0xa58, 0x2e0 ; LCALL
00CCE9  C9                    LEAVE ; EPILOGUE
00CCEA  CB                    RETF ; RETURN
