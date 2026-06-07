; ============================================================================
; func_00CA0C_unknown
; Region   : load_image
; Bytes    : file 0x00CA0C..0x00CA56  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CA0C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00CA10  53                    PUSH   bx ; STACK_PUSH
00CA11  51                    PUSH   cx ; STACK_PUSH
00CA12  52                    PUSH   dx ; STACK_PUSH
00CA13  06                    PUSH   es ; STACK_PUSH
00CA14  6A 00                 PUSH   0 ; STACK_PUSH
00CA16  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00CA19  9A 00 00 11 0D        LCALL  0xd11, 0 ; LCALL
00CA1E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00CA21  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
00CA24  A3 00 93              MOV    word ptr [0x9300], ax ; GLOBAL_LOAD
00CA27  A3 02 93              MOV    word ptr [0x9302], ax ; GLOBAL_LOAD
00CA2A  B8 D4 06              MOV    ax, 0x6d4 ; CONST_LOAD
00CA2D  A3 04 93              MOV    word ptr [0x9304], ax ; GLOBAL_LOAD
00CA30  B8 5A 1B              MOV    ax, 0x1b5a ; CONST_LOAD
00CA33  A3 06 93              MOV    word ptr [0x9306], ax ; GLOBAL_LOAD
00CA36  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00CA39  A3 08 93              MOV    word ptr [0x9308], ax ; GLOBAL_LOAD
00CA3C  C7 06 AC 83 00 00     MOV    word ptr [0x83ac], 0 ; GLOBAL_LOAD
00CA42  C7 06 F8 92 00 00     MOV    word ptr [0x92f8], 0 ; GLOBAL_LOAD
00CA48  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00CA4D  B8 33 35              MOV    ax, 0x3533 ; CONST_LOAD
00CA50  CD 21                 INT    0x21 ; SYS
00CA52  8C C0                 MOV    ax, es ; MOV
00CA54  0B C3                 OR     ax, bx ; LOGIC
