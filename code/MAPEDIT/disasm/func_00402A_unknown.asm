; ============================================================================
; func_00402A_unknown
; Region   : load_image
; Bytes    : file 0x00402A..0x004073  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00402A  55                    PUSH   bp ; STACK_PUSH
00402B  8B EC                 MOV    bp, sp ; MOV
00402D  57                    PUSH   di ; STACK_PUSH
00402E  56                    PUSH   si ; STACK_PUSH
00402F  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
004032  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
004035  26 80 3C 2A           CMP    byte ptr es:[si], 0x2a ; CMP
004039  75 03                 JNE    0x403e ; CJUMP
00403B  46                    INC    si ; ARITH
00403C  8C C0                 MOV    ax, es ; MOV
00403E  83 3E 9C 04 00        CMP    word ptr [0x49c], 0 ; CMP
004043  75 13                 JNE    0x4058 ; CJUMP
004045  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
004048  06                    PUSH   es ; STACK_PUSH
004049  56                    PUSH   si ; STACK_PUSH
00404A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00404D  57                    PUSH   di ; STACK_PUSH
00404E  9A EC 0D 88 13        LCALL  0x1388, 0xdec ; LCALL
004053  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004056  EB 12                 JMP    0x406a ; JUMP
004058  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00405B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00405E  57                    PUSH   di ; STACK_PUSH
00405F  1E                    PUSH   ds ; STACK_PUSH
004060  68 AA 4E              PUSH   0x4eaa ; PUSH_CONST
004063  06                    PUSH   es ; STACK_PUSH
004064  56                    PUSH   si ; STACK_PUSH
004065  9A 04 00 11 0C        LCALL  0xc11, 4 ; LCALL
00406A  8B C7                 MOV    ax, di ; MOV
00406C  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00406F  5E                    POP    si ; STACK_POP
004070  5F                    POP    di ; STACK_POP
004071  C9                    LEAVE ; EPILOGUE
004072  CB                    RETF ; RETURN
