; ============================================================================
; func_005108_unknown
; Region   : load_image
; Bytes    : file 0x005108..0x00513B  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005108  55                    PUSH   bp ; STACK_PUSH
005109  8B EC                 MOV    bp, sp ; MOV
00510B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00510E  0E                    PUSH   cs ; STACK_PUSH
00510F  E8 DE FF              CALL   0x50f0 ; CALL_NEAR
005112  8B E5                 MOV    sp, bp ; MOV
005114  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005117  39 06 9C 00           CMP    word ptr [0x9c], ax ; CMP
00511B  74 1C                 JE     0x5139 ; CJUMP
00511D  83 3E A0 00 00        CMP    word ptr [0xa0], 0 ; CMP
005122  74 0D                 JE     0x5131 ; CJUMP
005124  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
005129  75 06                 JNE    0x5131 ; CJUMP
00512B  C7 06 9E 00 01 00     MOV    word ptr [0x9e], 1 ; GLOBAL_LOAD
005131  B8 01 00              MOV    ax, 1 ; MOV
005134  9A 0E 00 D8 02        LCALL  0x2d8, 0xe ; LCALL
005139  C9                    LEAVE ; EPILOGUE
00513A  CB                    RETF ; RETURN
