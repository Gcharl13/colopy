; ============================================================================
; func_00E46C_unknown
; Region   : load_image
; Bytes    : file 0x00E46C..0x00E49C  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E46C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00E470  56                    PUSH   si ; STACK_PUSH
00E471  8B F3                 MOV    si, bx ; MOV
00E473  80 3C 30              CMP    byte ptr [si], 0x30 ; CMP
00E476  75 42                 JNE    0xe4ba ; CJUMP
00E478  8A 5C 01              MOV    bl, byte ptr [si + 1] ; MOV
00E47B  88 5E FF              MOV    byte ptr [bp - 1], bl ; LOCAL_STORE
00E47E  2A FF                 SUB    bh, bh ; ARITH
00E480  F6 87 ED 27 02        TEST   byte ptr [bx + 0x27ed], 2 ; LOGIC
00E485  74 04                 JE     0xe48b ; CJUMP
00E487  80 6E FF 20           SUB    byte ptr [bp - 1], 0x20 ; ARITH
00E48B  80 7E FF 58           CMP    byte ptr [bp - 1], 0x58 ; CMP
00E48F  75 0B                 JNE    0xe49c ; CJUMP
00E491  8D 5C 02              LEA    bx, [si + 2] ; ADDR
00E494  9A 0A 00 9A 10        LCALL  0x109a, 0xa ; LCALL
00E499  5E                    POP    si ; STACK_POP
00E49A  C9                    LEAVE ; EPILOGUE
00E49B  CB                    RETF ; RETURN
