; ============================================================================
; func_04C20C_unknown
; Region   : overlay
; Bytes    : file 0x04C20C..0x04C262  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C20C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
04C210  56                    PUSH   si ; STACK_PUSH
04C211  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
04C216  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
04C219  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C21C  C1 E3 04              SHL    bx, 4 ; LOGIC
04C21F  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
04C222  C1 E3 02              SHL    bx, 2 ; LOGIC
04C225  38 87 AC 9E           CMP    byte ptr [bx - 0x6154], al ; CMP
04C229  75 2B                 JNE    0x4c256 ; CJUMP
04C22B  8A 87 AB 9E           MOV    al, byte ptr [bx - 0x6155] ; MOV
04C22F  98                    CWDE ; ARITH
04C230  50                    PUSH   ax ; STACK_PUSH
04C231  8A 87 AA 9E           MOV    al, byte ptr [bx - 0x6156] ; MOV
04C235  98                    CWDE ; ARITH
04C236  50                    PUSH   ax ; STACK_PUSH
04C237  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
04C23A  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04C23D  8B F3                 MOV    si, bx ; MOV
04C23F  9A 7A 03 1F 18        LCALL  0x181f, 0x37a ; THUNK -> 0x024C:0x007C (thunk @file 0x01A96A type B) overlay @file 0x028802
04C244  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04C247  3B 46 0E              CMP    ax, word ptr [bp + 0xe] ; CMP
04C24A  7F 0A                 JG     0x4c256 ; CJUMP
04C24C  C6 84 AC 9E FF        MOV    byte ptr [si - 0x6154], 0xff ; CONST_LOAD
04C251  C6 84 AD 9E 00        MOV    byte ptr [si - 0x6153], 0 ; MOV
04C256  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
04C259  83 7E FC 10           CMP    word ptr [bp - 4], 0x10 ; CMP
04C25D  7C B7                 JL     0x4c216 ; CJUMP
04C25F  5E                    POP    si ; STACK_POP
04C260  C9                    LEAVE ; EPILOGUE
04C261  CB                    RETF ; RETURN
