; ============================================================================
; func_006608_unknown
; Region   : load_image
; Bytes    : file 0x006608..0x006672  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006608  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00660C  57                    PUSH   di ; STACK_PUSH
00660D  56                    PUSH   si ; STACK_PUSH
00660E  8B F0                 MOV    si, ax ; MOV
006610  BF 01 00              MOV    di, 1 ; MOV
006613  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006616  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
006619  80 BF 46 31 0F        CMP    byte ptr [bx + 0x3146], 0xf ; CMP
00661E  74 0E                 JE     0x662e ; CJUMP
006620  80 BF 46 31 10        CMP    byte ptr [bx + 0x3146], 0x10 ; CMP
006625  74 07                 JE     0x662e ; CJUMP
006627  80 BF 46 31 11        CMP    byte ptr [bx + 0x3146], 0x11 ; CMP
00662C  75 03                 JNE    0x6631 ; CJUMP
00662E  BF 02 00              MOV    di, 2 ; MOV
006631  6A 07                 PUSH   7 ; STACK_PUSH
006633  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
006637  25 0F 00              AND    ax, 0xf ; LOGIC
00663A  50                    PUSH   ax ; STACK_PUSH
00663B  9A 00 00 81 09        LCALL  0x981, 0 ; LCALL
006640  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006643  0B C0                 OR     ax, ax ; LOGIC
006645  74 14                 JE     0x665b ; CJUMP
006647  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00664A  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
00664F  72 07                 JB     0x6658 ; CJUMP
006651  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
006656  76 03                 JBE    0x665b ; CJUMP
006658  BF 02 00              MOV    di, 2 ; MOV
00665B  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00665E  80 BF 46 31 05        CMP    byte ptr [bx + 0x3146], 5 ; CMP
006663  75 01                 JNE    0x6666 ; CJUMP
006665  47                    INC    di ; ARITH
006666  8B C6                 MOV    ax, si ; MOV
006668  8B D7                 MOV    dx, di ; MOV
00666A  0E                    PUSH   cs ; STACK_PUSH
00666B  E8 56 FF              CALL   0x65c4 ; CALL_NEAR
00666E  5E                    POP    si ; STACK_POP
00666F  5F                    POP    di ; STACK_POP
006670  C9                    LEAVE ; EPILOGUE
006671  CB                    RETF ; RETURN
