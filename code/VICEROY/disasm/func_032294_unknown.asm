; ============================================================================
; func_032294_unknown
; Region   : overlay
; Bytes    : file 0x032294..0x0322CF  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032294  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
032298  50                    PUSH   ax ; STACK_PUSH
032299  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
03229E  7D 18                 JGE    0x322b8 ; CJUMP
0322A0  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
0322A5  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
0322AA  75 0C                 JNE    0x322b8 ; CJUMP
0322AC  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
0322AF  2A E4                 SUB    ah, ah ; ARITH
0322B1  48                    DEC    ax ; ARITH
0322B2  48                    DEC    ax ; ARITH
0322B3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0322B6  EB 05                 JMP    0x322bd ; JUMP
0322B8  C7 46 FE FE FF        MOV    word ptr [bp - 2], 0xfffe ; LOCAL_STORE
0322BD  C1 66 FE 04           SHL    word ptr [bp - 2], 4 ; LOGIC
0322C1  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0322C4  F7 6E FC              IMUL   word ptr [bp - 4] ; ARITH
0322C7  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
0322CA  99                    CDQ ; ARITH
0322CB  F7 F9                 IDIV   cx ; ARITH
0322CD  C9                    LEAVE ; EPILOGUE
0322CE  C3                    RET ; RETURN
