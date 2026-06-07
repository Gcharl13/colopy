; ============================================================================
; func_012C8C_unknown
; Region   : load_image
; Bytes    : file 0x012C8C..0x012CC8  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012C8C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
012C90  50                    PUSH   ax ; STACK_PUSH
012C91  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
012C94  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
012C97  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
012C9C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012C9F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
012CA2  1E                    PUSH   ds ; STACK_PUSH
012CA3  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
012CA6  BB 01 00              MOV    bx, 1 ; MOV
012CA9  C5 56 06              LDS    dx, ptr [bp + 6] ; MOV_FAR
012CAC  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
012CAE  CD 21                 INT    0x21 ; SYS
012CB0  1F                    POP    ds ; STACK_POP
012CB1  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
012CB4  0B C0                 OR     ax, ax ; LOGIC
012CB6  74 0C                 JE     0x12cc4 ; CJUMP
012CB8  B2 0A                 MOV    dl, 0xa ; CONST_LOAD
012CBA  B4 02                 MOV    ah, 2 ; MOV
012CBC  CD 21                 INT    0x21 ; SYS
012CBE  B2 0D                 MOV    dl, 0xd ; CONST_LOAD
012CC0  B4 02                 MOV    ah, 2 ; MOV
012CC2  CD 21                 INT    0x21 ; SYS
012CC4  C9                    LEAVE ; EPILOGUE
012CC5  CA 04 00              RETF   4 ; RETURN
