; ============================================================================
; func_02D606_unknown
; Region   : overlay
; Bytes    : file 0x02D606..0x02D657  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D606  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
02D60A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02D60F  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
02D613  74 3D                 JE     0x2d652 ; CJUMP
02D615  83 7E 06 05           CMP    word ptr [bp + 6], 5 ; CMP
02D619  74 37                 JE     0x2d652 ; CJUMP
02D61B  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
02D61F  74 31                 JE     0x2d652 ; CJUMP
02D621  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe ; CMP
02D625  74 2B                 JE     0x2d652 ; CJUMP
02D627  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf ; CMP
02D62B  74 25                 JE     0x2d652 ; CJUMP
02D62D  83 7E 06 06           CMP    word ptr [bp + 6], 6 ; CMP
02D631  75 1A                 JNE    0x2d64d ; CJUMP
02D633  6A 03                 PUSH   3 ; STACK_PUSH
02D635  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
02D63A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02D63D  0B C0                 OR     ax, ax ; LOGIC
02D63F  75 11                 JNE    0x2d652 ; CJUMP
02D641  39 06 E4 8D           CMP    word ptr [0x8de4], ax ; CMP
02D645  75 0B                 JNE    0x2d652 ; CJUMP
02D647  39 06 E6 8D           CMP    word ptr [0x8de6], ax ; CMP
02D64B  75 05                 JNE    0x2d652 ; CJUMP
02D64D  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
02D652  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
02D655  C9                    LEAVE ; EPILOGUE
02D656  CB                    RETF ; RETURN
