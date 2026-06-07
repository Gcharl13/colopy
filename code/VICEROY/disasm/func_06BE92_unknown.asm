; ============================================================================
; func_06BE92_unknown
; Region   : overlay
; Bytes    : file 0x06BE92..0x06BF11  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "KING", "IND0A0"  (auto-named via string xrefs)
; ============================================================================

06BE92  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
06BE96  83 3E 5C 1F 07        CMP    word ptr [0x1f5c], 7 ; CMP
06BE9B  7E 2D                 JLE    0x6beca ; CJUMP
06BE9D  68 72 1F              PUSH   0x1f72                       ; STRING: "KING"
06BEA0  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
06BEA3  50                    PUSH   ax ; STACK_PUSH
06BEA4  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06BEA9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BEAC  B8 01 00              MOV    ax, 1 ; MOV
06BEAF  A3 6E 1F              MOV    word ptr [0x1f6e], ax ; GLOBAL_LOAD
06BEB2  A3 AE A5              MOV    word ptr [0xa5ae], ax ; GLOBAL_LOAD
06BEB5  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
06BEBA  05 F0 00              ADD    ax, 0xf0 ; ARITH
06BEBD  83 D2 00              ADC    dx, 0 ; ARITH
06BEC0  A3 B0 A5              MOV    word ptr [0xa5b0], ax ; GLOBAL_LOAD
06BEC3  89 16 B2 A5           MOV    word ptr [0xa5b2], dx ; GLOBAL_LOAD
06BEC7  EB 38                 JMP    0x6bf01 ; JUMP
06BEC9  90                    NOP ; NOP
06BECA  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
06BECE  FF 36 5C 1F           PUSH   word ptr [0x1f5c] ; PUSH_GLOBAL
06BED2  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
06BED7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BEDA  50                    PUSH   ax ; STACK_PUSH
06BEDB  9A 60 0A 1F 18        LCALL  0x181f, 0xa60 ; THUNK -> 0x05DC:0x00A2 (thunk @file 0x01B050 type B) overlay @file 0x021A84
06BEE0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06BEE3  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
06BEE6  68 77 1F              PUSH   0x1f77                       ; STRING: "IND0A0"
06BEE9  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
06BEEC  50                    PUSH   ax ; STACK_PUSH
06BEED  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06BEF2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BEF5  A0 5C 1F              MOV    al, byte ptr [0x1f5c] ; GLOBAL_LOAD
06BEF8  00 46 EF              ADD    byte ptr [bp - 0x11], al ; ARITH
06BEFB  8A 46 EA              MOV    al, byte ptr [bp - 0x16] ; LOCAL_LOAD
06BEFE  00 46 F1              ADD    byte ptr [bp - 0xf], al ; ARITH
06BF01  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06BF04  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06BF07  8D 5E EC              LEA    bx, [bp - 0x14] ; ADDR
06BF0A  E8 43 FF              CALL   0x6be50 ; CALL_NEAR
06BF0D  C9                    LEAVE ; EPILOGUE
06BF0E  C2 04 00              RET    4 ; RETURN
