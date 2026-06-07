; ============================================================================
; func_00BEDE_unknown
; Region   : load_image
; Bytes    : file 0x00BEDE..0x00BF3B  (93 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BEDE  55                    PUSH   bp ; STACK_PUSH
00BEDF  8B EC                 MOV    bp, sp ; MOV
00BEE1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00BEE4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00BEE7  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00BEEC  8B E5                 MOV    sp, bp ; MOV
00BEEE  0B C0                 OR     ax, ax ; LOGIC
00BEF0  74 47                 JE     0xbf39 ; CJUMP
00BEF2  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
00BEF7  75 2D                 JNE    0xbf26 ; CJUMP
00BEF9  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
00BEFD  74 0B                 JE     0xbf0a ; CJUMP
00BEFF  83 3E 9C 92 00        CMP    word ptr [0x929c], 0 ; CMP
00BF04  74 04                 JE     0xbf0a ; CJUMP
00BF06  0E                    PUSH   cs ; STACK_PUSH
00BF07  E8 40 FE              CALL   0xbd4a ; CALL_NEAR
00BF0A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00BF0D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00BF10  0E                    PUSH   cs ; STACK_PUSH
00BF11  E8 14 FE              CALL   0xbd28 ; CALL_NEAR
00BF14  8B E5                 MOV    sp, bp ; MOV
00BF16  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
00BF1A  74 0A                 JE     0xbf26 ; CJUMP
00BF1C  C7 06 9C 92 00 00     MOV    word ptr [0x929c], 0 ; GLOBAL_LOAD
00BF22  0E                    PUSH   cs ; STACK_PUSH
00BF23  E8 24 FE              CALL   0xbd4a ; CALL_NEAR
00BF26  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BF29  A3 7C 01              MOV    word ptr [0x17c], ax ; GLOBAL_LOAD
00BF2C  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00BF2F  A3 7E 01              MOV    word ptr [0x17e], ax ; GLOBAL_LOAD
00BF32  6A 01                 PUSH   1 ; STACK_PUSH
00BF34  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
00BF39  C9                    LEAVE ; EPILOGUE
00BF3A  CB                    RETF ; RETURN
